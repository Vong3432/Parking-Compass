//
//  LocationsRepository.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import Foundation

enum LocationRepositoryError: Error {
    case failed, noResult, notAuthenticated
}

protocol LocationsRepositoryProtocol: AnyObject {
    var locations: [Location] { get set }
    var locationsPublished: Published<[Location]> { get }
    var locationsPublisher: Published<[Location]>.Publisher { get }
    
    func save(_ location: Location, completion: @escaping (Result<Location, LocationRepositoryError>) -> Void)
    func update(id: UUID, with: Location, completion: @escaping(Result<Location, LocationRepositoryError>) -> Void)
    func delete(id: UUID, completion: @escaping (Result<Location, LocationRepositoryError>) -> Void)
    func get(id: UUID, completion: @escaping (Result<Location?, LocationRepositoryError>) -> Void)
    func getAll() -> Void
}
