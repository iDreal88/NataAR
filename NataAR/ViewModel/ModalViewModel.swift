//
//  ModalViewModel.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import CoreData

class ModalViewModel: ObservableObject {
    // MARK: - Methods
    func filteredItems(from items: [String], excluding assets: FetchedResults<Asset>) -> [String] {
        let assetNames = assets.map { $0.name ?? "" }
        return items.filter { !assetNames.contains($0) }
    }
    
    func addNewAsset(named name: String, in context: NSManagedObjectContext) {
        let newAsset = Asset(context: context)
        newAsset.name = name
        try? context.save()
    }
}
