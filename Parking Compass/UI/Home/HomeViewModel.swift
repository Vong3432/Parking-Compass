//
//  HomeViewModel.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import Foundation
import SwiftUI
import Combine
import MapKit

extension HomeView {
    @MainActor class HomeViewModel: ObservableObject {
        
        //        @Published private(set) var isMapView = true
        @Published private(set) var showingAlert = false
        @Published private(set) var isLocationEnabled = false
        @Published private(set) var locatingStatus = LocatingStatus.idle
        
        @Published private(set) var savedLocation: CLLocation = CLLocation()
        @Published private(set) var currentAddress = ""
        @Published var tag: String? = nil
        
        var locatingStatusService: LocatingStatusServiceProtocol
        private var cancellable = Set<AnyCancellable>()
        
        init(locatingStatusService: LocatingStatusServiceProtocol) {
            self.locatingStatusService = locatingStatusService
            
            preset()
            subscribeLocatingStatus()
        }
        
        private func subscribeLocatingStatus() {
            
            locatingStatusService.currentLocationPublisher
                .combineLatest(locatingStatusService.isLocationEnabledPublisher, locatingStatusService.locatingStatusPublisher)
                .sink { [weak self] (location, isLocationEnabled, locatingStatus) in
                    
                    guard let self = self else { return }
                    
                    self.isLocationEnabled = isLocationEnabled
                    self.locatingStatus = locatingStatus
                    print(locatingStatus)
                    
                    
                    if locatingStatus == .locating {
                        self.tag = "Details"
                    } else if locatingStatus == .saving {
                        guard let location = location else {
                            return
                        }
                        
                        self.savedLocation = location
                        
                        if let data = try? JSONEncoder().encode(location) {
                            UserDefaults.standard.set(data, forKey: .savedLocationKey)
                        }
                        
                        self.getAddress(of: location)
                    } else if locatingStatus == .idle {
                        self.currentAddress = ""
                    }
                    
                }.store(in: &cancellable)
        }
        
        /// Ensure view model capture latest state from global service
        private func preset() {
            locatingStatus = locatingStatusService.locatingStatus
            
            if let data = UserDefaults.standard.data(forKey: .savedLocationKey) {
                if let customCLLocation = try? JSONDecoder().decode(CustomCLLocation.self, from: data) {
                    let clLocation = CLLocation(model: customCLLocation)
                    self.savedLocation = clLocation
                    self.getAddress(of: clLocation)
                }
            }
        }
        
        private func getAddress(of location: CLLocation) {
            location.getAddress { address, error in
                guard let address = address else {
                    return
                }
                self.currentAddress = address
            }
        }
        
        func save() {
            locatingStatusService.saveLocation()
        }
        
        func locate() {
            locatingStatusService.locateLocation()
        }
        
        //        func changeView(isMap value: Bool) {
        //            isMapView = value
        //        }
        
    }
}
