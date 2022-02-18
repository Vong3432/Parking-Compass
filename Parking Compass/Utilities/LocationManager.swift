//
//  LocationManager.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 11/02/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let locationManager: CLLocationManager
    
    @Published private(set) var lastLocation: CLLocation?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func getCurrentLocation() {
        self.locationManager.requestLocation()
    }
    
    func startUpdating() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        self.locationManager.stopUpdatingLocation()
    }
    
    // delegates
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus != .authorizedWhenInUse || authorizationStatus != .authorizedAlways {
            lastLocation = nil
            stopUpdating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("New location is \(location)")
            lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
