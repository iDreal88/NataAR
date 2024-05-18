//
//  PlacementButtonView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct PlacementButtonView: View {
    
    // MARK: - Properties

    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    @Binding var showedObjects: [Model]
    
    // MARK: Body.
    
    var body: some View {
        HStack {
            Button {
                print("Cancel button tapped")
                resetPlacementParameters()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button {
                print("Confirm button tapped")
                modelConfirmedForPlacement = selectedModel
                showedObjects.append((selectedModel!))
                resetPlacementParameters()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
}

// MARK: - Private

private extension PlacementButtonView {

    func resetPlacementParameters() {
        isPlacementEnabled = false
        selectedModel = nil
    }
}

// MARK: - Preview

#if DEBUG
struct PlacementButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlacementButtonView(
            isPlacementEnabled: .constant(false),
            selectedModel: .constant(nil),
            modelConfirmedForPlacement: .constant(nil),
            showedObjects: .constant([])
        )
    }
}
#endif
