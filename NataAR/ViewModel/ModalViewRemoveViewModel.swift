//
//  ModalViewRemoveViewModel.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 08/05/24.
//

import SwiftUI
import CoreData

class ModalViewRemoveViewModel: ObservableObject {
    @Published var isMultiSelectionActive = false
    @Published var isSelectAll = false
    
    func deleteAsset(at offsets: IndexSet, from assets: FetchedResults<Asset>, in context: NSManagedObjectContext) {
        for index in offsets {
            let asset = assets[index]
            context.delete(asset)
        }
        saveContext(context)
    }
    
    func deleteObject(at offsets: IndexSet, from objects: FetchedResults<ObjectEntity>, in context: NSManagedObjectContext) {
        for index in offsets {
            let object = objects[index]
            context.delete(object)
        }
        saveContext(context)
    }
    
    func deleteSelected(in context: NSManagedObjectContext, assets: FetchedResults<Asset>, importsObject: FetchedResults<ObjectEntity>) {
        for asset in assets where asset.isSelected {
            context.delete(asset)
        }
        for object in importsObject where object.isSelected {
            context.delete(object)
        }
        saveContext(context)
    }
    
    func toggleMultiSelection(assets: FetchedResults<Asset>, importsObject: FetchedResults<ObjectEntity>) {
        isMultiSelectionActive.toggle()
        if isMultiSelectionActive {
            for asset in assets {
                asset.isSelected = false
            }
            for object in importsObject {
                object.isSelected = false
            }
        }
    }
    
    func toggleSelectAll(assets: FetchedResults<Asset>, importsObject: FetchedResults<ObjectEntity>) {
        isSelectAll.toggle()
        let newSelectionState = isSelectAll
        for asset in assets {
            asset.isSelected = newSelectionState
        }
        for object in importsObject {
            object.isSelected = newSelectionState
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
