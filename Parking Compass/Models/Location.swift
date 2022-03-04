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


extension Location: Equatable {
    static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    var toCLLocation: CLLocation {
        CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

