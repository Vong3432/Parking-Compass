//
//  LocatingDetailsViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 18/02/2022.
//

import Foundation
import MapKit
import SwiftUI
import Combine

extension LocatingDetailsView {
    @MainActor class LocatingDetailsViewModel: ObservableObject {
//        @Published var region: MKCoordinateRegion
//        @Published var userTrackingMode: MapUserTrackingMode = .follow
//        @Published var places = [Location]()
        @Published private(set) var userLocation: CLLocation = CLLocation()
        @Published private(set) var address = ""
        
        private var locatingStatusService: LocatingStatusServiceProtocol
        
        private var cancellable = Set<AnyCancellable>()
        
        init(parkingLocation: CLLocation, locatingStatusService: LocatingStatusServiceProtocol) {
            self.locatingStatusService = locatingStatusService
            self.locatingStatusService.startUpdating()
            subscribeToLocatingStatusService()
        }
        
        private func subscribeToLocatingStatusService() {
            locatingStatusService.currentLocationPublisher
                .sink { [weak self] location in
                    guard let location = location else { return }
                    self?.userLocation = location
                    
                    location.getAddress { address, error in
                        guard let address = address else {
                            return
                        }
                        self?.address = address
                    }
                }
                .store(in: &cancellable)
        }
        
        func stopSubscribing() {
            locatingStatusService.stopUpdating()
            locatingStatusService.clearLocation()
        }
        
    }
}
