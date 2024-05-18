//
//  MenuView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 12/05/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Image("nata-logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 288, height: 160)
                        .padding(.bottom,70)
                    
                    
                    NavigationLink(destination: ContentView()) {
                        HStack{
                            Text("Start Project")
                        }
                        .padding(20)
                        .font(.title)
                        .frame(width: 300)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: ObjectView()) {
                        HStack{
                            Image(systemName: "camera.viewfinder")
                            Text("Scan Object")
                        }
                        .padding(20)
                        .font(.title)
                        .frame(width: 300)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
