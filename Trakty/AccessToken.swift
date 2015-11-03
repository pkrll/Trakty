
class AccessToken {
    
    private var key: String
    private var secret: String?
    
    init(key: String) {
        self.key = key
    }
    
    init(key: String, secret: String) {
        self.key = key;
        self.secret = secret
    }
    
    func token(with secret: Bool) -> (key: String, secret: String?) {
        var token: (key: String, secret: String?) = (key: self.key, secret: nil)
        
        if (secret == true) {
            token.secret = self.secret
        }
        
        return token
        
    }
    
}