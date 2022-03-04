//
//  FirebaseDatabaseManager.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 03/03/2022.
//

import Foundation
import FirebaseDatabase

// - source: https://github.com/oguzparlak/FirebaseWrapper/blob/main/Firebase/Database/FirebaseDatabaseManager.swift
final class FirebaseDatabaseManager {
    
    static let shared = FirebaseDatabaseManager()
    
    let ref = Database.database().reference()
    
    private init() { }
    
    func write<T: Codable>(
        _ data: T,
        path: String,
        createAutoKey: Bool = false,
        completion: ((Result<T, Error>) -> Void)? = nil
    ) {
        
        var encodedData: Any?
        
        if let value = data.dictionary {
            encodedData = value
        }
        
        if let value = data.array {
            encodedData = value
        }
        
        guard let encodedData = encodedData else {
            completion?(.failure(FirebaseError.encodingError))
            return
        }
        
        var childRef = ref.child(path)
        
        if createAutoKey { childRef = childRef.childByAutoId() }
        
        childRef.setValue(encodedData) { error, _ in
            if let error = error { completion?(.failure(error)) }
            completion?(.success(data))
        }
    }
    
    func getDataOnce(path: String, completion: @escaping (Result<DataSnapshot, Error>) -> Void) {
        ref.child(path).observeSingleEvent(of: .value) { snapshot in
            completion(.success(snapshot))
        } withCancel: { error in
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }
}
