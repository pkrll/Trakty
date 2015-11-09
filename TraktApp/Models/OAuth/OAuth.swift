//
//  OAuth.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias OperationHandler = (operation: Operation) -> Void

class OAuth {
    /**
     *  Make a GET request to the specified end point.
     *  - Parameters:
     *      - request: The API end point to call.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``OAuthCompletionHandler``.
     */
    func get(requestURL: String, headers: Dictionary<String, String>, parameters: Dictionary<String, String>?, completionHandler: OperationHandler) {
        self.request(requestURL, httpMethod: "GET", headers: headers, parameters: parameters, completionHandler: completionHandler)
    }
    /**
     *  Make a POST request to the specified end node.
     *  - Parameters:
     *      - request The API end node to call.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``TraktCompletionHandlerTest``.
     */
    func post(requestURL: String, headers: Dictionary<String, String>, parameters: Dictionary<String, String>?, completionHandler: OperationHandler) {
        self.request(requestURL, httpMethod: "POST", headers: headers, parameters: parameters, completionHandler: completionHandler)
    }
    /**
     *  Make a request to the specified end node.
     *  - Parameters:
     *      - request The API end node to call.
     *      - httpMethod: The http method to use.
     *      - parameters: Additional parameters.
     *      - completionHandler: A callback function of type ``TraktCompletionHandlerTest``.
     */
    private func request(requestURL: String, httpMethod: String, headers: Dictionary<String, String>, parameters: Dictionary<String, String>?, completionHandler: OperationHandler) {
        let requestURL = NSURL(string: requestURL)!
        let request = Request(withURL: requestURL, httpMethod: httpMethod)
        
        if let parameters = parameters {
            var httpBody: NSData?
            do {
                httpBody = try NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
            } catch let error as NSError {
                completionHandler(operation: Operation.Failure(GenericError(errorCode: .ParsingError, error: error)))
                return
            }
            
            request.httpBody = httpBody
        }
        
        request.addHeaders(headers)
        request.execute { (rawData, rawResponse, error) -> Void in
            let operation = self.handleResponse(rawData, rawResponse: rawResponse, error: error)
            completionHandler(operation: operation)
        }
    }

    /**
     *  Handles the API response, which will be represented by a Response structure.
     *  - Parameters:
     *      - rawData: The data sent back from the api.
     *      - rawResponse: The NSURLResponse object of the request.
     *      - error: Errors sent back by the receiver.
     *  - Returns: An Operation enum
     */
    func handleResponse(rawData: NSData?, rawResponse: NSURLResponse?, error: NSError?) -> Operation {
        var operation: Operation
        if let rawResponse = rawResponse, statusCode = TraktStatusCode(rawValue: rawResponse.statusCode) {
            switch statusCode {
                // Statuscode 200-299
            case .Success:
                // parse the JSON
                let results = self.parseJSON(rawData!)
                if let parsedJSON = results.parsedJSON {
                    let response = Response(statusCode: statusCode.rawValue, JSONObject: parsedJSON)
                    operation = Operation.Success(response)
                } else {
                    operation = Operation.Failure(results.error!)
                }
            default:
                operation = Operation.Failure(RequestError(errorCode: .RequestError, statusCode: statusCode, error: error))
                break
            }
        } else {
            operation = Operation.Failure(RequestError(errorCode: .RequestError, statusCode: .Unknown, error: error))
        }
        
        return operation
    }
    /**
     *  Attempts to create a JSON object from NSData.
     *  - Parameter rawData: An NSData object to convert to JSON.
     *  - Returns: A tuple consisting of two elements. The ``result`` element will hold the JSON object on success. On failure, an NSError object will be sent as the ``error`` element.
     */
    func parseJSON(rawData: NSData) -> (parsedJSON: JSONDictionary?, error: GenericError?) {
        var parsedJSON: JSONDictionary?
        var genericError: GenericError?
        
        do {
            if let JSON = try NSJSONSerialization.JSONObjectWithData(rawData, options: .AllowFragments) as? JSONDictionary {
                parsedJSON = JSON
            } else if let JSON = try NSJSONSerialization.JSONObjectWithData(rawData, options: .AllowFragments) as? Dictionary<String, AnyObject> {
                parsedJSON = [JSON]
            } else {
                genericError = GenericError(errorCode: .ParsingError, error: nil)
            }
        } catch let error as NSError {
            genericError = GenericError(errorCode: .ParsingError, error: error)
        }
        
        return (parsedJSON: parsedJSON, error: genericError)
    }
}