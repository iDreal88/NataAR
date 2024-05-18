//
//  ARViewRepresentable.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding var modelConfirmedForPlacement: Model?
    @Binding var shouldRemoveAllModels: Bool
    @Binding var isMetallic: Bool
    @Binding var isResetMaterials: Bool
    @Binding var selectedObject: Model
    @Binding var showedObjects: [Model]
    @Binding var objectColor: Color?
    @Binding var removeModel: Model?
    
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> ARView {
        CustomARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if((removeModel) != nil){
            uiView.scene.findEntity(named: removeModel!.modelName)?.removeFromParent()
            DispatchQueue.main.async {
                removeModel = nil
                selectedObject =  Model(modelName: "")
            }
        }
        if shouldRemoveAllModels {
            uiView.scene.anchors.forEach { anchor in
                anchor.children.forEach { entity in
                    entity.removeFromParent()
                }
            }
            DispatchQueue.main.async {
                showedObjects = []
                selectedObject =  Model(modelName: "")
                shouldRemoveAllModels = false
            }
        } else if let model = modelConfirmedForPlacement,
                  let modelEntity = model.modelEntity {
            
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            uiView.scene.addAnchor(anchorEntity)
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
            
            modelEntity.generateCollisionShapes(recursive: true)
            uiView.installGestures([.translation,.rotation,.scale], for: modelEntity)
            
        }
        
        if let modelEntity = uiView.scene.findEntity(named: selectedObject.id) as? ModelEntity{
            
            if(isResetMaterials){
                DispatchQueue.main.async {
                    isResetMaterials = false
                    objectColor = nil
                }
                modelEntity.model!.materials = selectedObject.defaultMaterials
            }
            else if((objectColor) != nil){
                let newMaterial = SimpleMaterial(color: UIColor(objectColor!), isMetallic: isMetallic)
                for index in 0..<modelEntity.model!.materials.count {
                    modelEntity.model!.materials[index] = newMaterial
                }
            }
        }
    }
    
}
