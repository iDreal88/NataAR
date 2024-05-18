//
//  ObjectEntity+CoreDataProperties.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 16/05/24.
//
//

import Foundation
import CoreData

extension ObjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectEntity> {
        return NSFetchRequest<ObjectEntity>(entityName: "ObjectEntity")
    }

    @NSManaged public var importedName: String?
    @NSManaged public var importedObject: Data?
    @NSManaged public var isSelected: Bool

}

extension ObjectEntity : Identifiable {

}
