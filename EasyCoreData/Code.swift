//
//  Fetch.swift
//  EasyCoreData
//
//  Created by Damon Cricket on 27.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Load

@available(iOS 10.0, *)
public func Load(persistantContainerName name: String, completion: @escaping (NSPersistentStoreDescription, Error?, NSPersistentContainer) -> Void) {
    let container = NSPersistentContainer(name: name)
    container.loadPersistentStores { descriptor, error in
        completion(descriptor, error, container)
    }
}

@available(iOS 9.0, *)
public func Load(persistantStoreName name: String, completion: @escaping (NSManagedObjectContext?, Error?) -> Void) {
    guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
        fatalError("Error loading model from bundle.")
    }
    
    guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
        fatalError("Error initializing mom from \(modelURL).")
    }
    
    let persistantStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    
    let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = persistantStoreCoordinator
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Unable to resolve document directory.")
        }
        
        let storeURL = docURL.appendingPathComponent("\(name).sqlite")
        
        do {
            try persistantStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            completion(managedObjectContext, nil)
        } catch {
            completion(nil, error)
        }
    }
}

// MARK: - Save

public func Save(managedObjectContext: ManagedObjectContextConvertible, completion: ((Error?) -> Void)? = nil) {
    do {
        try managedObjectContext.context.save()
        completion?(nil)
    } catch {
        completion?(nil)
    }
}

// MARK: - Delete

public func Delete(entitiesWithName name: String, fromManagedObjectContext managedObjectContext: ManagedObjectContextConvertible) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
    Fetch(request: fetchRequest, fromManagedObjectContext: managedObjectContext) {fetchedObjects, error in
        if let managedObjects = fetchedObjects as? [NSManagedObject] {
            Delete(managedObjects: managedObjects, fromManagedObjectContext: managedObjectContext)
        }
    }
}

public func Delete(managedObjects: [NSManagedObject], fromManagedObjectContext managedObjectContext: ManagedObjectContextConvertible) {
    for managedObject in managedObjects {
        managedObjectContext.context.delete(managedObject)
    }
}

// MARK: - Fetch

public func Fetch(request: NSFetchRequest<NSFetchRequestResult>, fromManagedObjectContext managedObjectContext: ManagedObjectContextConvertible, completion: (([Any]?, Error?) -> Void)? = nil) {
    do {
        let result = try managedObjectContext.context.fetch(request)
        completion?(result, nil)
    } catch {
        completion?(nil, error)
    }
}
