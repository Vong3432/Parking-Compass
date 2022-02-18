//
//  ActionButtonView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 31/01/2022.
//

import SwiftUI

struct AnimateActionButtonView: View {
    @State private var progress = 0.0
    @State private var opacity = 1.0
    
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
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: progress)
                .foregroundStyle(gradient)
                .rotationEffect(Angle(degrees: 270))
                .frame(width: 200, height: 200)
                .opacity(opacity)
                .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: opacity)
        }.onAppear {
            progress = 1.0
            opacity = 0.0
        }
    }
}

struct AnimateActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AnimateActionButtonView()
    }
}
