//
//  SplashViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

final class SplashViewController : UIViewController, BeaconManagerDelegate {
    
    @IBOutlet weak var bluetoothImage: UIImageView!
    @IBOutlet weak var spinnerBackground: UIImageView!
    @IBOutlet weak var spinnerForeground: UIImageView!
    var didDismiss: Bool = false
    
    var beaconManager: BeaconManager {
        return (UIApplication.shared.delegate as! AppDelegate).beaconManager
    }
    
    var networkManager: NetworkManager {
        return (UIApplication.shared.delegate as! AppDelegate).networkManager
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beaconManager.delegate = self
        animateBlueTooth()
        animateSpinnerPresentation()
        animateSpinner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDismiss = true
        self.bluetoothImage.layer.removeAllAnimations()
        self.bluetoothImage.layer.removeAllAnimations()
        self.bluetoothImage.alpha = 0
        self.spinnerForeground.alpha = 0
        self.spinnerBackground.alpha = 0
    }
    
    func animateBlueTooth() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.bluetoothImage.alpha = 1.0
        }, completion: nil)
    }
    
    func animateSpinnerPresentation() {
        UIView.animate(withDuration: 3.0, delay: 0, options: [.curveEaseInOut], animations: {
            self.spinnerBackground.alpha = 1.0
            self.spinnerForeground.alpha = 1.0
        }, completion: nil)
    }
    
    func animateSpinner() {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.spinnerForeground.transform =  self.spinnerForeground.transform.rotated(by: -CGFloat(M_PI_2))
        }) { finished in
            if !self.didDismiss {
                self.animateSpinner()
            }
        }
    }
    
    @IBAction func tapDetected() {
        if TAP_ONLY {
            self.performSegue(withIdentifier: "Splash2Platform", sender: self)
            networkManager.notifyBeaconDetection(beaconId: 14650, userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        } else {
            beaconManager.register(uuid: TRAINZ)
        }
    }
    
    func currentBeaconChanged(beacon: CLBeacon?) {
        if TAP_ONLY {
            return
        }
        if let beacon = beacon, beacon.major.intValue == STATION_MAYOR {
            self.performSegue(withIdentifier: "Splash2Platform", sender: self)
            networkManager.notifyBeaconDetection(beaconId: beacon.major, userId: UIDevice.current.identifierForVendor?.uuidString ?? "N/A")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
