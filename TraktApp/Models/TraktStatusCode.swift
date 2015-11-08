//
//  TraktStatusCode.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//
import Foundation
/**
 *  HTTP status code that the Trakt.tv API can respond with.
 *  - Complexity: Member ``description`` will return the localized string corresponding to the HTTP status code.
 *  - Complexity: Members ``success``, ``clientError`` and ``serverError`` returns a boolean value if the http status code indicates a successful operation, a client error or a server error.
 *  - SeeAlso: [Trakt.tv API Documentation: Status codes](http://docs.trakt.apiary.io/#introduction/status-codes)
 */
enum TraktStatusCode: Int {
    // Current Trakt.tv API status code
    case Success = 200
    case Created = 201
    case Deleted = 204
    case BadRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case MethodNotFound = 405
    case Conflict = 409
    case PreconditionFailed = 412
    case UnprocessableEntity = 422
    case RateLimitExceeded = 429
    case ServerError = 500
    case ServiceUnavailable = 503
    
    var description: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(rawValue).capitalizedString
    }
    
    var success: Bool {
        return Range(200...299).contains(rawValue)
    }
    
    var clientError: Bool {
        return Range(400...499).contains(rawValue)
    }
    
    var serverError: Bool {
        return Range(500...599).contains(rawValue)
    }
    
}