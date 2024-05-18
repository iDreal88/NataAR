//
//  USDZURLModel.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 08/06/24.
//

import SwiftUI

class USDZURLModel: ObservableObject {
    @Published var usdzURL: URL
    
    init(initialURL: URL) {
        self.usdzURL = initialURL
    }
}
