//
//  BeaconManager.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import CoreLocation

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

//extension CLBeacon {
//    
//    func isEqual(beacon: CLBeacon) -> Bool {
//        return self.proximityUUID == beacon.proximityUUID && self.major == beacon.major && self.minor == beacon.minor
//    }
//    
//}

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
    var detectedBeacons = Set<CLBeacon>()
    weak var delegate: BeaconManagerDelegate?
    
    override init() {
        super.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
    
    func register(uuid: String) {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuid)!, identifier: "com.hacktrain.onerail")
        self.locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("---------------")
        
        for beacon in beacons {
            print("beacon \(beacon.major).\(beacon.minor) - accuracy: \(beacon.accuracy) proximity: \(beacon.proximity.description) rssi: \(beacon.rssi)")
            
            var newBeacons = Set<CLBeacon>()
            var didDetect: Bool = false
            for storedBeacon in detectedBeacons {
                if storedBeacon == beacon {
                    if beacon.proximity == .unknown {
                        newBeacons.insert(storedBeacon)
                    } else {
                        newBeacons.insert(beacon)
                    }
                    didDetect = true
                    break
                }
            }
            if !didDetect {
                newBeacons.insert(beacon)
            }
            detectedBeacons = newBeacons
        }
        
        var closestDistance: CLLocationDistance = DBL_MAX
        var closestBeacon: CLBeacon?
        for beacon in detectedBeacons {
            if beacon.accuracy < closestDistance {
                closestDistance = beacon.accuracy
                closestBeacon = beacon
            }
        }
        self.currentBeacon = closestBeacon
    }
    
    
}
