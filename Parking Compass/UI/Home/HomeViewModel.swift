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
    class HomeViewModel: ObservableObject {
        
        @Published private(set) var isLocationEnabled = false
        @Published private(set) var locatingStatus = LocatingStatus.idle
        
        @Published private(set) var savedLocation: CLLocation?
//        @Published private(set) var currentAddress = ""
        @Published var tag: String? = nil
        
        var locatingStatusService: LocatingStatusServiceProtocol
        
        private var cancellable = Set<AnyCancellable>()
        
        init(locatingStatusService: LocatingStatusServiceProtocol) {
            self.locatingStatusService = locatingStatusService
            
            subscribeLocatingStatus()
        }
        
        private func subscribeLocatingStatus() {
            locatingStatusService.currentLocationPublisher
                .combineLatest(locatingStatusService.isLocationEnabledPublisher, locatingStatusService.locatingStatusPublisher)
                .sink { [weak self] in self?.update($0, $1, $2) }
                .store(in: &cancellable)
        }
        
        
        /// Ensure view model capture latest state from global service
        func preset() {
            locatingStatus = locatingStatusService.locatingStatus
            
            // load local data
            if let data = try? FileManager.decode(Data.self, from: .savedLocationKey) {
                do {
                    let customCLLocation = try JSONDecoder().decode(CustomCLLocation.self, from: data)
                    let clLocation = CLLocation(model: customCLLocation)
                    self.savedLocation = clLocation
                    self.locatingStatus = .saving
//                    self.setCurrentAddress(of: clLocation)
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        private func update(
            _ location: Published<CLLocation?>.Publisher.Output,
            _ locationEnabled: Published<Bool>.Publisher.Output,
            _ status: Published<LocatingStatus>.Publisher.Output
        ) {
            isLocationEnabled = locationEnabled
            locatingStatus = status
            
            switch locatingStatus {
            case .idle:
//                self.currentAddress = ""
                savedLocation = nil
            case .saving:
                guard let location = location else {
                    return
                }

                savedLocation = location
                
                if let data = try? JSONEncoder().encode(location) {
                    try? FileManager.encode(data, to: .savedLocationKey)
                }
            case .locating:
                print("locating")
            }
        }
//        private func setCurrentAddress(of location: CLLocation) {
//            location.getAddress { address, error in
//                guard let address = address else {
//                    return
//                }
//                self.currentAddress = address
//            }
//        }
        
        func save() {
            locatingStatusService.saveLocation()
        }
        
        func locate() {
            locatingStatusService.locateLocation()
            tag = "Details"
        }
    }
}
