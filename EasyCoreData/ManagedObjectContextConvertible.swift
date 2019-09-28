//
//  ManagedObjectContextConvertible.swift
//  EasyCoreData
//
//  Created by Damon Cricket on 27.09.2019.
//  Copyright © 2019 DC. All rights reserved.
//

import Foundation
import CoreData

// MARK: - ManagedObjectContextConvertible

public protocol ManagedObjectContextConvertible {
    
    var context: NSManagedObjectContext {get}
}

extension NSManagedObjectContext: ManagedObjectContextConvertible {
    
    public var context: NSManagedObjectContext {
        return self
    }
}

extension NSPersistentContainer: ManagedObjectContextConvertible {
    
    public var context: NSManagedObjectContext {
        return viewContext
    }
}
