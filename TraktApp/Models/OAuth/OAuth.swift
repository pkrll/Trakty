//
//  OAuth.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias OAuthCompletionHandler = (success: Bool, response: Response) -> Void

class OAuth {
    
    let consumer: Consumer
    var accessToken: AccessToken?
    
    var isUserAuthenticated: Bool {
        get {
            return self.accessToken != nil
        }
    }
    /**
     *  Constructs and returns the authorization URL. Must be overridden.
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
     *  Returns the token exchange URL. Must be overridden.
     */
    var tokenExchangeURL: NSURL! {
        get {
            return NSURL(string: "")
        }
    }
    /**
     *  Constructs and returns an OAuth header. Must be overridden by subclasses.
     */
    var OAuthHeaders: Dictionary<String, String> {
        get {
            return [
                "": ""
            ]
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
    
    /**
     *  Obtains an access token for the Trakt.tv API. Used after a request token has been fetched, by redirecting user to the authorization URL and retrieving the token from the query string of the redirect url.
     */
    func obtainAccessToken(exchangeToken token: String, completionHandler: OAuthCompletionHandler) {
        let requestURL = "oauth/token"
        let postFields = [
            "code"          : token,
            "client_id"     : self.consumer.key,
            "client_secret" : self.consumer.secret,
            "redirect_uri"  : self.consumer.redirectURI,
            "grant_type"    : "authorization_code"
        ]
        self.post(requestURL, parameters: postFields) { (didSucceed, response) -> Void in
            var success = false
            NSLog("\(didSucceed)")
            if didSucceed {
                success = self.saveAccessToken(response)
            }
            
            completionHandler(success: success, response: Response())
        }
    }
    /**
     *  Make a GET request to the specified end point.
     *  - Parameters:
     *      - request: The API end point to call.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``OAuthCompletionHandler``.
     */
    func get(request: String, parameters: Dictionary<String, String>?, completionHandler: OAuthCompletionHandler) {
        self.request(request, httpMethod: "GET", parameters: parameters, completionHandler: completionHandler)
    }
    /**
     *  Make a POST request to the specified end node.
     *  - Parameters:
     *      - request The API end node to call.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``TraktCompletionHandlerTest``.
     */
    func post(request: String, parameters: Dictionary<String, String>?, completionHandler: OAuthCompletionHandler) {
        self.request(request, httpMethod: "POST", parameters: parameters, completionHandler: completionHandler)
    }
    /**
     *  Make a request to the specified end node.
     *  - Parameters:
     *      - request The API end node to call.
     *      - httpMethod: The http method to use.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``TraktCompletionHandlerTest``.
     */
    func request(request: String, httpMethod: String, parameters: Dictionary<String,String>?, completionHandler: OAuthCompletionHandler) {
        let requestURL = NSURL(string: "\(self.consumer.baseAPIURL)/\(request)")!
        let request = Request(withURL: requestURL, httpMethod: httpMethod)
        let headers = self.OAuthHeaders
        
        if let parameters = parameters {
            var httpBody: NSData?
            do {
                httpBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
            } catch let error as NSError {
                let response = Response(
                    statusCode: -1,
                    allHeaders: parameters,
                    JSONObject: nil,
                    error: ResponseError(
                        description: "Request failed!",
                        error: error
                    )
                )
                
                completionHandler(success: false, response: response)
                return
            }
            
            request.httpBody = httpBody
        }
        
        request.addValues(headers)
        request.execute { (data, response, error) -> Void in
            let response = self.parseResponse(data, rawResponse: response, error: error)
            completionHandler(success: response.success, response: response.response)
        }
    }
    /**
     *  Parses the API response, which will be represented by a Response structure.
     *  - Parameters:
     *      - rawData: The data sent back from the api.
     *      - rawResponse: The NSURLResponse object of the request.
     *      - error: Errors sent back by the receiver.
     *  - Returns: A tuple with two elements: A boolean indicating operation success and a Response object holding the data.
     */
    func parseResponse(rawData: NSData?, rawResponse: NSURLResponse?, error: NSError?) -> (success: Bool, response: Response) {
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
                    // Success: Create a normal Response object.
                    response = Response(statusCode: statusCode, allHeaders: allHeaders, JSONObject: result)
                    success = true
                } else if let error = parsed.error {
                    // Failure:
                    // Get the status code description and create a ResponseError object for the Response object.
                    let description = TraktStatusCode(rawValue: statusCode)?.description
                    let responseError = ResponseError(description: description, error: error)
                    response = Response(statusCode: statusCode, allHeaders: allHeaders, JSONObject: nil, error: responseError)
                }
            } else {
                // rawData was nil, meaning an error.
                let description = TraktStatusCode(rawValue: statusCode)?.description
                let responseError = ResponseError(description: description, error: nil)
                response = Response(statusCode: statusCode, allHeaders: allHeaders, JSONObject: nil, error: responseError)
            }
        } else {
            let responseError = ResponseError(description: "No response.", error: nil)
            response = Response(statusCode: -1, allHeaders: [:], JSONObject: nil, error: responseError)
        }
        
        return (success: success, response: response)
    }
    /**
     *  Attempts to create a JSON object from NSData.
     *  - Parameter rawData: An NSData object to convert to JSON.
     *  - Returns: A tuple consisting of two elements. The ``result`` element will hold the JSON object on success. On failure, an NSError object will be sent as the ``error`` element.
     */
    func parseJSON(rawData: NSData) -> (result: JSONDictionary?, error: NSError?)  {
        var parsedJSON: JSONDictionary?
        var errorValue: NSError?
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: NSJSONReadingOptions.AllowFragments) as? JSONDictionary {
                parsedJSON = json
            } else if let json = try NSJSONSerialization.JSONObjectWithData(rawData, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, AnyObject> {
                parsedJSON = [json]
            }
        } catch let error as NSError {
            errorValue = error
        }
        
        return (result: parsedJSON, error: errorValue)
    }
    /**
     *  Saves the retrieved access token.
     *  - Parameter response: The response encapsulated in a Response object.
     */
    func saveAccessToken(response: Response) -> Bool {
        guard response.JSONObject?.count > 0 else {
            return false
        }
        
        let response = response.JSONObject![0]
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