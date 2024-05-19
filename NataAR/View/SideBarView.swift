//
//  SideBarView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct SideBarView: View {
    
    @Binding var showingObjectList: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.2
    var sideBarHeight = UIScreen.main.bounds.size.height
    
    @State var customList = true
    @State var objectList = true
    @Binding var showedObjects: [Model]
    @Binding var selectedObject: Model
    @Binding var removeModel: Model?
    @Binding var isMetallic: Bool
    @Binding var isExport: Bool
    @Binding var shouldRemoveAllModels: Bool
    @Binding var isResetMaterials: Bool
    @Binding var usdzURL: URL
    @Binding var objectColor: Color?
    @StateObject var exportObject:ExportObject = ExportObject()
    
    @State private var isToggled = false
    @State private var showDeleteAllAlert = false
    @State private var isChangeColor = false
    @State private var objectColorView: Color = Color.white
    
    var body: some View {
        HStack {
            ZStack(alignment: .top) {
                MenuChevron
                List {
                    Section(isExpanded: $objectList,
                            content: {
                        VStack{
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack{
                                    ForEach(showedObjects, id: \.id) { showedObject in
                                        Button {
                                            selectedObject = Model(modelName: "")
                                            selectedObject = showedObject
                                            isMetallic = showedObject.isMetallic
                                            isChangeColor = false
                                            objectColorView = showedObject.color
                                        } label: {
                                            if (showedObject.isImported == true) {
                                                ThumbnailView(usdzData: showedObject.usdzData)
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(12)
                                                    .shadow(radius: 2)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .overlay(
                                                        Group {
                                                            if selectedObject.id == showedObject.id {
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(Color.blue, lineWidth: 4)
                                                            }
                                                        }
                                                    )
                                            }else{
                                                Image(uiImage: UIImage(named: showedObject.modelName)!)
                                                    .resizable()
                                                    .frame(height: 80)
                                                    .aspectRatio(1/1, contentMode: .fit)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        Group {
                                                            if selectedObject.id == showedObject.id {
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(Color.blue, lineWidth: 4)
                                                            }
                                                        }
                                                    )
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.leading,10)
                                .padding(.vertical,10)
                            }
                            Button {
                                showDeleteAllAlert = true
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Remove All")
                                }
                                .padding(.all,10)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                        .alert(isPresented: $showDeleteAllAlert) {
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("This will delete all objects."),
                                primaryButton: .destructive(Text("Delete")) {
                                    shouldRemoveAllModels = true
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                    }, header: {
                        Image(systemName: "square.split.bottomrightquarter")
                        Text("List of Objects")
                    })
                    
                    
                    Section(isExpanded: $customList, content: {
                        VStack{
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                if(selectedObject.modelName != ""){
                                    
                                    ColorPicker("Color", selection: $objectColorView)
                                        .padding()
                                        .onChange(of: objectColorView) { oldValue, newValue in
                                            objectColor = objectColorView
                                            for index in 0..<showedObjects.count {
                                                if(showedObjects[index] == selectedObject){
                                                    showedObjects[index].color = newValue
                                                }
                                            }
                                        }
                                    
                                    
                                    Button(action: {
                                        isResetMaterials = true
                                        selectedObject.color = Color.clear
                                    }) {
                                        Text("Reset Color")
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(10)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Divider()
                                        .padding(.top, 10)
                                    
                                    Toggle(isOn: $isMetallic) {
                                        Text("Lighting")
                                    }
                                    .onChange(of: isMetallic) { oldValue, newValue in
                                        for index in 0..<showedObjects.count {
                                            if(showedObjects[index] == selectedObject){
                                                showedObjects[index].isMetallic = newValue
                                            }
                                        }
                                    }
                                    .padding()
                                    
                                    Divider()
                                        .padding(.bottom, 10)
                                    
                                    Button(action: {
                                        exportObject.saveSceneAsUSDZ(with: selectedObject) { result in
                                            switch result {
                                            case .success(let usdzURLNew):
                                                print("Scene saved as USDZ: \(usdzURL)")
                                                usdzURL = usdzURLNew
                                            case .failure(let error):
                                                print("Error saving scene as USDZ: \(error.localizedDescription)")
                                            }
                                        }
                                        
                                        isExport = true
                                    }) {
                                        Text("Export AR Look")
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(10)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    
                                    Button(action: {
                                        if let index = showedObjects.firstIndex(where: { $0 == selectedObject }) {
                                            removeModel = showedObjects[index]
                                            showedObjects.remove(at: index)
                                        }
                                    }) {
                                        Text("Remove Object")
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(10)
                                    .buttonStyle(PlainButtonStyle())
                                }else{
                                    Text("Select the object")
                                }
                            }
                        }
                        .frame(height: 240)
                        
                    }, header: {
                        Image(systemName: "pencil")
                        Text("Customize Object")
                    })
                    
                }
                .background(.regularMaterial)
                .scrollContentBackground(.hidden)
                .listStyle(.sidebar)
            }
            .frame(width: sideBarWidth)
            .offset(x: showingObjectList ? 0 : -sideBarWidth)
            .animation(.default, value: showingObjectList)
            Spacer()
        }
        .padding(.top, 1)
        .font(.subheadline)
        .animation(.easeInOut(duration: 5), value: showingObjectList)
    }
    
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 80, height: 100)
                .offset(x: showingObjectList ? -18 : -15)
                .onTapGesture {
                    showingObjectList.toggle()
                }
                .foregroundStyle(.regularMaterial)
            
            Image(systemName: "chevron.right")
                .bold()
                .rotationEffect(
                    showingObjectList ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: 2)
                .foregroundColor(.gray)
                .font(.title3)
        }
        .offset(x: sideBarWidth / 1.8, y: 20)
    }
}
