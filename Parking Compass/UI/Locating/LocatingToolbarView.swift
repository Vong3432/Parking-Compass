//
//  LocatingToolbarView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 27/02/2022.
//

import SwiftUI

struct LocatingToolbarView: ToolbarContent {
    
    var isMapView: Bool
    var headingAvailable: Bool
    var onPress: ((Bool) -> Void)?
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button {
                onPress?(true)
            } label: {
                Image(systemName: "map.fill")
            }
            .tint(isMapView ? Color.theme.primary : Color.theme.secondaryText)
            
            Button {
                onPress?(false)
            } label: {
                Image(systemName: "figure.walk.circle.fill")
            }
            .disabled(!headingAvailable)
            .tint(!isMapView ? Color.theme.primary : Color.theme.secondaryText)
        }
    }
}
//
//struct LocatingToolbarView_Previews: PreviewProvider {
//    static var previews: some ToolbarContent {
//        LocatingToolbarView()
//    }
//}
