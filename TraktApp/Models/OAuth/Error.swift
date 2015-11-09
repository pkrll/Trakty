//
//  Error.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 09/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    
    case UnknownError
    case ParsingError
    case RequestError
    
}

protocol Error {
    var errorCode: ErrorCode { get }
    var error: NSError? { get }
}

struct GenericError: Error {
    
    var errorCode: ErrorCode
    var error: NSError?
}

struct RequestError: Error {
    
    var errorCode: ErrorCode
    var statusCode: TraktStatusCode
    var error: NSError?
}
