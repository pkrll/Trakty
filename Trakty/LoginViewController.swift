//
//  LoginViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    var url: NSURL?
    var redirectedTo: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInTapped(sender: AnyObject) {
//        self.performSegueWithIdentifier("showWebViewController", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let destinationView = segue.destinationViewController
//        let segueIdentifier = segue.identifier
//        if let viewController = destinationView as? WebViewController where segueIdentifier! == "showWebViewController" {
//            viewController.url = NSURL(string: "https://saturn-five.github.io/trakty_redirect.html")! //url
//        }
    }
//    
//    @IBAction func unwindToLoginView(segue: UIStoryboardSegue) {
//        if let _ = self.redirectedTo {
//            self.performSegueWithIdentifier("hideLoginViewController", sender: self)
//        }
//    }
    
}
