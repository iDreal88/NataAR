//
//  ThumbnailView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 31/10/23.
//
import SceneKit
import SwiftUI

struct ThumbnailView: UIViewRepresentable {
    let usdzData: Data?

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.autoenablesDefaultLighting = true
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        if let usdzData = usdzData {
            if let scene = loadUSDZModel(data: usdzData) {
//                print("data:",usdzData)
                uiView.scene = scene
            }
        }
    }

    private func loadUSDZModel(data: Data) -> SCNScene? {
        if let usdzURL = saveDataToTemporaryFile(data: data) {
//            print("usdzurl:",usdzURL)
            return try? SCNScene(url: usdzURL)
        }
        return nil
    }

    private func saveDataToTemporaryFile(data: Data) -> URL? {
        let fileManager = FileManager.default
        let tempDir = FileManager.default.temporaryDirectory
        let tempURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("usdz")

        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Error saving data to a temporary file: \(error.localizedDescription)")
            return nil
        }
    }
}
