//
//  ProfileView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }.toolbar {
            Circle()
                .fill(.gray)
                .frame(width: 42, height: 42)
                .overlay {
                    Text("J")
                        .foregroundColor(.white)
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
