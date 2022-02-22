//
//  HomeViewModelTest.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 22/02/2022.
//

import XCTest
@testable import Parking_Compass
import CoreLocation

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then

@MainActor class HomeViewModelTest: XCTestCase {
    
    typealias HomeViewModel = HomeView.HomeViewModel
    
    override func setUp() {
        super.setUp()
    }
    
    func test_HomeViewModel_save_shouldSetSavedLocation() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let vm = HomeViewModel(locatingStatusService: mockLocatingStatusService)
        
        // When
        vm.save()
        
        // Then
        XCTAssertNotNil(vm.savedLocation)
    }
    
    func test_HomeViewModel_save_shouldSetSavedLocationAndLocatingStatusWillBeUpdated() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let vm = HomeViewModel(locatingStatusService: mockLocatingStatusService)
        
        // When
        vm.save()
        
        // Then
        XCTAssertNotNil(vm.savedLocation)
        XCTAssertEqual(vm.locatingStatus, .saving)
    }
    
    func test_HomeViewModel_savedLocation_shouldSaveToFileManager() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let vm = HomeViewModel(locatingStatusService: mockLocatingStatusService)
        
        // When
        vm.save()
        let data = try? FileManager.decode(Data.self, from: .savedLocationKey)
        
        // Then
        XCTAssertNotNil(vm.savedLocation)
        XCTAssertEqual(vm.locatingStatus, .saving)
        XCTAssertNotNil(data)
    }
    
    func test_HomeViewModel_savedLocation_shouldBeSetWhenFileManagerHasLocalData() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let mockedSavedLocation = CLLocation(latitude: 55.213448, longitude: 20.608194)
        if let data = try? JSONEncoder().encode(mockedSavedLocation) {
            try? FileManager.encode(data, to: .savedLocationKey)
        }
        
        // When
        let vm = HomeViewModel(locatingStatusService: mockLocatingStatusService)
        
        // Then
        XCTAssertNotNil(vm.savedLocation)
    }
    
    func test_HomeViewModel_locate_shouldSetTagAndLocatingStatusWillBeUpdated() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let vm = HomeViewModel(locatingStatusService: mockLocatingStatusService)
        
        // When
        vm.locate()
        
        // Then
        XCTAssertNotNil(vm.tag)
        XCTAssertEqual(vm.locatingStatus, .locating)
    }
}
