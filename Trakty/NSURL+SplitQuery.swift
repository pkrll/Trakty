import Foundation

extension NSURL {
    /**
     *  Split the query string into a Dictionary.
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
}