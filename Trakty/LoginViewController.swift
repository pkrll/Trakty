//
//  LoginViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("SegueWebView", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? WebViewController where segue.identifier! == "SegueWebView" {
            viewController.url = NSURL(string: ConsumerCredentials.authURL)
        }
    }

}
