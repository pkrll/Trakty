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
     *  Status code sent to the receiver.
     */
    var statusCode: Int
    /**
     *  The data response. This object holds the actual result of the request.
     */
    var JSONObject: JSONDictionary
    
}