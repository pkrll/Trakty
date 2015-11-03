//
//  ViewController.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var oauth: OAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oauth = OAuth(
            consumerKey:    ConsumerCredentials.key,
            consumerSecret: ConsumerCredentials.secret,
            redirectURI:    ConsumerCredentials.redirectURI
        )
    }

    override func viewDidAppear(animated: Bool) {
        if self.oauth!.accessTokenIsEmpty() {
            performSegueWithIdentifier("SegueLogin", sender: self)
        } else {
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

