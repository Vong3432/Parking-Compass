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
    @Published private(set) var heading: CLHeading?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func headingAvailable() -> Bool {
        return CLLocationManager.headingAvailable()
    }
    
    func requestPermission() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func changeAccuracy(to accuracy: CLLocationAccuracy) {
        locationManager.desiredAccuracy = accuracy
    }
    
    func getCurrentLocation() {
        changeAccuracy(to: kCLLocationAccuracyNearestTenMeters)
        self.locationManager.requestLocation()
    }
    
    func startUpdatingHeading() {
        self.locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingHeading() {
        self.locationManager.stopUpdatingHeading()
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
        
        guard let location = locations.first else { return }
        
        if lastLocation == nil { return lastLocation = location }
        else {
            /// https://stackoverflow.com/a/24876562/10868150
            let computedDistance = location.distance(from: lastLocation!)
            
            // over 70m will be useless to compare with horizontalAccuracy
            guard computedDistance < 70 else { return lastLocation = location}
            
            if computedDistance >= location.horizontalAccuracy * 0.05 {
                // update if it is over
                lastLocation = location
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("New heading is \(newHeading)")
        heading = newHeading
    }
}
