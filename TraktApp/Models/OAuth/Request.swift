//
//  Request.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

typealias RequestCompletionHandler = (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void

class Request {
    
    private let URLRequest: NSMutableURLRequest
    
    var httpBody: NSData? {
        get {
            return nil
        }
        set (body) {
            self.URLRequest.HTTPBody = body
        }
    }
    /**
     *  Convenience initializer.
     *  - Parameter withURL: The URL Request object will initialize with specified URL. Must not be nil.
     *  - Complexity: If the httpMethod parameter is omitted, it will default to **GET**.
     */
    convenience init(withURL URL: NSURL) {
        self.init(withURL: URL, httpMethod: "GET")
    }
    /**
     *  Default initializer.
     *  - Parameters:
     *      - withURL: The URL Request object will initialize with specified URL. Must not be nil.
     *      - httpMethod: The http method of the request object.
     *  - Complexity: If the httpMethod parameter is omitted, it will default to **GET**.
     */
    init(withURL URL: NSURL, httpMethod: String) {
        self.URLRequest = NSMutableURLRequest(URL: URL)
        self.httpMethod = httpMethod
    }
    /**
     *  Adds an http header to the header dictionary.
     *  - Parameters:
     *      - value: The value for the header field.
     *      - field: The name of the header field. Case-insensitive.
     */
    func addValue(value: String, forHeader field: String) {
        self.URLRequest.addValue(value, forHTTPHeaderField: field)
    }
    /**
     *  Add several values to the http header dictionary.
     *  - Parameter values: A dictionary consisting of the value and the name of the http header field.
     */
    func addValues(values: Dictionary<String, String>) {
        for (field, value) in values {
            self.addValue(value, forHeader: field)
        }
    }
    /**
     *  Creates an HTTP request for the specified URL request object, and calls a handler upon completion.
     *  - Parameter completionHandler: The callback function.
     */
    func execute(completionHandler: RequestCompletionHandler) {
        let session = self.session
        session.dataTaskWithRequest(self.URLRequest, completionHandler: completionHandler).resume()
    }
    
}
// MARK: - Private Methods
private extension Request {
    /**
     *  Shorthand property for setting and getting the http method of the URL Request.
     */
    private var httpMethod: String {
        get {
            return self.URLRequest.HTTPMethod
        }
        set {
            self.URLRequest.HTTPMethod = newValue
        }
    }
    /**
     *  Creates and returns an instance of an url session with ephemeral session configuration.
     *  - Returns: NSURLSession.
     */
    private var session: NSURLSession {
        get {
            let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
            return session
        }
    }

}