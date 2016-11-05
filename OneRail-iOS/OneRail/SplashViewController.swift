//
//  SplashViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 05/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit

final class SplashViewController : UIViewController {
    
    @IBOutlet weak var bluetoothImage: UIImageView!
    @IBOutlet weak var spinnerBackground: UIImageView!
    @IBOutlet weak var spinnerForeground: UIImageView!
    var didDismiss: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBlueTooth()
        animateSpinnerPresentation()
        animateSpinner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDismiss = true
        self.bluetoothImage.layer.removeAllAnimations()
        self.bluetoothImage.layer.removeAllAnimations()
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
        self.performSegue(withIdentifier: "Splash2Main", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
