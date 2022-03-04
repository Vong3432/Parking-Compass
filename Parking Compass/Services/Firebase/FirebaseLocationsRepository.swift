//
//  FirebaseLocationsRepository.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth
import FirebaseDatabaseSwift

final class FirebaseLocationsRepository: LocationsRepositoryProtocol {
    @Published var locations = [Location]()
    var locationsPublished: Published<[Location]> { _locations }
    var locationsPublisher: Published<[Location]>.Publisher { $locations }
    
    private var isAuthenticated = false
    private var cancellables = Set<AnyCancellable>()
    
    private let rootRef: DatabaseReference
    private let fdManager = FirebaseDatabaseManager.shared
    
    //    private let currentUser: _?
    private var currentUser: FirebaseAuth.User?
    
    init() {
        rootRef = fdManager.ref
        observeUserAuth()
    }
    
    deinit {
        print("Deinit")
    }
    
    private func observeUserAuth() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.currentUser = user
            self?.isAuthenticated = (user != nil)
        }
    }
    
    func save(_ location: Location, completion: @escaping (Result<Location, LocationRepositoryError>) -> Void) {
        guard isAuthenticated == true else { return completion(.failure(.notAuthenticated)) }
        
        fdManager.write(
            location,
            path: FirebaseLocationsEndPoint.saveParking(uid: currentUser!.uid).path,
            createAutoKey: true
        ) { result in
            
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
                return completion(.failure(.failed))
            }
        }
        
        fdManager.write(
            History(locationId: "\(location.id)"),
            path: FirebaseLocationHistory.saveHistory(userId: currentUser!.uid, locationId: "\(location.id)").path
        ) { result in
            switch result {
            case .success(_):
                completion(.success(location))
            case .failure(_):
                completion(.failure(.failed))
            }
        }
        
    }
    
    func update(id: UUID, with: Location, completion: @escaping (Result<Location, LocationRepositoryError>) -> Void) {
        guard isAuthenticated == true else { return completion(.failure(.notAuthenticated)) }
    }
    
    func delete(id: UUID, completion: @escaping (Result<Location, LocationRepositoryError>) -> Void) {
        guard isAuthenticated == true else { return completion(.failure(.notAuthenticated)) }
    }
    
    func get(id: UUID, completion: @escaping (Result<Location?, LocationRepositoryError>) -> Void) {
        guard isAuthenticated == true else { return completion(.failure(.notAuthenticated)) }
    }
    
    func getAll() {
        guard isAuthenticated == true else { return }
        
        rootRef.child(FirebaseLocationsEndPoint.getAllParking(uid: currentUser!.uid).path)
            .observe(.value) { [weak self] snapshot in
                self?.locations = DataSnapshot.mapChildren(snapshot.children) ?? []
            }
    }
    
    
    
}

