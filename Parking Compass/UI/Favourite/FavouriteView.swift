//
//  FavouriteView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import SwiftUI

struct FavouriteView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(0..<5) { _ in
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.cyan)
                                Text("123 Jalan Sutera Utama, 2/12 Sutera Utama")
                                    .font(.body)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.theme.background.opacity(0.7))
                        .cornerRadius(12)
                    }
                }
            }.padding()
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView()
    }
}
