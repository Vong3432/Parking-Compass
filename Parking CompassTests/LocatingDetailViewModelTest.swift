//
//  LocatingDetailViewModelTest.swift
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

@MainActor class LocatingDetailViewModelTest: XCTestCase {
    typealias LocatingDetailViewModel = LocatingDetailsView.LocatingDetailsViewModel

    override func setUp() {
        super.setUp()
    }
    
    func test_LocatingDetailViewModel_parkingLocation_shouldBeInjected() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation()
        
        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
        
        // Then
        XCTAssertEqual(vm.parkingLocation, parkingLocation)
    }
    
    func test_LocatingDetailViewModel_headingAvailable_shouldBeSetAutomatically() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation()
        
        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
        
        // Then
        XCTAssertEqual(vm.headingAvailable, locationManager.headingAvailable())
    }
    
    func test_LocatingDetailViewModel_clearSavedParkingLocation_shouldWorkInFileManager() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation()
        
        if let localSavedParkingLocation = try? JSONEncoder().encode(parkingLocation) {
            try? FileManager.encode(localSavedParkingLocation, to: .savedLocationKey)
        }
        
        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
        vm.clearSavedParkingLocation()
        
        let data = try? FileManager.decode(Data.self, from: .savedLocationKey)
        
        // Then
        XCTAssertNil(data)
    }
    
    // Not testing heading because Simulator does not support it and pointless
//    func test_LocatingDetailViewModel_heading_shouldBeSet() {
//        // Given
//        let locationManager = LocationManager()
//        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
//        let parkingLocation = CLLocation()
//
//        // When
//        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
//        vm.changeView(isMap: false)
//
//        // Then
//        XCTAssertNotNil(vm.heading)
//    }
    
    func test_LocatingDetailViewModel_isMapView_shouldBeSet_stress() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation()

        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)

        // Then
        for _ in 0...20 {
            let isMap = Bool.random()
            vm.changeView(isMap: isMap)
            
            XCTAssertEqual(vm.isMapView, isMap)
        }
    }
    
    func test_LocatingDetailViewModel_address_shouldBeCalculated() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation(latitude: 55.213448, longitude: 20.608194)

        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
        mockLocatingStatusService.requestLocation()

        let expectation = self.expectation(description: "TestAddress")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        // Then
        self.waitForExpectations(timeout: 4, handler: nil)
        XCTAssertTrue(vm.address.isNotEmpty)

    }
    
    func test_LocatingDetailViewModel_showingAlert_shouldBeUpdated() {
        // Given
        let locationManager = LocationManager()
        let mockLocatingStatusService = MockLocationStatusService(locationManager: locationManager)
        let parkingLocation = CLLocation(latitude: 55.213448, longitude: 20.608194)

        // When
        let vm = LocatingDetailViewModel(parkingLocation: parkingLocation, locatingStatusService: mockLocatingStatusService)
        
        let before = vm.showingAlert
        vm.showAlert()
        
        // Then
        XCTAssertNotEqual(vm.showingAlert, before)
    }
}
