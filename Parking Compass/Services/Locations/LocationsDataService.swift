//
//  LocationsDataService.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import Foundation
import Combine

final class LocationDataService: ObservableObject {
    
    @Published var locations = [Location]()
    @Published var errorMsg: LocationRepositoryError?
    
    private var dataService: LocationsRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dataRepository: LocationsRepositoryProtocol) {
        dataService = dataRepository
    }
    
    func save(_ location: Location) {
        dataService.save(location) { [weak self] result in
            switch result {
            case .success(let location):
                self?.locations.append(location)
            case .failure(let error):
                self?.errorMsg = error
            }
        }
    }
    
    func update(id: UUID, with location: Location) {
        dataService.update(id: id, with: location) { [weak self] result in
            switch result {
            case .success(let location):
                let index = self?.locations.firstIndex { $0.id == id }
                guard let index = index else {
                    return
                }
                
                self?.locations[index] = location
            case .failure(let error):
                self?.errorMsg = error
            }
        }
    }
    
    func delete(id: UUID) {
        dataService.delete(id: id) { [weak self] result in
            switch result {
            case .success(_):
                let index = self?.locations.firstIndex { $0.id == id }
                guard let index = index else {
                    return
                }
                self?.locations.remove(at: index)
            case .failure(let error):
                self?.errorMsg = error
            }
        }
    }
    
    func get(id: UUID) -> Location? {
        var currentLocation: Location?
        
        dataService.get(id: id) { [weak self] result in
            switch result {
            case .success(let location):
                currentLocation = location
            case .failure(let error):
                self?.errorMsg = error
            }
        }
        
        return currentLocation
    }
    
    /// Fetch, and observe database changes if provided.
    /// - Description: Fetch locations from remote database by default.
    ///
    /// For third-party databases that has observer mechanism, every time changes are made to remote database will be retrieved and **should** assign to locations directly without re-calling this function.
    ///
    /// For normal database, this function **can** be re-called multiple times.
    func getAll() {
        // initial fetch
        dataService.getAll()
        
        // subscribe to changes from dataService
        dataService.locationsPublisher
            .sink { [weak self] returnedLocations in
                self?.locations = returnedLocations
            }
            .store(in: &cancellables)
    }
}
