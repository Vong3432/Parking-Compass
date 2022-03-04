//
//  DatabaseSnapshot.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 04/03/2022.
//

import Foundation
import FirebaseDatabase

extension DataSnapshot {
    
    /// Transform every snapshot children to T type and return transformed list.
    static func mapChildren<T: Codable>(_ children: NSEnumerator) -> [T]? {
        guard let children = children.allObjects as? [DataSnapshot] else {
            return nil
        }
        
        let mapped = children.compactMap { snapshot in
            return try? snapshot.data(as: T.self)
        }
        
        return mapped
    }
}
