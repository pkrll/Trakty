//
//  LoginViewController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

protocol LoginViewDelegate {
    func loginView(LoginView: LoginViewController, didFetchRequestToken token: String)
}

class LoginViewController: UIViewController {

    var authDetails: (tokenRequestURL: NSURL, URLScheme: String)?
    var delegate: LoginViewDelegate?
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBAction func signInTapped(sender: AnyObject?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("WebView") as! WebViewController
        controller.delegate = self
        controller.loadURL(self.authDetails!.tokenRequestURL, withTargetURLScheme: self.authDetails!.URLScheme)
        self.presentViewController(controller, animated: true, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        self.signInButton.enabled = true
        self.indicator.stopAnimating()
    }

    func signInFailed() {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "Trakty", message: "Could not authenticate user.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            self.signInButton.enabled = true
            self.indicator.stopAnimating()
        })
    }
    
}
// MARK: - Web View Delegate
extension LoginViewController: WebViewDelegate {

    func webView(webView: WebViewController, didLoadURL URL: NSURL) {
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let token = URL.splitQuery!["code"] as? String {
                self.signInButton.enabled = false
                self.indicator.startAnimating()
                self.delegate?.loginView(self, didFetchRequestToken: token)
            }            
        })
        
    }
    
}
