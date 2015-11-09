//
//  Response.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  Dictionary type for Response object.
 *  - Note: A typealias for [Dictionary<String, AnyObject>].
 */
typealias JSONDictionary = [Dictionary<String, AnyObject>]
/**
 *  This structure encapsulates the response of a URL Request.
 */
struct Response {
    /**
     *  Status code.
     */
    var statusCode: Int
    /**
     *  Header fields.
     */
    var allHeaders: Dictionary<String, String>
    /**
     *  The data response. This object holds the actual result of the request.
     */
    var JSONObject: JSONDictionary?
    /**
     *  Errors encountered by the receiver.
     */
    var error: ResponseError?
    
    init() {
        self.statusCode = -1
        self.allHeaders = [:]
    }
    
    init(statusCode: Int, allHeaders: Dictionary<String, String>, JSONObject: JSONDictionary?, error: ResponseError? = nil) {
        self.statusCode = statusCode
        self.allHeaders = allHeaders
        self.JSONObject = JSONObject
        self.error = error
    }

}
/**
 *  Errors encountered by the receiver.
 */
struct ResponseError {
    
    let description: String?
    let error: NSError?
    
    init(description: String?, error: NSError?) {
        self.description = description
        self.error = error
    }
}