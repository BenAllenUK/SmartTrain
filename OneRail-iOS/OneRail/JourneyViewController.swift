//
//  JourneyViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 06/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class JourneyViewController : UIViewController, BeaconManagerDelegate {
    
    var beaconManager: BeaconManager {
        return (UIApplication.shared.delegate as! AppDelegate).beaconManager
    }
    
    var networkManager: NetworkManager {
        return (UIApplication.shared.delegate as! AppDelegate).networkManager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beaconManager.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func currentBeaconChanged(beacon: CLBeacon?) {
        if let beacon = beacon, beacon.major.intValue == STATION_MAYOR {
            beaconManager.delegate = nil
            self.performSegue(withIdentifier: "Journey2Feedback", sender: self)
            networkManager.notifyBeaconDetection(beacon: beacon, userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        }
    }
    
}
