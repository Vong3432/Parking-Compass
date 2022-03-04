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
    
    static let mockLocations = [Location(name: "JB", latitude: 123, longitude: 123), Location(name: "KL", latitude: 11.11, longitude: 11.11)]

}
