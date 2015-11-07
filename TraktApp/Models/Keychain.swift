import Foundation
/**
 *  A Swift 2.0 Keychain class.
 *  - Version: 0.1.0
 *  - Author: Ardalan Samimi
 *  - Date: 5 November 2015
 */
class Keychain {
    /**
     *  Save an item to the keychain.
     *  - Parameter value: The string value to save.
     *  - Parameter key: The key to store it under, for accessing later.
     *  - Returns: A boolean value, indicating whether the operation was successful.
     */
    class func save(value: String, forKey key: String) -> Bool {
        if value == "" || key == "" {
            return false
        }
        
        return self.saveToKeychain(key, value: value)
    }
    /**
     *  Load a stored item from the keychain.
     *  - Parameter key: Name of the stored item.
     *  - Returns: A string value, containing the password. Returns an empty string if no matching items where found.
     */
    class func load(key: String) -> String? {
        if key == "" {
            return nil
        }
        
        return self.loadFromKeychain(key)
    }
    /**
     *  Delete a stored item in the keychain.
     *  - Parameter key: Name of the stored item.
     *  - Returns: A boolean value, indicating whether the operation was successful.
     */
    class func delete(key: String) -> Bool {
        if key == "" {
            return false
        }
        
        return self.deleteInKeyChain(key)
    }
    
}

private extension Keychain {
    
    class var service: String! {
        get {
            return NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as? String
        }
    }
    
    class func saveToKeychain(key: String, value: String) -> Bool {
        let keychainQuery: Dictionary<String, AnyObject> = [
            kSecClass as String         : kSecClassGenericPassword as String,
            kSecAttrService as String   : self.service,
            kSecAttrAccount as String   : key,
            kSecValueData as String     : value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        ]
        
        SecItemDelete(keychainQuery as CFDictionaryRef)
        let status: OSStatus = SecItemAdd(keychainQuery as CFDictionaryRef, nil)
        
        if status == noErr {
            return true
        }
        
        return false
    }
    
    class func loadFromKeychain(key: String) -> String? {
        let keychainQuery: Dictionary<String, AnyObject> = [
            kSecClass as String         : kSecClassGenericPassword as String,
            kSecMatchLimit as String    : kSecMatchLimitOne,
            kSecReturnData as String    : kCFBooleanTrue,
            kSecAttrService as String   : self.service,
            kSecAttrAccount as String   : key,
        ]
        
        var result: AnyObject?
        let status: OSStatus = withUnsafeMutablePointer(&result) {
            SecItemCopyMatching(keychainQuery as CFDictionaryRef, UnsafeMutablePointer($0))
        }
        
        
        if status == errSecSuccess {
            if let data = result as? NSData {
                return String(data: data, encoding: NSUTF8StringEncoding)!
            }
        }
        
        return nil
    }
    
    class func deleteInKeyChain(key: String) -> Bool {
        let keychainQuery: Dictionary<String, AnyObject> = [
            kSecClass as String         : kSecClassGenericPassword as String,
            kSecAttrService as String   : self.service,
            kSecAttrAccount as String   : key
        ]
        
        return SecItemDelete(keychainQuery as CFDictionaryRef) == noErr
    }
    
}