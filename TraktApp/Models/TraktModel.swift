//
//  TraktModel.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

class TraktModel: OAuth {
    /**
     *  Constructs and returns the authorization URL for the Trakt.tv API, used to retrieve the request token.
     *  - Returns: The authorization URL with a query string constructed to conform to the Trakt.tv API.
     */
    override var tokenRequestURL: NSURL! {
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
    override var tokenExchangeURL: NSURL! {
        get {
            return NSURL(string: self.consumer.tokenExchangeURL)
        }
    }
    /**
     *  Constructs and returns the standard OAuth headers for the Trakt.tv API.
     *  - Returns: A dictionary containing the OAuth header. If access token is missing, only the ``Content-Type`` field will be set.
     */
    override var OAuthHeaders: Dictionary<String, String> {
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

}

