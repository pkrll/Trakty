//
//  Consumer.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

struct Consumer {
    
    let key: String
    let secret: String
    let redirectURI: String
    let baseAPIURL: String
    let tokenRequestURL: String
    let tokenExchangeURL: String
    
    init(key: String, secret: String, redirectURI: String, baseAPIURL: String, tokenRequestURL: String, tokenExchangeURL: String) {
        self.key = key
        self.secret = secret
        self.redirectURI = redirectURI
        self.baseAPIURL = baseAPIURL
        self.tokenRequestURL = tokenRequestURL
        self.tokenExchangeURL = tokenExchangeURL
    }
}