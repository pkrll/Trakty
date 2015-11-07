import Foundation

extension NSURL {
    /**
     *  Split the query string into a Dictionary.
     *  - Returns: A dictionay containing the query items.
     */
    var splitQuery: Dictionary<String, AnyObject>? {
        get {
            if let query = self.query {
                var dictionary = Dictionary<String, AnyObject>()
                
                for components in query.componentsSeparatedByString("&") {
                    let component = components.componentsSeparatedByString("=")
                    if component.count < 2 {
                        continue
                    }
                    
                    let field = component[0].stringByRemovingPercentEncoding!
                    let value = component[1].stringByRemovingPercentEncoding!
                    
                    dictionary[field] = value
                }
                
                return dictionary
            }
            
            return [:]
        }
    }
    /**
     *  Append a query parameters to the query string of a URL.
     *  - Parameter value: The value of the query item.
     *  - Parameter key: The field name of the query item.
     *  - Returns: A new NSURL with the updated query string.
     */
    func appendQuery(value: String, forKey key: String) -> NSURL {
        if key == "" {
            return self
        }
        
        let query = NSURLQueryItem(name: key, value: value)
        let newURL = NSURLComponents(string: self.absoluteString)!
        
        if newURL.queryItems?.count < 1 {
            newURL.queryItems = Array<NSURLQueryItem>()
        }
        
        newURL.queryItems?.append(query)
        
        return (newURL.URL)!
    }
    /**
     *  Append multiple query parameters to a URL.
     *  - Parameter queryString A dictionary with a String key and String value representing the field-value-pair.
     *  - Returns: A new NSURL with the updated query string.
     */
    func appendQueries(queryString: Dictionary<String, String>) -> NSURL {
        if queryString.count < 1 {
            return self
        }
        
        let newURL = NSURLComponents(string: self.absoluteString)!
        
        var queryItems: Array<NSURLQueryItem> = []
        for (field, value) in queryString {
            let queryItem = NSURLQueryItem(name: field, value: value)
            queryItems.append(queryItem)
        }
        
        if newURL.queryItems?.count < 1 {
            newURL.queryItems = Array<NSURLQueryItem>()
        }
        
        newURL.queryItems?.appendContentsOf(queryItems)
        
        return (newURL.URL)!
    }
    
}