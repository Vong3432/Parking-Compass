//
//  LocatingDetailView_UITests.swift
//  Parking Compass_UITests
//
//  Created by Vong Nyuksoon on 25/02/2022.
//

import XCTest

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class LocatingDetailView_UITests: XCTestCase {
    
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
    }
    
    func test_LocatingDetailView_clearButton_shouldNavigateBackToHome_whenClear() throws {
        // Given
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Allow “Parking Compass” to use your location?") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
        
        // Performing an arbitrary action in the Maps app
        // This action will get blocked by the permission alert, triggering our UI Interruption Monitor
        app.swipeUp()
        // Remove the UI Interruption Monitor
        self.removeUIInterruptionMonitor(locationDialogMonitor)
         
        let clLocationButton = app.otherElements["CLLocationButton"]
        clLocationButton.tap()
        
        let expectation = self.expectation(description: "Get address and show Back to vehicle button")
        
        let backToVehicle = app.staticTexts["BackToVehicle"]
        backToVehicle.tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
        let detailsView = app.staticTexts["LocatingDetailsView"]
        XCTAssertTrue(detailsView.exists)
        
        // When
        let clearButton = app.buttons["AlertClearBtn"]
        clearButton.tap()
        
        let button = app.buttons["AlertClearBtnConfirmed"]
        
        if button.waitForExistence(timeout: 6) {
            button.tap()
        }
        
//        app.swipeUp()
//        self.removeUIInterruptionMonitor(alertMonitor)

        sleep(5)
        
        let navBar = app.navigationBars["My Parking"]
        
        // Then
        XCTAssertTrue(navBar.exists)
        XCTAssertFalse(backToVehicle.exists)
    }
    
    func test_LocatingDetailView_clearButton_shouldNavigateBackToHome_withoutClearing() throws {
        // Given
        let locationDialogMonitor = addUIInterruptionMonitor(withDescription: "Allow “Parking Compass” to use your location?") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
        
        // Performing an arbitrary action in the Maps app
        // This action will get blocked by the permission alert, triggering our UI Interruption Monitor
        app.swipeUp()
        // Remove the UI Interruption Monitor
        self.removeUIInterruptionMonitor(locationDialogMonitor)
         
        let clLocationButton = app.otherElements["CLLocationButton"]
        clLocationButton.tap()
        
        let expectation = self.expectation(description: "Get address and show Back to vehicle button")
        
        let backToVehicle = app.staticTexts["BackToVehicle"]
        backToVehicle.tap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
        let detailsView = app.staticTexts["LocatingDetailsView"]
        XCTAssertTrue(detailsView.exists)
        
        // When
        let clearButton = app.buttons["AlertClearBtn"]
        clearButton.tap()
        
        let button = app.buttons["AlertClearBtnCancelled"]
        
        if button.waitForExistence(timeout: 6) {
            button.tap()
        }
        
//        app.swipeUp()
//        self.removeUIInterruptionMonitor(alertMonitor)

        sleep(5)
        
        app.navigationBars.buttons["My Parking"].tap()
        
        let navBar = app.navigationBars["My Parking"]
        
        // Then
        XCTAssertTrue(navBar.exists)
        XCTAssertTrue(backToVehicle.exists)
    }
    
}
