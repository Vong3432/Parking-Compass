//
//  ActionButtonView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 11/02/2022.
//

import SwiftUI

struct ActionButtonView: View {
    private let gradient = LinearGradient(
        colors: [
            Color.theme.primary.opacity(0.5),
            Color.theme.primary.opacity(0.8),
            Color.theme.primary.opacity(1)
        ],
        startPoint: .trailing, endPoint: .leading)
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.0)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundStyle(gradient)
                .rotationEffect(Angle(degrees: 270))
                .frame(width: 200, height: 200)
                .opacity(1.0)
        }
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView()
    }
}
