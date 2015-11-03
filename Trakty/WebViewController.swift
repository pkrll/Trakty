//
//  WebViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var url: NSURL?
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        self.webView.delegate = self
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
    
}
