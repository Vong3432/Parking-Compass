//
//  Button.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 31/01/2022.
//

import Foundation
import SwiftUI

extension View {
    func primaryButton() -> some View {
        modifier(ButtonModifier(color: Color.theme.primary))
    }
}

struct ButtonModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundStyle(.ultraThickMaterial)
            .cornerRadius(12)
    }
}
