//
//  NSManagedObjectContextExtension.swift
//  WeatherMinimalism
//
//  Created by Maxim Zheleznyy on 6/4/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    @discardableResult public func saveIfHasChanges() throws -> Bool {
        guard hasChanges else { return false }
        try save()
        return true
    }
}
