//
//  BeaconManager.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import CoreLocation

private let IGNORE = [24210, 31101]

extension CLProximity {
    var description: String {
        switch self {
        case .far:
            return "far"
        case .immediate:
            return "immediate"
        case .near:
            return "near"
        case .unknown:
            return "unknown"
        }
    }
}

private let TIME_INTERVAL: TimeInterval = 10

func ==(left: BeaconDetection, right: BeaconDetection) -> Bool {
    return left.beacon.isEqual(beacon: right.beacon)
}

class BeaconDetection: Hashable, Equatable {
    var beacon: CLBeacon
    var date = Date()
    
    init(beacon: CLBeacon) {
        self.beacon = beacon
    }
    
    var hashValue: Int {
        return beacon.major.hashValue + beacon.minor.hashValue
    }
    
}

extension CLBeacon {
    
    func isEqual(beacon: CLBeacon) -> Bool {
        return self.major == beacon.major && self.minor == beacon.minor
    }
    
}

protocol BeaconManagerDelegate: class {
    func currentBeaconChanged(beacon: CLBeacon?)
}

final class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentBeacon: CLBeacon? {
        didSet {
            let newBeacon = currentBeacon
            if oldValue != newBeacon {
                delegate?.currentBeaconChanged(beacon: newBeacon)
            }
        }
    }
    var detectedBeacons = Set<BeaconDetection>()
    weak var delegate: BeaconManagerDelegate?
    
    override init() {
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
    
    func register(uuid: String) {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid)!, identifier: "com.hacktrain.onerail")
        locationManager.startUpdatingLocation()
        locationManager.startRangingBeacons(in: region)
    }
    
    func deregister(uuid: String) {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid)!, identifier: "com.hacktrain.onerail")
        locationManager.stopUpdatingLocation()
        locationManager.stopRangingBeacons(in: region)

    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("---------------")
        
        for beacon in beacons {
            if IGNORE.contains(beacon.major.intValue) {
                continue
            }
            print("beacon \(beacon.major).\(beacon.minor) - accuracy: \(beacon.accuracy) proximity: \(beacon.proximity.description) rssi: \(beacon.rssi)")
            
            var didDetect: Bool = false
            for detection in detectedBeacons {
                if detection.beacon.isEqual(beacon: beacon) {
                    if beacon.proximity != .unknown {
                        detection.beacon = beacon
                        detection.date = Date()
                    }
                    didDetect = true
                    break
                }
            }
            if !didDetect {
                detectedBeacons.insert(BeaconDetection(beacon: beacon))
            }
        }
        
        detectedBeacons = Set<BeaconDetection>(detectedBeacons.filter({ (detection) -> Bool in
            return Date().timeIntervalSince(detection.date) < TIME_INTERVAL
        }))
        
        var closestDistance: CLLocationDistance = DBL_MAX
        var closestBeacon: CLBeacon?
        for detection in detectedBeacons {
            if detection.beacon.accuracy < closestDistance {
                closestDistance = detection.beacon.accuracy
                closestBeacon = detection.beacon
            }
        }
        self.currentBeacon = closestBeacon
    }
    
    
}
