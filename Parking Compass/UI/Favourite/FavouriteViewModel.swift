//
//  FavouriteViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import Foundation
import Combine

extension FavouriteView {
    class FavouriteViewModel: ObservableObject {
        @Published var isGuest = true
        @Published var locations = [Location]()
        
        private let authService: AuthServiceProtocol
        let locatingStatusService: LocatingStatusServiceProtocol
        
        private var cancellable = Set<AnyCancellable>()
        
        init(locatingStatusService: LocatingStatusServiceProtocol, authService: AuthServiceProtocol) {
            self.locatingStatusService = locatingStatusService
            self.authService = authService
            
            subscribeToAuth()
            subscribeToData()
        }
        
        deinit {
            print("DEINIT")
        }
        
        private func subscribeToData() {
            locatingStatusService.dataService.$locations
                .sink { [weak self] returnedLocations in
                    self?.locations = returnedLocations
                }
                .store(in: &cancellable)
        }
        
        private func subscribeToAuth() {
            authService.userPublished
                .sink { [weak self] user in
                    self?.isGuest = (user == nil)
                    self?.fetchHistories()
                }
                .store(in: &cancellable)
        }
        
        private func fetchHistories() {
            locatingStatusService.dataService.getAll()
        }
    }
}
