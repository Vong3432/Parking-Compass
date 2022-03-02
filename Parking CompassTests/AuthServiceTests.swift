//
//  AuthServiceTests.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import XCTest
@testable import Parking_Compass

// Naming structure: test_unitOfWork_stateUnderTest_expectedBehavior
// Naming structure: test_[struct/class]_[variable/function]_[expectedBehavior]
// Testing structure: Given, When, Then

class AuthServiceTests: XCTestCase {

    override class func setUp() {
        super.setUp()
    }
    
    func test_AuthService_login_fail() {
        //Given
        let authService = MockAuthService()
        let expectedError = AuthError.incorrect
        var resultErr: AuthError?
        
        // When
        authService.loginWithError("abc", "asd") { result in
            switch result {
            case .success(_):
                print("")
            case .failure(let error):
                resultErr = error
            }
        }
        
        // Then
        XCTAssertNotNil(resultErr)
        XCTAssertEqual(resultErr, expectedError)
    }
    
    func test_AuthService_login_success() {
        //Given
        let authService = MockAuthService()
        let expectedUser = MockAuthService.fakedUser
        
        // When
        authService.login("abc", "asd") { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(_):
                print("")
            }
        }
        
        // Then
        XCTAssertNotNil(authService.user)
        XCTAssertTrue(authService.user == expectedUser)
    }
    
    func test_AuthService_register_fail() {
        //Given
        let authService = MockAuthService()
        let expectedError = AuthError.registered
        var resultErr: AuthError?
        
        // When
        authService.registerWithError("abc", "asd") { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(let error):
                resultErr = error
            }
        }
        
        // Then
        XCTAssertNil(authService.user)
        XCTAssertNotNil(resultErr)
        XCTAssertEqual(resultErr, expectedError)
    }
    
    func test_AuthService_register_success() {
        //Given
        let authService = MockAuthService()
        let expectedUser = MockAuthService.fakedUser
        
        // When
        authService.register("abc", "asd") { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(_):
                print("")
            }
        }
        
        // Then
        XCTAssertNotNil(authService.user)
        XCTAssertEqual(expectedUser, authService.user)
    }
    
    func test_AuthService_logout_success() {
        //Given
        let authService = MockAuthService()
        let expectedUser = MockAuthService.fakedUser
        authService.register("abc", "asd") { result in
            switch result {
            case .success(_):
                print("success")
            case .failure(_):
                print("")
            }
        }
        
        XCTAssertNotNil(authService.user)
        XCTAssertEqual(expectedUser, authService.user)
        
        // When
        authService.logout()
        
        // Then
        XCTAssertNil(authService.user)
    }

}
