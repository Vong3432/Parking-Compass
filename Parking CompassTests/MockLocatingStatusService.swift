//
//  MockLocatingStatusService.swift
//  Parking CompassTests
//
//  Created by Vong Nyuksoon on 22/02/2022.
//
@testable import Parking_Compass
import Combine
import MapKit

final class MockLocationStatusService: LocatingStatusServiceProtocol {
    var dataService: LocationDataService
    
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
    internal var isHeadingAvailable = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.locationManager.requestPermission()
        self.dataService = LocationDataService(dataRepository: MockLocationsRepository())
        isHeadingAvailable = locationManager.headingAvailable()
    }
    
    func requestLocation() {
        self.currentLocation = CLLocation()
    }
    
    func startUpdatingHeading() {
        self.currentHeading = CLHeading()
    }
    
    func stopUpdatingHeading() {
        
    }
    
    func startUpdating() {
        
    }
    
    func stopUpdating() {
        
    }
    
    func clearLocation() {
        currentLocation = nil
        stopUpdating()
        stopUpdatingHeading()
        locatingStatus = .idle
        
        try? FileManager.default.removeItem(at: FileManager.getDocumentsDirectory().appendingPathComponent(.savedLocationKey))
    }
    
    func saveLocation() {
        locatingStatus = .saving
        requestLocation()
    }
    
    func locateLocation() {
        locatingStatus = .locating
    }
    
    func headingAvailable() -> Bool {
        isHeadingAvailable
    }
    
    func changeLocation(to location: CLLocation?) {
        currentLocation = location
    }
    
}
