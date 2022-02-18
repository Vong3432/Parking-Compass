//
//  Location.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 11/02/2022.
//

import Foundation
import CoreLocation

struct Location: Codable, Identifiable {
    var id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
