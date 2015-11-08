//
//  TraktModel.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias TraktCompletionHandler = (didSucceed: Bool, response: Response) -> Void
typealias parsedJSONReturnValue = (result: NSDictionary?, error: NSError?)

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
     *  Constructs and returns the standard OAuth headers for the Trakt.tv API.
     */
    var OAuthHeaders: Dictionary<String, String> {
        get {
            let accessToken = self.accessToken?.token(false).key
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + accessToken!,
                "trakt-api-version": "2",
                "trakt-api-key": self.consumer.key
            ]
        }
    }
    /**
     *  Obtains an access token for the Trakt.tv API. Used after a request token has been fetched, by redirecting user to the authorization URL and retrieving the token from the query string of the redirect url.
     */
    func obtainAccessToken(exchangeToken token: String, completionHandler: OAuthCompletionHandler) {
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
                    self.accessToken = AccessToken(key: accessToken)
                    success = true
                }
                // Save the expiration date, to know when to refresh token.
                if let expiresIn = json.objectForKey("expires_in") as? String, createdAt = json.objectForKey("created_at") as? String {
                    AccessTokenMeta.saveMeta(createdAt, expiresIn: expiresIn)
                }
                
                completionHandler(didSucceed: success, result: nil, error: error)
            } catch let jsonError as NSError {
                completionHandler(didSucceed: success, result: nil, error: jsonError)
            }
        }
    }
    /**
     *  Make a request to the specified end node.
     *  - Parameters:
     *      - request The API end node to call.
     *      - httpMethod: The http method to use.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``TraktCompletionHandlerTest``.
     */
    func request(request: String, httpMethod: String, parameters: Dictionary<String,String>?, completionHandler: TraktCompletionHandler) {
        let requestURL = NSURL(string: "\(self.consumer.baseAPIURL)/\(request)")!
        let request = Request(withURL: requestURL, httpMethod: httpMethod)
        let headers = self.OAuthHeaders
        request.addValues(headers)
        request.execute { (data, response, error) -> Void in
            let results = self.parseResponse(data, rawResponse: response, error: error)
            completionHandler(didSucceed: results.didSucceed, response: results.response)
        }
    }
    
}
// MARK: - Private Methods
extension TraktModel {
    /**
     *  Parses the API response, which will be represented by a Response structure.
     *  - Parameters:
     *      - rawData: The data sent back from the api.
     *      - rawResponse: The NSURLResponse object of the request.
     *      - error: Errors sent back by the receiver.
     *      - completionHandler: A callback function of type ``TraktCompletionHandler``.
     *  - Complexity: After parsing, the method will call the completion handler, sending a ``Response`` object holding data on the request.
     */
    func parseResponse(rawData: NSData?, rawResponse: NSURLResponse?, error: NSError?) -> (didSucceed: Bool, response: Response) {
        var response: Response = Response()
        var success: Bool = false
        // Start building the Response object
        if let rawResponse = rawResponse {
            let statusCode = rawResponse.statusCode
            let allHeaders = rawResponse.allHeaders
            if let rawData = rawData {
                // Method parseJSON will send a tuple with two elements.
                let parsed = self.parseJSON(rawData)
                if let result = parsed.result {
                    // Success:
                    // Create a normal Response object.
                    response = Response(status: statusCode, headers: allHeaders, results: result)
                    success = true
                } else if let error = parsed.error {
                    // Failure:
                    // Get the status code description and create a ResponseError object for the Response object.
                    let description = TraktStatusCode(rawValue: statusCode)?.description
                    let responseError = ResponseError(description: description, error: error)
                    response = Response(status: statusCode, headers: allHeaders, results: nil, error: responseError)
                }
            } else {
                // rawData was nil, meaning an error.
                let description = TraktStatusCode(rawValue: statusCode)?.description
                let responseError = ResponseError(description: description, error: nil)
                response = Response(status: statusCode, headers: allHeaders, results: nil, error: responseError)
            }
        } else {
            let responseError = ResponseError(description: "No response.", error: nil)
            response = Response(status: 0, headers: [:], results: nil, error: responseError)
        }
        
        return (didSucceed: success, response: response)
    }
    /**
     *  Attempts to create a JSON object from NSData.
     *  - Parameter rawData: An NSData object to convert to JSON.
     *  - Returns: A tuple consisting of two elements. The ``result`` element will hold the JSON object on success. On failure, an NSError object will be sent as the ``error`` element.
     */
    func parseJSON(rawData: NSData) -> parsedJSONReturnValue  {
        var parsedJSON: NSDictionary?
        var errorValue: NSError?
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: .MutableContainers) as? NSDictionary {
                parsedJSON = json
            }
        } catch let error as NSError {
            errorValue = error
        }
        
        return (result: parsedJSON, error: errorValue)
    }
    
}