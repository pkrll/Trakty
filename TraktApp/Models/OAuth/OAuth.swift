//
//  OAuth.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias OAuthCompletionHandler = (didSucceed: Bool, result: Dictionary<String, String>?, error: NSError?) -> Void

class OAuth {
    
    let consumer: Consumer
    var accessToken: AccessToken?
    
    var isUserAuthenticated: Bool {
        get {
            return self.accessToken != nil
        }
    }
    
    init() {
        self.consumer = Consumer(
            key: ConsumerCredentials.key,
            secret: ConsumerCredentials.secret,
            redirectURI: ConsumerCredentials.redirectURI,
            baseAPIURL: ConsumerCredentials.baseApiURL,
            tokenRequestURL: ConsumerCredentials.tokenRequestURL,
            tokenExchangeURL: ConsumerCredentials.tokenExchangeURL
        )
        
        if let token = Keychain.load("AccessToken") {
            if let secret = Keychain.load("AccessTokenSecret") {
                self.accessToken = AccessToken(key: token, secret: secret)
            } else {
                self.accessToken = AccessToken(key: token)
            }
        }
    }
    
}