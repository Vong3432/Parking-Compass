//
//  FavouriteViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation
import Combine

extension FavouriteView {
    @MainActor class FavouriteViewModel: ObservableObject {
        @Published var isGuest = true
        
        private let authService: AuthServiceProtocol
        private var cancellable = Set<AnyCancellable>()
        
        init(authService: AuthServiceProtocol) {
            self.authService = authService
            
            subscribeToAuth()
        }
        
        private func subscribeToAuth() {
            authService.userPublished
                .sink { [weak self] user in
                    self?.isGuest = (user == nil)
                }
                .store(in: &cancellable)
        }
    }
}
