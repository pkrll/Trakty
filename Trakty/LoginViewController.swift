//
//  LoginViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var url: NSURL?
    var redirectedTo: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signInButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationView = segue.destinationViewController
        
        if let viewController = destinationView as? WebViewController {
            viewController.url = self.url
        } else if let viewController = destinationView as? MainViewController {
            viewController.loginView(self, didReceiveCode: self.redirectedTo!)
        }
    }

    @IBAction func unwindToLoginView(segue: UIStoryboardSegue) {
        if let _ = self.redirectedTo {
            self.signInButton.enabled = false
            self.activityIndicator.startAnimating()

            self.performSegueWithIdentifier("hideLoginViewController", sender: self)
        }
    }
    
}
