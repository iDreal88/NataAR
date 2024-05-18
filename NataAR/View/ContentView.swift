//
//  ContentView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    // MARK: - Environment
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    // MARK: - Fetch Requests
    @FetchRequest(sortDescriptors: []) private var assets: FetchedResults<Asset>
    
    // MARK: - Observed Objects
    @ObservedObject var usdzURLModel = USDZURLModel(initialURL: Bundle.main.url(forResource: "fender", withExtension: "usdz")!)
    @StateObject private var objectViewModel = ObjectViewModel()
    
    // MARK: - State Properties
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    @State private var showedObjects: [Model] = []
    @State private var selectedObject: Model = Model(modelName: "")
    @State private var objectColor: Color?
    @State private var shouldRemoveAllModels: Bool = false
    @State private var removeModel: Model?
    @State private var isPlacementEnabled: Bool = false
    @State private var isModalVisible: Bool = false
    @State private var showSaveAlert: Bool = false
    @State private var isSidebarOpen: Bool = false
    @State private var isExport: Bool = false
    @State private var showingObjectList: Bool = false
    @State private var isMetallic: Bool = false
    @State private var isModalRemoveVisible: Bool = false
    @State private var isResetMaterials: Bool = false
    
    let items = [
        "biplane",
        "drummer",
        "fender",
        "gramophone",
        "retrotv",
        "robot",
        "teapot",
        "wateringcan",
        "wheelbarrow"
    ]
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .top) {
                HStack{
                }
            }
            .padding()
            .sheet(isPresented: $isExport, onDismiss: {
                isExport = false
            }) {
                ModelView(modelFile: usdzURLModel.usdzURL, endCaptureCallback: {})
            }
            
            
            ZStack(alignment: .bottom) {
                ARViewRepresentable(
                    modelConfirmedForPlacement: $modelConfirmedForPlacement,
                    shouldRemoveAllModels: $shouldRemoveAllModels,
                    isMetallic: $isMetallic, isResetMaterials: $isResetMaterials,
                    selectedObject: $selectedObject,
                    showedObjects: $showedObjects, objectColor: $objectColor, removeModel: $removeModel
                    
                )
                
                SideBarView(showingObjectList: $showingObjectList, showedObjects: $showedObjects, selectedObject: $selectedObject, removeModel: $removeModel, isMetallic: $isMetallic, isExport: $isExport, shouldRemoveAllModels: $shouldRemoveAllModels, isResetMaterials: $isResetMaterials, usdzURL: $usdzURLModel.usdzURL, objectColor: $objectColor)
                
                if isPlacementEnabled {
                    PlacementButtonView(
                        isPlacementEnabled: $isPlacementEnabled,
                        selectedModel: $selectedModel,
                        modelConfirmedForPlacement: $modelConfirmedForPlacement,
                        showedObjects: $showedObjects
                    )
                } else {
                    ModelPickerView(
                        isPlacementEnabled: $isPlacementEnabled,
                        selectedModel: $selectedModel
                    )
                }
            }
        }
        .navigationBarItems(trailing:
                                HStack {
            
            Button(action: {
                isModalRemoveVisible.toggle()
            }) {
                HStack{
                    Image(systemName: "minus")
                    Text("Remove")
                }
                .frame(width: 100)
                .padding(.all,10)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .sheet(isPresented: $isModalRemoveVisible) {
                ModalViewRemove(isModalVisible: $isModalRemoveVisible)
            }
            
            
            Button(action: {
                isModalVisible.toggle()
            }) {
                HStack{
                    Image(systemName: "plus")
                    Text("Add")
                }
                .frame(width: 100)
                .padding(.all,10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .sheet(isPresented: $isModalVisible) {
                ModalView(items: items, isModalVisible: $isModalVisible)
            }
            
            Spacer()
            
            Button(action: {
                objectViewModel.manager = manager
                objectViewModel.presentDocumentPicker()
            }) {
                HStack{
                    Image(systemName: "plus")
                        .font(.title2)
                    Text("Import Object")
                }
            }
        }
            .frame(width: 700)
        )
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
