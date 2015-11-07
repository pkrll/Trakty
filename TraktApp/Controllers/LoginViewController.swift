//
//  LoginViewController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    var buttonState: Bool = true
    
    override func viewDidLoad() {
        self.buttonState = true
    }
    
    override func viewDidAppear(animated: Bool) {
        signInButton.enabled = self.buttonState
    }
    
}
