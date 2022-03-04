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
class LocationsDataServiceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
    }
    
    func test_LocationsDataService_save_failed() {
        // Given
        let repository = MockLocationsRepositoryError()
        let dataService = LocationDataService(dataRepository: repository)
        let prevCount = dataService.locations.count
        
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        let expectedErr = LocationRepositoryError.failed
        
        // When
        dataService.save(newLocation)
        
        // Then
        XCTAssertEqual(expectedErr, dataService.errorMsg)
        XCTAssertNotNil(dataService.errorMsg)
        XCTAssertNotEqual(prevCount + 1, dataService.locations.count)
    }
    
    func test_LocationsDataService_save_success() {
        // Given
        let repository = MockLocationsRepository()
        let dataService = LocationDataService(dataRepository: repository)
        let prevCount = dataService.locations.count
        
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        
        // When
        dataService.save(newLocation)
        
        // Then
        XCTAssertNil(dataService.errorMsg)
        XCTAssertEqual(prevCount + 1, dataService.locations.count)
    }
    
    func test_LocationsDataService_update_failed() {
        // Given
        let repository = MockLocationsRepositoryError()
        let dataService = LocationDataService(dataRepository: repository)
        
        let newLocation = Location(name: "Sarawak", latitude: 12.12, longitude: 12.12)
        let updatedLocation = Location(name: "Sarawak", latitude: 22.22, longitude: 22.22)
        
        let expectedErr = LocationRepositoryError.failed
        
        // When
        dataService.update(id: newLocation.id, with: updatedLocation)
        
        // Then
        XCTAssertEqual(expectedErr, dataService.errorMsg)
        XCTAssertNotNil(dataService.errorMsg)
    }
    
    func test_LocationsDataService_update_success() {
        // Given
        let repository = MockLocationsRepository()
        let dataService = LocationDataService(dataRepository: repository)
        dataService.getAll()
        
        let updatedLocation = Location(name: "Sarawak", latitude: 22.22, longitude: 22.22)
        let expectedErr = LocationRepositoryError.failed
        
        let indexOfTargetElem = 0
        let targetElem = dataService.locations[indexOfTargetElem]
        
        // When
        dataService.update(id: targetElem.id, with: updatedLocation)
        
        // Then
        XCTAssertNotEqual(expectedErr, dataService.errorMsg)
        XCTAssertTrue(dataService.locations[indexOfTargetElem] == updatedLocation)
        XCTAssertNil(dataService.errorMsg)
    }
    
    func test_LocationsDataService_delete_failed() {
        // Given
        let repository = MockLocationsRepositoryError()
        let dataService = LocationDataService(dataRepository: repository)
        dataService.getAll()
        
        let deletedLocation = MockLocationsRepositoryError.fakedLocations[0]
        let expectedErr = LocationRepositoryError.failed
        
        // When
        dataService.delete(id: deletedLocation.id)
        
        // Then
        XCTAssertEqual(expectedErr, dataService.errorMsg)
        XCTAssertNotNil(dataService.errorMsg)
    }
    
    func test_LocationsDataService_delete_success() {
        // Given
        let repository = MockLocationsRepository()
        let dataService = LocationDataService(dataRepository: repository)
        dataService.getAll()
        
        let indexOfTargetElem = 0
        let deletedLocation = dataService.locations[indexOfTargetElem]
        let prevCount = dataService.locations.count
        
        let expectedErr = LocationRepositoryError.failed
        
        // When
        dataService.delete(id: deletedLocation.id)
        
        // Then
        XCTAssertNotEqual(expectedErr, dataService.errorMsg)
        XCTAssertNil(dataService.errorMsg)
        XCTAssertEqual(dataService.locations.count, prevCount - 1)
        XCTAssertNotEqual(dataService.locations[indexOfTargetElem], deletedLocation)
    }
    
    func test_LocationsDataService_get_failed() {
        // Given
        let repository = MockLocationsRepositoryError()
        let dataService = LocationDataService(dataRepository: repository)
        dataService.getAll()
        
        let targetLocation = MockLocationsRepositoryError.fakedLocations[0]
        var resultLocation: Location?
        
        let expectedErr = LocationRepositoryError.noResult
        
        // When
        resultLocation = dataService.get(id: targetLocation.id)
        
        // Then
        XCTAssertEqual(expectedErr, dataService.errorMsg)
        XCTAssertNotNil(dataService.errorMsg)
        XCTAssertNil(resultLocation)
    }
    
    func test_LocationsDataService_get_success() {
        // Given
        let repository = MockLocationsRepository()
        let dataService = LocationDataService(dataRepository: repository)
        dataService.getAll()
        
        let targetLocation = MockLocationsRepository.fakedLocations[0]
        var resultLocation: Location?
        
        let expectedErr = LocationRepositoryError.noResult
        
        // When
        resultLocation = dataService.get(id: targetLocation.id)
        
        // Then
        XCTAssertNotEqual(expectedErr, dataService.errorMsg)
        XCTAssertNil(dataService.errorMsg)
        XCTAssertNotNil(resultLocation)
    }
    
    func test_LocationsDataService_getAll_failed() {
        // Given
        let repository = MockLocationsRepositoryError()
        let dataService = LocationDataService(dataRepository: repository)
        
        // When
        dataService.getAll()
        
        // Then
        XCTAssertEqual(dataService.locations.count, 0)
    }
    
    func test_LocationsDataService_getAll_success() {
        // Given
        let repository = MockLocationsRepository()
        let dataService = LocationDataService(dataRepository: repository)
        let before = dataService.locations
        
        // When
        dataService.getAll()
        let after = dataService.locations
        
        // Then
        XCTAssertTrue(before.count != after.count)
    }
}
