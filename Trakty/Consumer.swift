/**
    Consumer
    Holds the client key and secret.
 */
class Consumer {
    
    let key: String
    let secret: String
    
    /**
        The default initializer.
        - Parameters:
            - key: The consumer key
            - secret: The consumer secret
    */
    init(key: String, secret: String) {
        self.key = key
        self.secret = secret
    }
    

    
}