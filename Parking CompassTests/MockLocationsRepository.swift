//
//  MockLocationsRepository.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

@testable import Parking_Compass
import Foundation

final class MockLocationsRepository: LocationsRepositoryProtocol {
    @Published var locations = [Location]()
    var locationsPublished: Published<[Location]> { _locations }
    var locationsPublisher: Published<[Location]>.Publisher { $locations }
    
    static let fakedLocations = [Location(name: "JB", latitude: 123, longitude: 123), Location(name: "KL", latitude: 11.11, longitude: 11.11)]
    
    func save(_ location: Location, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        completion(.success(location))
    }
    
    func update(id: UUID, with: Location, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        completion(.success(with))
    }
    
    func delete(id: UUID, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        let deleted = MockLocationsRepository.fakedLocations.first { $0.id == id }
        completion(.success(deleted!))
    }
    
    func get(id: UUID, completion: (Result<Location?, LocationRepositoryError>) -> Void) {
        let result = MockLocationsRepository.fakedLocations.first { $0.id == id }
        completion(.success(result))
    }
    
    func getAll() {
        locations = locations + MockLocationsRepository.fakedLocations
    }
    
}

final class MockLocationsRepositoryError: LocationsRepositoryProtocol {

    @Published var locations = [Location]()
    var locationsPublished: Published<[Location]> { _locations }
    var locationsPublisher: Published<[Location]>.Publisher { $locations }
    
    static let fakedLocations = [Location(name: "JB", latitude: 123, longitude: 123), Location(name: "KL", latitude: 11.11, longitude: 11.11)]
    
    func save(_ location: Location, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        completion(.failure(.failed))
    }
    
    func update(id: UUID, with: Location, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        completion(.failure(.failed))
    }
    
    func delete(id: UUID, completion: (Result<Location, LocationRepositoryError>) -> Void) {
        completion(.failure(.failed))
    }
    
    func get(id: UUID, completion: (Result<Location?, LocationRepositoryError>) -> Void) {
        completion(.failure(.noResult))
    }
    
    func getAll() {
        
    }
    
}

