//
//  MainViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 04/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

    var currentView: String = "LoginView"
    var trakt: TraktModel?
    var url: NSURL?
    
    override func viewDidLoad() {
        self.currentView = "LoginView"
        self.trakt = TraktModel()
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        if let url = self.url {
            self.attemptAuthorization(url)
        } else {
            self.showLoginViewController()
        }

    }
    
    func attemptAuthorization(url: NSURL) {
        self.trakt = TraktModel()
    }
    
    func showLoginViewController() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(self.currentView)
        self.view.window?.rootViewController = vc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginView(view: LoginViewController, didReceiveCode url: NSURL) {
        
    }

    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
