//
//  OAuth.swift
//  Trakty
//
//  Created by Ardalan Samimi on 03/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

class OAuth {
    
    private var consumer: Consumer?
    private var accessToken: AccessToken?
    
    init() {
        
    }
    
    init(consumerKey: String, consumerSecret: String) {
        self.consumer = Consumer(key: consumerKey, secret: consumerSecret)
    }
    
    init(consumerKey: String, consumerSecret: String, accessToken: String) {
        self.consumer = Consumer(key: consumerKey, secret: consumerSecret)
        self.accessToken = AccessToken(key: accessToken)
    }
    
    func accessTokenIsEmpty() -> Bool {
        if let _ = self.accessToken {
            return false
        }
        
        return true
    }
    
}