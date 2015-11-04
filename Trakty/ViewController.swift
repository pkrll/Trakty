////
////  ViewController.swift
////  Trakty
////
////  Created by Ardalan Samimi on 03/11/15.
////  Copyright © 2015 Saturn Five. All rights reserved.
////
//
//import UIKit
//
//class ViewController: UIViewController {
//    
//    var trakt: TraktModel!
//    
//    override func viewDidLoad() {
//        self.trakt = TraktModel()
//        super.viewDidLoad()
//    }
//
//    func dada(URL: NSURL) {
//        NSLog("%@", URL);
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        if self.trakt!.userNotAuthenticated {
//            self.performSegueWithIdentifier("showLoginViewController", sender: self)
//        } else {
//            
//        }
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let viewController = segue.destinationViewController as? LoginViewController where segue.identifier! == "showLoginViewController" {
//            viewController.url = self.trakt!.authenticationURL
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
////        NSLog("%@", segue.sourceViewController)
//    }
//    
//}