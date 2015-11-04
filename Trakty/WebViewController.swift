//
//  WebViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

protocol WebViewDelegate {
    
    func webViewController(webView: WebViewController, didFinishRequest url: NSURL)
    
}

class WebViewController: UIViewController, UIWebViewDelegate {

    var url: NSURL?
    var delegate: WebViewDelegate?
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        self.webView.delegate = self
        self.url = NSURL(string: "https://www.google.se")
        if let url = self.url {
            self.webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where request.URL!.scheme == "trakty" {
            self.url = url
//            self.performSegueWithIdentifier("hideWebViewController", sender: self)
        }
        
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let viewController = segue.destinationViewController as? ViewController where segue.identifier! == "hideWebViewController" {
//
//        }
    }
    

    
}
