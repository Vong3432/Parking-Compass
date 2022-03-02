//
//  FirebaseAuthService.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation
import FirebaseAuth

extension FirebaseAuthService {
    /// Convert Firebase Auth error to AuthError type.
    func handleErr(_ error: Error) -> AuthError {
        guard let error = error as NSError?,
              let errorCode = AuthErrorCode(rawValue: error.code) else {
                  print("there was an error logging in but it could not be matched with a firebase code")
                  return .unknown
              }
        
        switch errorCode {
        case .invalidEmail:
            return .invalidEmail
        case .userNotFound:
            fallthrough
        case .wrongPassword:
            return .incorrect
        case .emailAlreadyInUse:
            return .registered
        default:
            return .unknown
        }
    }
}

final class FirebaseAuthService: AuthServiceProtocol {
    @Published var user: User? = nil
    var userPublisher: Published<User?> { _user }
    var userPublished: Published<User?>.Publisher { $user }
    
    init() {
        let firebaseSignedUser = Auth.auth().currentUser
        if firebaseSignedUser != nil {
            self.user = User(uniqueId: firebaseSignedUser!.uid, email: firebaseSignedUser?.email, username: firebaseSignedUser?.displayName)
        }
    }
    
    func login(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            guard error == nil, let user = result?.user
            else {
                print("LOGIN ERROR: \(error?.localizedDescription ?? "")")
                let authErr = self.handleErr(error!)
                return handler(.failure(authErr))
            }
            
            let loggedInUser = User(uniqueId: user.uid, email: user.email, username: user.displayName)
            self.user = loggedInUser
            handler(.success(loggedInUser))
        }
    }
    
    func register(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            guard error == nil, let user = result?.user
            else {
                print("REGISTER ERROR: \(error?.localizedDescription ?? "")")
                let authErr = self.handleErr(error!)
                return handler(.failure(authErr))
            }
            
            let loggedInUser = User(uniqueId: user.uid, email: user.email, username: user.displayName)
            self.user = loggedInUser
            handler(.success(loggedInUser))
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            user = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}
