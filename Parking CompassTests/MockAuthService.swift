//
//  MockAuthService.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 28/02/2022.
//
@testable import Parking_Compass
import Foundation

final class MockAuthService: AuthServiceProtocol {
    @Published var user: User? = nil
    var userPublisher: Published<User?> { _user }
    var userPublished: Published<User?>.Publisher { $user }
    
    static let fakedUser = User(uniqueId: "abc", email: "abc", username: "John")
    
    func login(_ email: String, _ password: String, handler: (Result<User, AuthError>) -> Void) {
        user = MockAuthService.fakedUser
        handler(.success(MockAuthService.fakedUser))
    }
    
    func loginWithError(_ email: String, _ password: String, handler: (Result<User, AuthError>) -> Void) {
        handler(.failure(.incorrect))
    }
    
    func register(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void) {
        user = MockAuthService.fakedUser
        handler(.success(MockAuthService.fakedUser))
    }
    
    func registerWithError(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void) {
        handler(.failure(.registered))
    }
    
    func logout() {
        user = nil
    }
    
}
