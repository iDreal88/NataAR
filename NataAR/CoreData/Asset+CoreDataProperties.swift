//
//  Asset+CoreDataProperties.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 18/05/24.
//
//

import Foundation
import CoreData

extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        return NSFetchRequest<Asset>(entityName: "Asset")
    }

    @NSManaged public var name: String?
    @NSManaged public var isSelected: Bool

}

extension Asset : Identifiable {

}
