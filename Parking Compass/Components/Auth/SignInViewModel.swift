//
//  SignInViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation

extension SignInView {
    class SignInViewModel: ObservableObject {
        @Published var email: String = "abc"
        @Published var password: String = "abc"
        @Published var errorMsg: String?
        
        @Published var showingSignInButton = false
        @Published var showingSignInForm = true
        
        private var authService: AuthServiceProtocol
        
        init(authService: AuthServiceProtocol) {
            self.authService = authService
        }
        
        func changeView(_ isSignInView: Bool) {
            showingSignInForm = isSignInView
            clearError()
        }
        
        /// - Description: Function for Sign In/Sign Up button
        func signInButtonTapped(handler: @escaping (Result<User, AuthError>) -> Void) {
            if showingSignInForm {
                authService.login(email, password) { [weak self] result in
                    switch result {
                    case.success(let user):
                        handler(.success(user))
                    case .failure(let error):
                        self?.errorMsg = error.localizedDescription
                        handler(.failure(error))
                    }
                }
            } else {
                authService.register(email, password) { [weak self] result in
                    switch result {
                    case.success(let user):
                        handler(.success(user))
                    case .failure(let error):
                        self?.errorMsg = error.localizedDescription
                        handler(.failure(error))
                    }
                }
            }

        }
        
        func clearError() {
            guard errorMsg != nil else {
                return
            }
            errorMsg = nil
        }
    }
}
