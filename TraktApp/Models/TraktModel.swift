//
//  TraktModel.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias TraktCompletionHandler = (didSucceed: Bool, result: Dictionary<String, String>?, error: NSError?) -> Void

class TraktModel: OAuth {
    /**
     *  Constructs and returns the authorization URL for the Trakt.tv API, used to retrieve the request token.
     *  - Returns: The authorization URL with a query string constructed to conform to the Trakt.tv API..
     */
    var tokenRequestURL: NSURL! {
        get {
            let requestURL  = NSURL(string: self.consumer.tokenRequestURL)
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
     *  The Trakt.tv API token exchange URL, used to exchange a request token for an access token.
     *  - Returns: The token exchange url for the Trakt.tv API.
     */
    var tokenExchangeURL: NSURL! {
        get {
            return NSURL(string: self.consumer.tokenExchangeURL)
        }
    }
    /**
     *  Obtains an access token for the Trakt.tv API. Used after a request token has been fetched, by redirecting user to the authorization URL and retrieving the token from the query string of the redirect url.
     */
    func obtainAccessToken(exchangeToken token: String, completionHandler: TraktCompletionHandler) {
        let requestURL = self.tokenExchangeURL
        let postFields = [
            "code"          : token,
            "client_id"     : self.consumer.key,
            "client_secret" : self.consumer.secret,
            "redirect_uri"  : self.consumer.redirectURI,
            "grant_type"    : "authorization_code"
        ]
        // Convert postfields dictionary to JSON data.
        var httpBody: NSData?
        do {
            httpBody = try NSJSONSerialization.dataWithJSONObject(postFields, options: .PrettyPrinted)
        } catch let error as NSError {
            completionHandler(didSucceed: false, result: nil, error: error)
            return
        }
        // Make the actual request
        var success = false
        let request = Request(withURL: requestURL!, httpMethod: "POST")
        request.httpBody = httpBody
        request.addValue("application/json", forHeader: "Content-type")
        request.execute { (data, response, error) -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let accessToken = json.objectForKey("access_token") as? String, refreshToken = json.objectForKey("refresh_token") as? String {
                    Keychain.save(accessToken, forKey: "AccessToken")
                    Keychain.save(refreshToken, forKey: "RefreshToken")
                    success = true
                }
                // Save the expiration date, to know when to refresh token.
                if let expiresIn = json.objectForKey("expires_in") as? String, createdAt = json.objectForKey("created_at") as? String {
                    AccessTokenMeta.saveMeta(createdAt, expiresIn: expiresIn)
                }
                
                completionHandler(didSucceed: success, result: nil, error: error)
            } catch let jsonError as NSError {
                completionHandler(didSucceed: false, result: nil, error: jsonError)
            }
        }
        
    }
    
}