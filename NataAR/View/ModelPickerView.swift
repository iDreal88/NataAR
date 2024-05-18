//
//  ModelPickerView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ModelPickerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var assets: FetchedResults<Asset>
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    
    @FetchRequest(entity: ObjectEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \ObjectEntity.importedName, ascending: true)])
    var importsObject: FetchedResults<ObjectEntity>
    @State private var sceneKitView: ThumbnailView?
    
    @StateObject private var ObjectVM = ObjectViewModel()
    
    
    // MARK: Body
    
    var body: some View {
        HStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(assets, id: \.self) { asset in
                        Button {
                            selectedModel = Model(modelName: asset.name!)
                            isPlacementEnabled = true
                        } label: {
                            Image(uiImage: UIImage(named: asset.name!)!)
                                .resizable()
                                .frame(height: 80)
                                .aspectRatio(1/1, contentMode: .fit)
                                .background( Color.white)
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    ForEach(importsObject, id: \.self) { item in
                        Button {
                            selectedModel = Model(modelName: item.importedName!, usdzData: item.importedObject!)
                            isPlacementEnabled = true
                        } label: {
                            
                            if let usdzData = item.importedObject {
                                ThumbnailView(usdzData: usdzData)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}
