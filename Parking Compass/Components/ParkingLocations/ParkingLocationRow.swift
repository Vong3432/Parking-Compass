//
//  ParkingLocationRow.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 04/03/2022.
//

import SwiftUI

struct ParkingLocationRow: View {
    
    let location: Location
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.cyan)
                Text(location.name)
                    .font(.body)
                Spacer()
            }
        }
        .padding()
        .background(Color.theme.background.opacity(0.7))
        .cornerRadius(12)
    }
}

struct ParkingLocationRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink {
                Text("Hey")
            } label: {
                ParkingLocationRow(location: DeveloperPreview.mockLocations[0])
            }
        }
            .previewLayout(.sizeThatFits)
    }
}
