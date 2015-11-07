//
//  AccessTokenMeta.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 07/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit
import CoreData

class AccessTokenMeta: NSManagedObject {

    class func saveMeta(createdAt: String, expiresIn: String) {
        let dateFormatter = NSDateFormatter()
        let creationDate = dateFormatter.dateFromString(createdAt)
        let expirationDate = dateFormatter.dateFromString(expiresIn)
        
        let valuesToSave: Dictionary<String, AnyObject> = [
            "createdAt": creationDate!,
            "expiresIn": expirationDate!
        ]
        
        let dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
        dataController.reset { (didSucceed, result, error) -> Void in
            if didSucceed {
                dataController.save(valuesToSave, completionHandler: nil)
            }
        }
    }

    class func name() -> String {
        return self.description().stringByReplacingOccurrencesOfString("TraktApp.", withString: "")
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        guard let dateValue = value as? NSDate else {
            return
        }
        
        if key == "createdAt" || key == "expiresIn" {
            super.setValue(dateValue, forKey: key)
        }
    }
    
}

extension AccessTokenMeta {
    
    @NSManaged var createdAt: NSDate?
    @NSManaged var expiresIn: NSDate?
    
}