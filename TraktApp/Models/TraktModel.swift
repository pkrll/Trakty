//
//  TraktModel.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

class TraktModel {
    
    private let consumer: Consumer
    private var accessToken: AccessToken?
    var isUserAuthenticated: Bool {
        return (self.accessToken != nil)
    }
    
    init() {
        self.consumer = Consumer(
            key: ConsumerCredentials.key,
            secret: ConsumerCredentials.secret,
            redirectURI: ConsumerCredentials.redirectURI,
            APIBaseURL: ConsumerCredentials.APIBaseURL
        )
        
        if let token = Keychain.load("AccessToken") {
            if let secret = Keychain.load("AccessTokenSecret") {
                self.accessToken = AccessToken(key: token, secret: secret)
            } else {
                self.accessToken = AccessToken(key: token)
            }
        }
    }
    /**
     *  Constructs and returns the authorization URL for the Trakt.tv API, used to retrieve the request token.
     *  - Returns: The authorization URL with a query string constructed to conform to the Trakt.tv API.
     */
    var tokenRequestURL: NSURL! {
        get {
            let requestURL  = NSURL(string: self.consumer.APIBaseURL + "/" + TraktEndPoint.auth.requestToken)
            let queryString = [
                "response_type": "code",
                "client_id": self.consumer.key,
                "redirect_uri": self.consumer.redirectURI,
                "state": ""
            ]
            
            return requestURL?.appendQueries(queryString)
        }
    }

    
    /**
     *  Obtains an access token for the Trakt.tv API. Used after a request token has been fetched, by redirecting user to the authorization URL and retrieving the token from the query string of the redirect url.
     */
    func obtainAccessToken(exchangeToken token: String, completionHandler: (success: Bool) -> Void) {
        let requestURL = "\(self.consumer.APIBaseURL)/\(TraktEndPoint.auth.exchangeToken)"
        let parameters = [
            "code"          : token,
            "client_id"     : self.consumer.key,
            "client_secret" : self.consumer.secret,
            "redirect_uri"  : self.consumer.redirectURI,
            "grant_type"    : "authorization_code"
        ]
        OAuth().post(requestURL, headers: self.OAuthHeaders, parameters: parameters) { (operation) -> Void in
            var success: Bool
            
            switch operation {
            case .Success(let response):
                self.saveAccessToken(response)
                success = true
            default:
                success = false
                break;
            }
            
            completionHandler(success: success)
        }        
    }
    
    func get(endPoint: String, parameters: Dictionary<String, String>?, completionHandler: OperationHandler) {
        OAuth().get(endPoint, headers: self.OAuthHeaders, parameters: parameters) { (operation) -> Void in
            completionHandler(operation: operation)
        }
    }
    
}

private extension TraktModel {
    
    /**
     *  Constructs and returns the standard OAuth headers for the Trakt.tv API.
     *  - Returns: A dictionary containing the OAuth header. If access token is missing, only the ``Content-Type`` field will be set.
     */
    var OAuthHeaders: Dictionary<String, String> {
        get {
            if let accessToken = self.accessToken?.token(false).key {
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer " + accessToken,
                    "trakt-api-version": "2",
                    "trakt-api-key": self.consumer.key
                ]
            }
            
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    /**
     *  Saves the retrieved access token.
     *  - Parameter response: The response encapsulated in a Response object.
     */
    private func saveAccessToken(response: Response) -> Bool {
        guard response.JSONObject.count > 0 else {
            return false
        }
        
        let response = response.JSONObject[0]
        if let accessToken = response["access_token"] as? String, refreshToken = response["access_token"] as? String {
            self.accessToken = AccessToken(key: accessToken)
            Keychain.save(accessToken, forKey: "AccessToken")
            Keychain.save(refreshToken, forKey: "RefreshToken")
            // Save expiration date
            if let expiresIn = response["expires_in"] as? String, createdAt = response["created_at"] as? String {
                AccessTokenMeta.saveMeta(createdAt, expiresIn: expiresIn)
            }
            
            return true
        }
        
        return false
    }
}