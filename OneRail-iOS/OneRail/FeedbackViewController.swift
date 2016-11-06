//
//  FeedbackViewController.swift
//  OneRail
//
//  Created by Danny Bravo on 06/11/2016.
//  Copyright © 2016 HackTrain. All rights reserved.
//

import Foundation
import UIKit

final class FeedbackViewController : UIViewController {
    
    @IBAction func tapDetected() {
        var viewControllers = [UIViewController]()
        if let controllers = self.navigationController?.viewControllers {
            viewControllers.append(controllers[0])
            viewControllers.append(controllers[1])
        }
        let _ = self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
