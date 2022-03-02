//
//  User.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID = UUID()
    let uniqueId: String
    let email: String?
    let username: String?
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uniqueId == rhs.uniqueId && lhs.email == rhs.email && lhs.username == rhs.username
    }
}
