//
//  ModalView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ModalView: View {
    // MARK: - Properties
    let items: [String]
    
    // MARK: - Environment
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - Fetch Requests
    @FetchRequest(sortDescriptors: []) private var assets: FetchedResults<Asset>
    
    // MARK: - Bindings
    @Binding var isModalVisible: Bool
    
    // MARK: - State Objects
    @StateObject private var viewModel = ModalViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(viewModel.filteredItems(from: items, excluding: assets), id: \.self) { item in
                Button(
                    action: {
                        viewModel.addNewAsset(named: item, in: viewContext)
                    },
                    label: {
                        ItemThumbnailView(name: item)
                    }
                )
            }
            .navigationBarTitle("Add new object")
            .navigationBarItems(trailing: Button("Done") {
                isModalVisible = false
            })
        }
    }
}
