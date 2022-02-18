//
//  String.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 18/02/2022.
//

import Foundation

extension String {
    
    public static var savedLocationKey: String {
        "SavedLocation"
    }
    
    public var isNotEmpty: Bool {
        !self.isEmpty
    }
}
