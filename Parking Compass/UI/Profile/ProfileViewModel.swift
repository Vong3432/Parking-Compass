//
//  ProfileViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation
import Combine

extension ProfileView {
    @MainActor class ProfileViewModel: ObservableObject {
        @Published var user: User? = nil
        
        private let authService: AuthServiceProtocol
        private var cancellable = Set<AnyCancellable>()
        
        init(authService: AuthServiceProtocol) {
            self.authService = authService
            
            subscribeToAuth()
        }
        
        private func subscribeToAuth() {
            authService.userPublished
                .sink { [weak self] signedUser in
                    self?.user = signedUser
                }
                .store(in: &cancellable)
        }
        
        func logout() {
            authService.logout()
        }
    }
}
