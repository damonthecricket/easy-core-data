//
//  CoreDataModel.swift
//  EasyCoreData
//
//  Created by Damon Cricket on 27.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CDModel

public protocol CDModel: NSFetchRequestResult {
    
    static var EntityName: String {get}
}

public extension CDModel {
    
    static func new(withManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Self {
        return NSEntityDescription.insertNewObject(forEntityName: Self.EntityName, into: managedObjectContext) as! Self
    }
}
