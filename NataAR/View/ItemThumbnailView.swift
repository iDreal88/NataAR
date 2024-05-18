//
//  ItemThumbnailView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ItemThumbnailView: View {
    // MARK: - Properties
    let name: String
    
    // MARK: - Body
    var body: some View {
        Image(uiImage: UIImage(named: name)!)
            .resizable()
            .frame(height: 80)
            .aspectRatio(1/1, contentMode: .fit)
            .background(Color.white)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
