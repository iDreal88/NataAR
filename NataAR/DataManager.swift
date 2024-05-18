//
//  DataManager.swift
//  SwiftUI Simple AssetList
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import CoreData
import Foundation

/// Main data manager to handle the asset items
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var assets: [Asset] = [Asset]()
    
    /// Add the Core Data container with the model name
    let container: NSPersistentContainer = NSPersistentContainer(name: "CoreData")
    
    /// Default init method. Load the Core Data container
    override init() {
        super.init()
        container.loadPersistentStores { _, _ in }
    }
}
