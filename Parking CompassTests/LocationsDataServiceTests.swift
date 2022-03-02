//
//  LocationsRepositoryTests.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import XCTest
@testable import Parking_Compass

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then
class LocationsRepositoryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    func test_LocationsRepository_save_failed() {
        // Given
        let repository = MockLocationsRepository()
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        let expectedError = LocationRepositoryError.failed
        var resultErrMsg: String?
        
        // When
        do {
            try repository.saveWithError(newLocation)
        } catch let error {
            resultErrMsg = error.localizedDescription
        }
        
        // Then
        XCTAssertNotNil(resultErrMsg)
        XCTAssertEqual(resultErrMsg, expectedError.localizedDescription)
    }
    
    func test_LocationsRepository_save_success() {
        // Given
        let repository = MockLocationsRepository()
        var locations = MockLocationsRepository.fakedLocations
        let locationsCount = locations.count
        
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        
        // When
        try? repository.save(newLocation)
        
        // Then
        XCTAssertTrue(locations.count == locationsCount + 1) // did appended
    }
    
    func test_LocationsRepository_update_failed() {
        // Given
        let repository = MockLocationsRepository()
        let oldLocation = MockLocationsRepository.fakedLocations[0]
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        
        let expectedError = LocationRepositoryError.failed
        var resultErr: LocationRepositoryError?
        
        // When
        repository.updateWithError(id: oldLocation.id, with: newLocation, { result in
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                resultErr = error
            }
        })
        
        // Then
        XCTAssertNotNil(resultErr)
        XCTAssertEqual(resultErr, expectedError)
    }
    
    func test_LocationsRepository_update_success() {
        // Given
        let repository = MockLocationsRepository()
        let oldLocation = MockLocationsRepository.fakedLocations[0]
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        
        let expectedError = LocationRepositoryError.failed
        var resultErr: LocationRepositoryError?
        
        // When
        repository.update(id: oldLocation.id, with: newLocation, { result in
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                resultErr = error
            }
        })
        
        // Then
        XCTAssertNotNil(resultErr)
        XCTAssertEqual(resultErr, expectedError)
    }
    
}
