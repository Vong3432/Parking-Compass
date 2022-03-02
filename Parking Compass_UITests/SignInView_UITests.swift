//
//  SignInView_UITests.swift
//  Parking Compass_UITests
//
//  Created by Vong Nyuksoon on 03/03/2022.
//

import XCTest

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct]_[ui component]_[expectedBehavior]
// Testing structure: Given, When, Then
class SignInView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app.resetAuthorizationStatus(for: .location)
        XCUIDevice.shared.orientation = .portrait
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // set app to test env
        app.launchEnvironment = ["UITESTS":"1"]
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // Handler app permission
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
        
        // Navigate to Favourite view
        app.tabBars.buttons["FavouriteTabBarItem"].tap()
        
        // Should at favourite page
        XCTAssertTrue(app.navigationBars["Favourites"].exists)
        XCTAssertTrue(app.buttons["SignInButton"].exists)
        
        // open sheet
        app.buttons["SignInButton"].tap()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func test_SignInView_changeFormButton_shouldChangeForm_onTapped() {
        // Given
        let header = app.staticTexts["SignInTitle"]
        XCTAssertTrue(header.exists)
        
        // When
        let changeFormBtn = app.buttons["ChangeFormButton"]
        changeFormBtn.tap()
        
        // Then
        let signUpHeader = app.staticTexts["SignUpTitle"]
        XCTAssertTrue(signUpHeader.exists)
    }
    
    func test_SignInView_SignInUpButton_shouldNotExists_whenEmailOrPassIsEmpty() {
        // Given
        let header = app.staticTexts["SignInTitle"]
        XCTAssertTrue(header.exists)
        
        // When
        let emailField = app.textFields["EmailTextField"]
        emailField.doubleTap()
        app.keys["delete"].tap()
        emailField.typeText("\n")
        
        let passField = app.secureTextFields["PasswordField"]
        passField.doubleTap()
        app.keys["delete"].tap()
        passField.typeText("\n")
        
        
        // Then
        let signInOutBtn = app.buttons["SignInUpButton"]
        XCTAssertFalse(signInOutBtn.exists)
    }
    
    func test_SignInView_SignInUpButton_shouldExists_whenEmailAndPassIsNotEmpty() {
        // Given
        let header = app.staticTexts["SignInTitle"]
        XCTAssertTrue(header.exists)
        
        // When
        let emailField = app.textFields["EmailTextField"]
        emailField.doubleTap()
        app.keys["delete"].tap()
        emailField.typeText("testtest")
        emailField.typeText("\n")
        
        let passField = app.secureTextFields["PasswordField"]
        passField.doubleTap()
        app.keys["delete"].tap()
        passField.typeText("testtest")
        passField.typeText("\n")
        
        
        // Then
        let signInOutBtn = app.buttons["SignInUpButton"]
        XCTAssertTrue(signInOutBtn.exists)
    }
    
    func test_SignInView_ErrorMsgText_shouldExists_whenEmailAndPassIsIncorrect() {
        // Given
        let header = app.staticTexts["SignInTitle"]
        XCTAssertTrue(header.exists)
        
        // When
        let emailField = app.textFields["EmailTextField"]
        emailField.doubleTap()
        app.keys["delete"].tap()
        emailField.typeText("testtest")
        emailField.typeText("\n")
        
        let passField = app.secureTextFields["PasswordField"]
        passField.doubleTap()
        app.keys["delete"].tap()
        passField.typeText("\(Int.random(in: 0...123))")
        passField.typeText("\(Int.random(in: 0...321))")
        passField.typeText("\n")
        
        let signInOutBtn = app.buttons["SignInUpButton"]
        XCTAssertTrue(signInOutBtn.exists)
        signInOutBtn.tap()
        
        sleep(5)
        
        // Then
        let errorText = app.staticTexts["ErrorMsgText"]
        XCTAssertTrue(errorText.exists)
    }
    
}
