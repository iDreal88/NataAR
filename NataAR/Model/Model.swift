//
//  Model.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import RealityKit
import Combine

class Model {

    // MARK: - Properties

    static let modelNames = [
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

    var id = UUID().uuidString
    var modelName: String
    var image: UIImage?
    var modelEntity: ModelEntity?
    var isMetallic: Bool
    var color: Color
    var usdzData: Data?
    var usdzURL: URL?
    var defaultMaterials: [RealityKit.Material] = []
    var isImported: Bool = false

    private var cancellable: AnyCancellable? = nil

    // MARK: - Lifecycle

    init(modelName: String, usdzData: Data = Data()) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)
        self.isMetallic = false
        self.color = Color.white
        self.usdzData = usdzData
         
        if(usdzData.count != 0){
            let temporaryDirectory = FileManager.default.temporaryDirectory
            let usdzFileURL = temporaryDirectory.appendingPathComponent(self.modelName + ".usdz")
            do {
                try usdzData.write(to: usdzFileURL)
                print("USDZ file written successfully to:", usdzFileURL)
                self.usdzURL = usdzFileURL
                self.isImported = true
                
                self.cancellable = ModelEntity.loadModelAsync(contentsOf: usdzFileURL)
                    .sink(receiveCompletion: { loadCompletion in
                        switch loadCompletion {
                        case .failure(let error):
                            print("Failed to load modelEntity:", error)
                        case .finished:
                            print("loadModelAsync finished successfully")
                        }
                    }, receiveValue: { modelEntity in
                        print(modelEntity)
                        self.modelEntity = modelEntity
                        self.defaultMaterials = modelEntity.model?.materials ?? []
                        self.modelEntity?.name = self.id
                    })
                } catch {
                    print("Error writing USDZ data to temporary file:", error)
                }
        }
        else{
            self.usdzURL = Bundle.main.url(forResource: modelName, withExtension: "usdz")!
            let filename = modelName + ".usdz"
            self.cancellable = ModelEntity.loadModelAsync(named: filename)
                .sink { loadCompletion in
                    if case .failure(let error) = loadCompletion {
                        print("Unable to load modelEntity for: \(modelName)")
                        print("Error: \(error)")
                    }
                } receiveValue: { modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.name = self.id
                    self.defaultMaterials = modelEntity.model?.materials ?? []
                    print("Successfully loaded modelEntity for: \(modelName)")
                }
        }

    }
}

// MARK: - Hashable

extension Model: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelName)
    }
}

// MARK: - Equatable

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.modelName == rhs.modelName
    }
}

