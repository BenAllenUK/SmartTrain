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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.delegate = self
        beaconManager.register(uuid: TRAINZ)
    }

    func currentBeaconChanged(beacon: CLBeacon?) {
        if let beacon = beacon {
            beaconInfoLabel.text = "\(beacon.proximityUUID)\n\(beacon.major)\n\(beacon.minor)"
        } else {
            beaconInfoLabel.text = "you are not on a train"
        }
    }

}

