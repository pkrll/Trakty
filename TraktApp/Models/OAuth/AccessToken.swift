//
//  AccessToken.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit

class AccessToken {
    
    private var key: String
    private var secret: String?
    
    convenience init(key: String) {
        self.init(key: key, secret: nil)
    }
    
    init(key: String, secret: String?) {
        self.key = key;
        if let _ = secret {
            self.secret = secret
        }
    }
    
}