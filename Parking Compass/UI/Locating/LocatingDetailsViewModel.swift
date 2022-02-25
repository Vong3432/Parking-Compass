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
        
        @Published private(set) var isMapView = true // default must true, otherwise will show compassView for devices that don't support heading
        @Published private(set) var userLocation: CLLocation = CLLocation()
        @Published private(set) var address = ""
        @Published private(set) var distance: Double?
        @Published private(set) var parkingLocation: CLLocation
        @Published private(set) var degrees = Angle.zero
        @Published private(set) var heading: CLHeading?
        @Published private(set) var headingAvailable = false
        
        private var locatingStatusService: LocatingStatusServiceProtocol
        
        private var cancellable = Set<AnyCancellable>()
        
        init(parkingLocation: CLLocation, locatingStatusService: LocatingStatusServiceProtocol) {
            self.parkingLocation = parkingLocation
            self.locatingStatusService = locatingStatusService
            self.locatingStatusService.startUpdating()
            self.headingAvailable = locatingStatusService.headingAvailable()
            
            if !isMapView { subscribeToHeading() }
            
            subscribeToLocatingStatusService()
        }
        
        func stopSubscribing() {
            if !isMapView { locatingStatusService.stopUpdatingHeading() }
            locatingStatusService.stopUpdating()
        }
        
        func clearSavedParkingLocation() {
            locatingStatusService.clearLocation()
        }
        
        func changeView(isMap value: Bool) {
            withAnimation(.spring()) {
                isMapView = value
            }
            
            if !value { subscribeToHeading() }
            else { locatingStatusService.stopUpdatingHeading() }
        }
        
        private func subscribeToHeading() {
            locatingStatusService.startUpdatingHeading()
            
            locatingStatusService.currentHeadingPublisher
                .sink { [weak self] newHeading in
                    guard let newHeading = newHeading, let self = self else { return }
                    self.heading = newHeading
                }
                .store(in: &cancellable)
        }
        
        private func subscribeToLocatingStatusService() {
            locatingStatusService.currentLocationPublisher
                .sink { [weak self] location in
                    guard let location = location, let self = self else { return }
                    self.userLocation = location
                    
                    if !self.isMapView {
                        print("Me:", location)
                        print("P:", self.parkingLocation)
                        //                        self.calculateUserAngle()
                        
                        if let heading = self.heading {
                            self.doComputeAngleBetweenMapPoints(
                                fromHeading: heading.trueHeading,
                                location,
                                self.parkingLocation
                            )
                        }
                        
                        self.calculateDistanceWithCoordinateAltitude(from: location, destination: self.parkingLocation)
                    }
                    
                    self.parkingLocation.getAddress { address, error in

                        guard let address = address else {
                            return
                        }
                        self.address = address
                    }
                }
                .store(in: &cancellable)
        }
        
        private func calculateDistanceWithCoordinateAltitude(from: CLLocation, destination: CLLocation) {
            
            /// Uncomment for testing
            //  let dummyDest = CLLocation(latitude: 1.492290, longitude: 103.584049)
            
            /// formula from online: https://www.b4x.com/android/forum/threads/distance-between-two-gps-points-with-altitude.72072/post-458380, same result with CLLocation's distance(:from)
            //            let distance = dummyDest.distance(from: from)
            //            let altitude = dummyDest.ellipsoidalAltitude - from.ellipsoidalAltitude
            //
            //            let computedDistance = sqrt(pow(distance, 2) + pow(altitude, 2))
            
            let distanceInKM = from.distance(from: destination) / 1000
            self.distance = distanceInKM
        }
        
        /// Reference: https://stackoverflow.com/a/64809271/10868150
        private func doComputeAngleBetweenMapPoints(
            fromHeading: CLLocationDirection,
            _ fromPoint: CLLocation,
            _ toPoint: CLLocation
        ) {
            let from =  fromPoint.coordinate // some CLLocationCoordinate2D
            let to = toPoint.coordinate // some CLLocationCoordinate2D
            
            let deltaL = to.longitude.toRadians - from.longitude.toRadians
            let thetaFrom = to.latitude.toRadians
            let thetaTo = from.latitude.toRadians
            let x = cos(thetaFrom) * sin(thetaTo)
            let y = cos(thetaTo) * sin(thetaFrom) - sin(thetaTo) * cos(thetaFrom) * cos(deltaL)
            
            let bearing = atan2(x,y)
            let bearingInDegrees = bearing.toDegrees
            print(bearingInDegrees) // sanity check
            
            let bearingFromMe = bearingInDegrees - fromHeading
            
            self.degrees = Angle(degrees: bearingFromMe)
        }
        
    }
}
