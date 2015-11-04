//
//  TraktAuthModel.swift
//  Trakty
//
//  Created by Ardalan Samimi on 04/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

class TraktModel {
    
    private let oauth: OAuth!
    private let consumer: Consumer!
    
    private var accessToken: AccessToken? {
        if let _ = self.accessToken {
            return self.accessToken
        } else {
            return nil
        }
    }
    /**
     *  A bool value indicating whether the user is authenticated against the trakt.tv API or not.
     * - returns: Yes if there is an access token saved, otherwise no.
     */
    var userNotAuthenticated: Bool {
        get {
            return self.oauth.accessTokenIsEmpty()
        }
    }
    /**
     * Constructs and return the authentication url for the trakt.tv API.
     * - SeeAlso: tokenExchangeURL
     */
    var authenticationURL: NSURL {
        get {
            let URLComponents = NSURLComponents(string: ConsumerCredentials.authURL)
            var queryItems: [NSURLQueryItem] = []
            let queryString = [
                "response_type":    "code",
                "client_id":        ConsumerCredentials.key,
                "redirect_uri":     ConsumerCredentials.redirectURI,
                "state":            ""
            ]
            for (field, value) in queryString {
                let queryItem = NSURLQueryItem(name: field, value: value)
                queryItems.append(queryItem)
            }
            
            URLComponents?.queryItems = queryItems
            
            return (URLComponents?.URL)!
        }
    }
    
    var tokenExchangeURL: NSURL! {
        get {
            
            
            
            return NSURL(string: "")
        }
    }
    
    init() {
        self.consumer = Consumer(key: ConsumerCredentials.key, secret: ConsumerCredentials.secret)
        
        self.oauth = OAuth(consumerKey: ConsumerCredentials.key, consumerSecret: ConsumerCredentials.secret)
    }
    
//    init(with AccessToken: String) {
//        self.oauth = OAuth(consumerKey: ConsumerCredentials.key, consumerSecret: ConsumerCredentials.secret)
//    }
    
}