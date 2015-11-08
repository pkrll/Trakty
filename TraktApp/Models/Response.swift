//
//  Response.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  This structure encapsulates the response of a URL Request.
 */
struct Response {
    /**
     *  Status code.
     */
    var status: Int = 0
    /**
     *  Header fields.
     */
    var headers: Dictionary<String, String> = [:]
    /**
     *  Data sent to the receiver.
     */
    var results: NSDictionary?
    /**
     *  Errors encountered by the receiver.
     */
    var error: ResponseError?
    
    init() { }
    
    init(status: Int, headers: Dictionary<String, String>, results: NSDictionary?, error: ResponseError? = nil) {
        self.status = status
        self.headers = headers
        self.results = results
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