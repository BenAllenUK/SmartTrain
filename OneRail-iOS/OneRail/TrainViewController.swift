//
//  TrainViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 06/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit

final class TrainViewController : UIViewController {
 
    @IBAction func tapDetected() {
        self.performSegue(withIdentifier: "Train2Journey", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
