//
//  ViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, BeaconManagerDelegate {

    @IBOutlet weak var beaconInfoLabel: UILabel!
    
    var beaconManager: BeaconManager {
        return (UIApplication.shared.delegate as! AppDelegate).beaconManager
    }
    
    var networkManager: NetworkManager {
        return (UIApplication.shared.delegate as! AppDelegate).networkManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beaconManager.register(uuid: TRAINZ)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        beaconManager.deregister(uuid: TRAINZ)
    }

    func currentBeaconChanged(beacon: CLBeacon?) {
        if let beacon = beacon {
            print(beacon)
            beaconInfoLabel.text = "\(beacon.proximityUUID)\n\(beacon.major)\n\(beacon.minor)"
            networkManager.notifyBeaconDetection(beacon: beacon, userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        } else {
            print("no beacon")
            beaconInfoLabel.text = "you are not on a train"
            networkManager.notifyBeaconSignalLost(userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}

