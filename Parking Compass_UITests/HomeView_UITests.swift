//
//  HomeView_UITests.swift
//  Parking Compass_UITests
//
//  Created by Vong Nyuksoon on 25/02/2022.
//

import XCTest
import Parking_Compass

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class HomeView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.resetAuthorizationStatus(for: .location)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func test_HomeView_currentLocationButton_shouldSaveLocation() {
                
        // Given
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Allow “Parking Compass” to use your location?") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
//            for i in 0..<alert.buttons.count - 1 {
//                let buttonElement = alert.buttons.element(boundBy: i)
//                print("Button Label: \(buttonElement.label)")
//            }
            return true
        }
        
        // Performing an arbitrary action in the Maps app
        // This action will get blocked by the permission alert, triggering our UI Interruption Monitor
        app.swipeUp()
        // Remove the UI Interruption Monitor
        self.removeUIInterruptionMonitor(locationDialogMonitor)
        
        // When
        let clLocationButton = app.otherElements["CLLocationButton"]
        clLocationButton.tap()
        
        let backToVehicle = app.staticTexts["BackToVehicle"]
        let expectation = self.expectation(description: "Get address and show Back to vehicle button")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        
        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(backToVehicle.exists)
    }
    
    func test_HomeView_backToVehicle_shouldNavigateToDetailView() {
        
        // Given
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Allow “Parking Compass” to use your location?") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
//            for i in 0..<alert.buttons.count - 1 {
//                let buttonElement = alert.buttons.element(boundBy: i)
//                print("Button Label: \(buttonElement.label)")
//            }
            return true
        }
        
        // Performing an arbitrary action in the Maps app
        // This action will get blocked by the permission alert, triggering our UI Interruption Monitor
        app.swipeUp()
        // Remove the UI Interruption Monitor
        self.removeUIInterruptionMonitor(locationDialogMonitor)
        let clLocationButton = app.otherElements["CLLocationButton"]
        clLocationButton.tap()
        
        // When
        let backToVehicle = app.staticTexts["BackToVehicle"]
        let expectation = self.expectation(description: "Get address and show Back to vehicle button")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
        backToVehicle.tap()
        
        let detailsView = app.staticTexts["LocatingDetailsView"]
        
        // Then
        XCTAssertTrue(detailsView.exists)
    }
    
}
