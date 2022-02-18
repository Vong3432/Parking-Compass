//
//  PreviewProvider.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 31/01/2022.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {} // prevent other to init a new instance of this class
}
