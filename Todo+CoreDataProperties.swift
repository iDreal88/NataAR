//
//  Todo+CoreDataProperties.swift
//  NataAR
//
//  Created by Denny Chandra Wijaya on 13/05/24.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var name: String?
    @NSManaged public var isSelected: Bool

}

extension Todo : Identifiable {

}
