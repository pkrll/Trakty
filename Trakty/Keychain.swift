//
//  KeychainWrapper.swift
//  Trakty
//
//  Created by Ardalan Samimi on 04/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import Foundation
import Security

class Keychain {
 
    class func save(value: String, forKey key: String) -> Bool {
        return self.saveToKeychain(key, value: value)
    }
    
}

private extension Keychain {
    
    class var service: String? {
        get {
            return NSBundle.mainBundle().infoDictionary![kCFBundleIdentifierKey as String] as? String
        }
    }
    
    class func saveToKeychain(key: String, value: String) -> Bool {
        
        if value == "" {
            return false
        }
        
        let keychainQuery: Dictionary<String, Any>? = [
            kSecClass as String         : kSecClassGenericPassword as String,
            kSecAttrService as String   : self.service,
            kSecAttrAccount as String   : key,
            kSecValueData as String     : value.dataUsingEncoding(NSUTF8StringEncoding)
        ]

        SecItemDelete(keychainQuery as! CFDictionaryRef)
        
        return SecItemAdd(keychainQuery as! CFDictionaryRef, nil) == noErr
    }
    
}