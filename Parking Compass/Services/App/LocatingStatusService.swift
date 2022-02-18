//
//  LocatingStatusService.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 10/02/2022.
//

import Foundation
import CoreLocation
import Combine

// - Tag: LocatingStatus
enum LocatingStatus {
    /// Description:
    /// - User is at the initial state
    ///
    case idle,
         
         /// Description:
         /// - User already saved their vehicle location before
         ///
         saving,
         
         /// Description:
         /// - User already saved their vehicle location before, and wants to going back to where they parked.
         locating
}

protocol LocatingStatusServiceProtocol {
    var locatingStatus: LocatingStatus { get }
    var locatingStatusPublished: Published<LocatingStatus> { get }
    var locatingStatusPublisher: Published<LocatingStatus>.Publisher { get }
    
    var currentLocation: CLLocation? { get }
    var currentLocationPublished: Published<CLLocation?> { get }
    var currentLocationPublisher: Published<CLLocation?>.Publisher { get }
    
    var isLocationEnabled: Bool { get }
    var isLocationEnabledPublished: Published<Bool> { get }
    var isLocationEnabledPublisher: Published<Bool>.Publisher { get }
    
    func requestLocation() -> Void
    func startUpdating() -> Void
    func stopUpdating() -> Void
    func clearLocation() -> Void
//    func changeLocation(to location: CLLocation?) -> Void
    func saveLocation() -> Void
    func locateLocation() -> Void
}

class LocatingStatusService: LocatingStatusServiceProtocol {
    /// Description:
    /// - Get current status of the button.
    ///
    @Published private(set) var locatingStatus = LocatingStatus.idle
    var locatingStatusPublished: Published<LocatingStatus> { _locatingStatus }
    var locatingStatusPublisher: Published<LocatingStatus>.Publisher { $locatingStatus }
    
    @Published private(set) var currentLocation: CLLocation?
    var currentLocationPublished: Published<CLLocation?> { _currentLocation }
    var currentLocationPublisher: Published<CLLocation?>.Publisher { $currentLocation }
    
    @Published private(set) var isLocationEnabled: Bool = false
    var isLocationEnabledPublished: Published<Bool> { _isLocationEnabled }
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    
    private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager.requestPermission()
        
        subscribeLocationManager()
    }
    
    func subscribeLocationManager() {
        locationManager.$lastLocation
            .combineLatest(locationManager.$authorizationStatus)
            .sink { [weak self] (location, status) in
                
                guard let self = self else { return }
                
                self.currentLocation = location
                
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    self.isLocationEnabled = true
                } else {
                    self.isLocationEnabled = false
                }
            }
            .store(in: &cancellables)
    }
    
    func startUpdating() -> Void {
        locationManager.startUpdating()
    }
    
    func stopUpdating() -> Void {
        locationManager.stopUpdating()
    }
    
    func requestLocation() -> Void {
        locationManager.getCurrentLocation()
    }
    
//    func changeLocation(to location: CLLocation? = nil) {
//        if location != nil {
//            self.currentLocation = location
//            return
//        }
//
//        if locationManager.authorizationStatus != .authorizedAlways || locationManager.authorizationStatus != .authorizedWhenInUse {
//            return
//        }
//        locationManager.getCurrentLocation()
//    }
    
    func clearLocation() {
        currentLocation = nil
        locationManager.stopUpdating()
        locatingStatus = .idle
        
        UserDefaults.standard.removeObject(forKey: .savedLocationKey)
    }
    
    func saveLocation() {
        locatingStatus = .saving
        requestLocation()
    }
    
    func locateLocation() {
        locatingStatus = .locating
    }
}




