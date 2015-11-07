//
//  MainViewController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

    private var trakt: TraktModel!
    private var currentView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeTrakt()
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
    
    func showInitialViewController() {
        if self.trakt?.isUserAuthenticated == false {
            self.currentView = "LoginView"
        } else {
            self.currentView = "TabView"
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(self.currentView)
        self.viewControllers = [controller]
    }
    
    func attemptAuthorization(withToken token: String) {
        self.trakt.obtainAccessToken(exchangeToken: token) { (didSucceed, result, error) -> Void in
            if didSucceed {
                NSLog("Success!")
            } else {
                if let unwrappedError = error {
                    NSLog("Error: %@", unwrappedError)
                }
            }
            
            NSLog("\(didSucceed)")
        }
    }
}
// MARK: - LoginViewController Methods
extension MainViewController {
    /**
     *  Invoked from LoginViewController, sending user to the token request URL.
     *  - SeeAlso: freezeOnLoginView:
     */
    @IBAction func signInTapped(sender: AnyObject?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authenticationURL = self.trakt?.tokenRequestURL
        let webViewController = storyboard.instantiateViewControllerWithIdentifier("WebView") as! WebViewController
        webViewController.delegate = self
        webViewController.loadURL(authenticationURL!, withTargetURLScheme: "trakty")
        self.presentViewController(webViewController, animated: true) { () -> Void in
        }
    }
    /**
     *  Disables user interaction with the Login View. Invoked when trying to authenticate user.
     *  - SeeAlso: webView(_: didFinishRequest: ):
     */
    func freezeOnLoginView() {
        if let viewController = self.topViewController as? LoginViewController {
            viewController.buttonState = false
            viewController.indicator.startAnimating()
        }
    }
}

extension MainViewController: WebViewDelegate {
    /**
     *  Sent when the web view is loading a URL that uses the designated URL Scheme.
     *  - Parameters:
     *      - webView: The web view that is about to load the URL.
     *      - URL: The content location.
     */
    func webView(webView: WebViewController, didLoadURL URL: NSURL) {
        webView.hideWebView(self)
        
        if let token = URL.splitQuery!["code"] as? String {
            self.freezeOnLoginView()
            self.attemptAuthorization(withToken: token)
        }
    }
    
}