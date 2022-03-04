//
//  FirebaseLocationEndPoint.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 03/03/2022.
//

import Foundation

protocol FirebaseEndPointProtocol {
    var path: String { get }
}

enum FirebaseError: LocalizedError {
    case encodingError
    
    var errorDescription: String {
        switch self {
        case .encodingError:
            return "Fail to encode for firebase"
        }
    }
}


// schema: "parking-locations" + "users"
enum FirebaseLocationHistory: FirebaseEndPointProtocol {
    case saveHistory(userId: String, locationId: String)
    case getHistories(userId: String)
    
    var path: String {
        switch self {
        case .saveHistory(let userId, let locationId):
            return "user_parkinglocations/\(userId)/locations/\(locationId)"
        case .getHistories(let userId):
            return "user_parkinglocations/\(userId)"
        }
    }
}

// schema: "parking-locations"
enum FirebaseLocationsEndPoint: FirebaseEndPointProtocol {
    case getAllParking(uid: String)
    case saveParking(uid: String)
    case getParking(id: String)
    
    var path: String {
        switch self {
        case .getAllParking(let uid), .saveParking(let uid):
            return "parking-locations/\(uid)"
        case .getParking(let id):
            return "parking-locations/\(id)"
        }
    }
}

// schema: "users"
enum FirebaseUsersEndPoint: FirebaseEndPointProtocol {
    case saveUser(id: String)
    case getUser(id: String)
    
    var path: String {
        switch self {
        case .getUser(let id), .saveUser(let id):
            return "users/\(id)"
        }
    }
}

