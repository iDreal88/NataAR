//
//  ModalViewRemove.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ModalViewRemove: View {
    // MARK: - Environment
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - Fetch Requests
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Asset.name, ascending: true)]) private var assets: FetchedResults<Asset>
    @FetchRequest(entity: ObjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ObjectEntity.importedName, ascending: true)])
    var importsObject: FetchedResults<ObjectEntity>
    
    // MARK: - Bindings
    @Binding var isModalVisible: Bool
    
    // MARK: - State Objects
    @StateObject private var viewModel = ModalViewRemoveViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                List {
                    // Display assets
                    ForEach(assets, id: \.self) { item in
                        HStack {
                            if(viewModel.isMultiSelectionActive) {
                                Button(action: {
                                    item.isSelected.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: item.isSelected ? "largecircle.fill.circle" : "circle")
                                    }
                                }
                            }
                            
                            Image(uiImage: UIImage(named: item.name!)!)
                                .resizable()
                                .frame(height: 80)
                                .aspectRatio(1/1, contentMode: .fit)
                                .background(Color.white)
                                .cornerRadius(12)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteAsset(at: indexSet, from: assets, in: viewContext)
                    }
                    
                    // Display imported objects
                    ForEach(importsObject, id: \.self) { item in
                        if let usdzData = item.importedObject {
                            HStack {
                                if(viewModel.isMultiSelectionActive) {
                                    Button(action: {
                                        item.isSelected.toggle()
                                    }) {
                                        HStack {
                                            Image(systemName: item.isSelected ? "largecircle.fill.circle" : "circle")
                                        }
                                    }
                                }
                                ThumbnailView(usdzData: usdzData)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteObject(at: indexSet, from: importsObject, in: viewContext)
                    }
                }
                
                // Delete selected button
                if(viewModel.isMultiSelectionActive) {
                    Button(action: {
                        viewModel.deleteSelected(in: viewContext, assets: assets, importsObject: importsObject)
                    }) {
                        Image(systemName: "trash")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationBarTitle("Remove items")
            .navigationBarItems(trailing:
                HStack {
                    // Select/Deselect All button
                    if(viewModel.isMultiSelectionActive) {
                        Button(action: {
                            viewModel.toggleSelectAll(assets: assets, importsObject: importsObject)
                        }) {
                            Text(viewModel.isSelectAll ? "Deselect All" : "Select All")
                        }
                    }
                    
                    // Multi-Selection Toggle button
                    Button(action: {
                        viewModel.toggleMultiSelection(assets: assets, importsObject: importsObject)
                    }) {
                        Text(viewModel.isMultiSelectionActive ? "Cancel" : "Select")
                    }
                    
                    // Done button
                    Button("Done") {
                        isModalVisible = false
                    }
                }
            )
        }
    }
}
