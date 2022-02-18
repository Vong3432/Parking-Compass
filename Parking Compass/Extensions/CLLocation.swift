//
//  CLLocation.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 11/02/2022.
//

import Foundation
import CoreLocation

struct CustomCLLocation: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let altitude: CLLocationDistance
    let horizontalAccuracy: CLLocationAccuracy
    let verticalAccuracy: CLLocationAccuracy
    let speed: CLLocationSpeed
    let course: CLLocationDirection
    let timestamp: Date
}


extension CLLocation: Encodable {
    
    convenience init(model: CustomCLLocation) {
        self.init(coordinate: CLLocationCoordinate2DMake(model.latitude, model.longitude), altitude: model.altitude, horizontalAccuracy: model.horizontalAccuracy, verticalAccuracy: model.verticalAccuracy, course: model.course, speed: model.speed, timestamp: model.timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case speed
        case course
        case timestamp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    func getAddress(completion: @escaping (_ address: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) {
            let palcemark = $0?.first
            var address = ""
            if let subThoroughfare = palcemark?.subThoroughfare {
                address = address + subThoroughfare + ","
            }
            if let thoroughfare = palcemark?.thoroughfare {
                address = address + thoroughfare + ","
            }
            if let locality = palcemark?.locality {
                address = address + locality + ","
            }
            if let subLocality = palcemark?.subLocality {
                address = address + subLocality + ","
            }
            if let administrativeArea = palcemark?.administrativeArea {
                address = address + administrativeArea + ","
            }
            if let postalCode = palcemark?.postalCode {
                address = address + postalCode + ","
            }
            if let country = palcemark?.country {
                address = address + country + ","
            }
            if address.last == "," {
                address = String(address.dropLast())
            }
            completion(address,$1)
        }
    }
}

