//
//  DataController.swift
//  TraktApp
//
//  Created by Ardalan Samimi on 06/11/15.
//  Copyright © 2015 Saturn Five. All rights reserved.
//

import UIKit
import CoreData

typealias DataCompletionHandler = (didSucceed: Bool, result: Array<AnyObject>?, error: NSError?) -> Void

class DataController {
    
    private let entityName: String
    private let queue: dispatch_queue_t
    private let _managedObjectContext: NSManagedObjectContext
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    /**
     *  Public accessor for the managed object context.
     *  - Complexion: DataController takes care not letting user access the managed object context object before the persistent store has loaded. Typed as an optional.
     *  - Returns: If the persisent store has loaded, the return value will be the managed object context object, otherwise nil.
     */
    var managedObjectContext: NSManagedObjectContext? {
        get {
            guard let coordinator = self._managedObjectContext.persistentStoreCoordinator else {
                return nil
            }
            
            if coordinator.persistentStores.isEmpty {
                return nil
            }
            
            return _managedObjectContext
        }
    }
    /**
     *  Initializes the DataController.
     *  - Parameter withEntityName: Defines the name of the core data entity.
     */
    init(withEntityName entityName: String) {
        self.entityName = entityName
        let mainAppBundle = NSBundle.mainBundle()
        let dataModelName = mainAppBundle.infoDictionary!["CFBundleName"] as! String
        // See if the managed object model exists in the bundle.
        guard let modelURL = mainAppBundle.URLForResource(dataModelName, withExtension: "momd") else {
            fatalError("Error loading model from bundle.")
        }
        // Check if it can be laoded
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing object model from \(modelURL)")
        }
        // Initialize the managed object context
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        self._managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self._managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let dispatch_queue_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0)
        self.queue = dispatch_queue_create("DataControllerSerialQueue", dispatch_queue_attr)
        dispatch_async(queue) {
            let URLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let documentURL = URLs[URLs.endIndex-1]
            let storeURL = documentURL.URLByAppendingPathComponent("\(dataModelName).sqlite")
            do {
                try self.persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    /**
     *  Save to the persistent store.
     *  - Parameters:
     *      - values: A dictionary constructed the same way as the entity.
     *      - completionHandler: Callback upon completion.
     */
    func save(values: Dictionary<String, AnyObject>, completionHandler: DataCompletionHandler?) {
        dispatch_async(queue) {
            guard let managedObjectContext = self.managedObjectContext else {
                completionHandler?(didSucceed: false, result: nil, error: NSError(domain: NSCocoaErrorDomain, code: 101, userInfo: nil))
                return
            }
            
            let item = NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: managedObjectContext) as? AccessTokenMeta
            for (key, value) in values {
                item?.setValue(value, forKey: key)
            }
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                completionHandler?(didSucceed: false, result: nil, error: error)
            }
            
            completionHandler?(didSucceed: true, result: nil, error: nil)
        }
    }
    /**
     *  Loads all stored data in store.
     *  - Parameter completionHandler: Callback upon completion.
     */
    func load(completionHandler: DataCompletionHandler?) {
        dispatch_async(queue) {
            guard let managedObjectContext = self.managedObjectContext else {
                completionHandler?(didSucceed: false, result: nil, error: NSError(domain: NSCocoaErrorDomain, code: 102, userInfo: nil))
                return
            }
            
            let request = NSFetchRequest(entityName: self.entityName)
            do {
                if let results = try managedObjectContext.executeFetchRequest(request) as? [AccessTokenMeta]  {
                    completionHandler?(didSucceed: true, result: results, error: nil)
                }
            } catch let error as NSError {
                completionHandler?(didSucceed: false, result: nil, error: error)
            }

        }
    }
    /**
     *  Remove all stored data in store.
     *  - Parameter completionHandler: Callback upon completion.
     */
    func reset(completionHandler: DataCompletionHandler?) {
        dispatch_async(queue) {
            guard let managedObjectContext = self.managedObjectContext else {
                completionHandler?(didSucceed: false, result: nil, error: NSError(domain: NSCocoaErrorDomain, code: 103, userInfo: nil))
                return
            }
            
            let request = NSFetchRequest(entityName: self.entityName)
            
            do {
                let results = try managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
                for result in results {
                    managedObjectContext.deleteObject(result)
                }                
            } catch let error as NSError {
                completionHandler?(didSucceed: false, result: nil, error: error)
            }
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                completionHandler?(didSucceed: false, result: nil, error: error)
            }
            
            completionHandler?(didSucceed: true, result: nil, error: nil)
        }
    }
}