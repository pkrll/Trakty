//
//  MainViewController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private var trakt: TraktModel!
    private var currentView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTrakt()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.showInitialViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
// MARK: - Private Methods
private extension MainViewController {

    func initializeTrakt() {
        self.trakt = TraktModel()
    }
    /**
     *  Will check if user is signed in and has authorized app. New users must sign in.
     */
    func showInitialViewController() {
        if self.trakt?.isUserAuthenticated == false {
            // Present the LoginViewController modally.
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
            controller.delegate = self
            controller.authDetails = (tokenRequestURL: self.trakt.tokenRequestURL, URLScheme: "trakty")
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            self.trakt.request("users/settings", httpMethod: "GET", parameters: nil, completionHandler: { (didSucceed, response) -> Void in
                if didSucceed {
                    let statusCode = TraktStatusCode(rawValue: response.status)!
                    if statusCode.success {
                        
                    }
                    
                    if let results = response.results {
                        let username = results["user"]!["username"]
                        NSLog("\(username)")
                    }
                }
                

                
            })
        }
    }
    
    func attemptAuthorization(withToken token: String) {
        self.trakt.obtainAccessToken(exchangeToken: token) { (didSucceed, result, error) -> Void in
            if didSucceed {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                if let unwrappedError = error {
                    NSLog("Error: %@", unwrappedError)
                }
            }
            
            NSLog("\(didSucceed)")
        }
    }
}

extension MainViewController: LoginViewDelegate {
    
    func loginView(LoginView: LoginViewController, didFetchRequestToken token: String) {
        self.attemptAuthorization(withToken: token)
    }
    
}
