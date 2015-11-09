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
    private var secret: String
    
    init(key: String, secret: String = "") {
        self.key = key
        self.secret = secret
    }
    
    func token(withSecret: Bool) -> (key: String, secret: String) {
        return (key: self.key, secret: self.secret)
    }
    
}