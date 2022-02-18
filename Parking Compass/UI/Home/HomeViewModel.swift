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
        
        @Published private(set) var showingAlert = false
        @Published private(set) var isLocationEnabled = false
        @Published private(set) var locatingStatus = LocatingStatus.idle
        
        @Published private(set) var savedLocation: CLLocation?
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
                .sink { [weak self] in self?.update($0, $1, $2) }
                .store(in: &cancellable)
        }
        
        
        /// Ensure view model capture latest state from global service
        private func preset() {
            locatingStatus = locatingStatusService.locatingStatus
            
            // load local data
            if let data = UserDefaults.standard.data(forKey: .savedLocationKey) {
                do {
                    let customCLLocation = try JSONDecoder().decode(CustomCLLocation.self, from: data)
                    print("OK")
                    let clLocation = CLLocation(model: customCLLocation)
                    self.savedLocation = clLocation
                    self.setCurrentAddress(of: clLocation)
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        private func update(
            _ location: Published<CLLocation?>.Publisher.Output,
            _ isLocationEnabled: Published<Bool>.Publisher.Output,
            _ locatingStatus: Published<LocatingStatus>.Publisher.Output
        ) {
            self.isLocationEnabled = isLocationEnabled
            self.locatingStatus = locatingStatus
            
            switch locatingStatus {
            case .idle:
                self.currentAddress = ""
                print("idle")
            case .saving:
                print("saving stat")
                guard let location = location else {
                    return
                }
                
                self.savedLocation = location
                self.setCurrentAddress(of: location)
                
                if let data = try? JSONEncoder().encode(location) {
                    UserDefaults.standard.set(data, forKey: .savedLocationKey)
                }
                
                print("saving end")
            case .locating:
                self.tag = "Details"
                print("locating")
            }
        }
        
        private func setCurrentAddress(of location: CLLocation) {
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
    }
}
