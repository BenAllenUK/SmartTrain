//
//  Splash2Platform.swift
//  OneRail
//
//  Created by Danny Bravo on 06/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class PlatformViewController : UIViewController, BeaconManagerDelegate {
    
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
        if let beacon = beacon, beacon.major.intValue == TRAIN_MAYOR {
            beaconManager.delegate = nil
            self.performSegue(withIdentifier: "Platform2Train", sender: self)
            networkManager.notifyBeaconDetection(beacon: beacon, userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        } else {
            beaconManager.deregister(uuid: TRAINZ)
            beaconManager.delegate = nil
            let _ = self.navigationController?.popToRootViewController(animated: true)
            networkManager.notifyBeaconSignalLost(userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        }
    }
    
}
