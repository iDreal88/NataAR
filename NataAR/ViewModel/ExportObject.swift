//
//  ExportObject.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 08/05/24.
//

import Foundation
import SceneKit
import CoreData
import Combine
import SwiftUI
import ModelIO
import RealityKit

class ExportObject: ObservableObject {
    
    func saveSceneAsUSDZ(with model: Model,completion: @escaping (Result<URL, Error>) -> Void) {
        
        let fileManager = FileManager.default
        do {
            let downloadsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let usdzFileURL = downloadsDirectory.appendingPathComponent("output.usdz")
            
            
            let rootScene = SCNScene()
            
            if let modelasset = try? SCNScene(url: model.usdzURL!){
                let modelNode = modelasset.rootNode.childNodes.first?.clone()
                if(model.isImported == false){
                    modelNode!.scale = SCNVector3(0.01, 0.01, 0.01)
                }
                if(model.color != Color.clear){
                    modelNode!.enumerateChildNodes { (node, _) in
                        if let geometry = node.geometry {
                            geometry.materials.forEach { material in
                                material.diffuse.contents = UIColor(model.color)
                                if model.isMetallic {
                                    material.metalness.contents = 1.0
                                    material.roughness.contents = 0.0
                                } else {
                                    material.metalness.contents = 0.0
                                    material.roughness.contents = 1.0
                                }
                            }
                        }
                    }
                }
                // Clear existing content in rootScene
                rootScene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
                rootScene.rootNode.addChildNode(modelNode!)
            }
            
            
            try rootScene.write(to: usdzFileURL, options: nil, delegate: nil)
            completion(.success(usdzFileURL))
        } catch {
            completion(.failure(error))
        }
    }
}
