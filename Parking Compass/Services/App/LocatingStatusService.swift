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
    
    var currentHeading: CLHeading? { get }
    var currentHeadingPublished: Published<CLHeading?> { get }
    var currentHeadingPublisher: Published<CLHeading?>.Publisher { get }
    
    var isLocationEnabled: Bool { get }
    var isLocationEnabledPublished: Published<Bool> { get }
    var isLocationEnabledPublisher: Published<Bool>.Publisher { get }
    
    var locationManager: LocationManager { get }
    var isHeadingAvailable: Bool { get }
    
    func requestLocation() -> Void
    func startUpdatingHeading() -> Void
    func stopUpdatingHeading() -> Void
    func startUpdating() -> Void
    func stopUpdating() -> Void
    func clearLocation() -> Void
    //    func changeLocation(to location: CLLocation?) -> Void
    func saveLocation() -> Void
    func locateLocation() -> Void
    
    func headingAvailable() -> Bool
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
    
    @Published private(set) var currentHeading: CLHeading?
    var currentHeadingPublished: Published<CLHeading?> { _currentHeading }
    var currentHeadingPublisher: Published<CLHeading?>.Publisher { $currentHeading }
    
    @Published private(set) var isLocationEnabled: Bool = false
    var isLocationEnabledPublished: Published<Bool> { _isLocationEnabled }
    var isLocationEnabledPublisher: Published<Bool>.Publisher { $isLocationEnabled }
    
    internal var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    internal var isHeadingAvailable = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager.requestPermission()
        isHeadingAvailable = locationManager.headingAvailable()
        
        subscribeLocationManager()
    }
    
    func headingAvailable() -> Bool {
        isHeadingAvailable
    }
    
    func subscribeLocationManager() {
        // location
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
    
    func startUpdatingHeading() {
        locationManager.startUpdatingHeading()
        
        // heading
        locationManager.$heading
            .sink { [weak self] (newHeading) in
                guard let newHeading = newHeading else { return }
                
                self?.currentHeading = newHeading
            }
            .store(in: &cancellables)
    }
    
    func stopUpdatingHeading() {
        locationManager.stopUpdatingHeading()
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
        stopUpdating()
        stopUpdatingHeading()
        locatingStatus = .idle
        
        try? FileManager.default.removeItem(at: FileManager.getDocumentsDirectory().appendingPathComponent(.savedLocationKey))
        //        print("Cleared:", UserDefaults.standard.data(forKey: .savedLocationKey))
    }
    
    func saveLocation() {
        locatingStatus = .saving
        requestLocation()
    }
    
    func locateLocation() {
        locationManager.changeAccuracy(to: kCLLocationAccuracyBest)
        locatingStatus = .locating
    }
}




