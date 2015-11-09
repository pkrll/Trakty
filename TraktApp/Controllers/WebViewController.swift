//
//  WebViewController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//
import UIKit
// MARK: - Protocol Declaration
protocol WebViewDelegate {
    
    func webView(webView: WebViewController, didLoadURL URL: NSURL)
    
}
// MARK: - Controller Class
class WebViewController: UIViewController {

    internal var delegate: WebViewDelegate?
    // MARK: - Private Members
    private var primaryURL: NSURL?
    private var URLScheme: String?
    // MARK: - IB Outlets and Actions
    @IBOutlet var webView: UIWebView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBAction func cancelTapped(sender: AnyObject) {
        self.hideWebView(sender)
    }
    // MARK: - Public Methods
    func loadURL(URL: NSURL, withTargetURLScheme scheme: String) {
        self.primaryURL = URL
        self.URLScheme = scheme
    }

    func hideWebView(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Private Methods
    private func loadURL(URL: NSURL) {
        let request = NSURLRequest(URL: URL)
        self.webView.delegate = self
        self.webView.loadRequest(request)
    }
    // MARK: - Overridden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let URL = self.primaryURL {
            self.loadURL(URL)
        } else {
            self.hideWebView(nil)
        }
    }

}
// MARK: - Delegate Methods
extension WebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.indicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.indicator.stopAnimating()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let URL = request.URL where request.URL?.scheme == self.URLScheme {
            self.delegate?.webView(self, didLoadURL: URL)
        }
        
        return true
    }
    
}