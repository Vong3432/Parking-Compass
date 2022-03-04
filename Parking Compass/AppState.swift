//
//  AppState.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 10/02/2022.
//

import Foundation

class AppState: ObservableObject {
    @Published var locatingStatusService: LocatingStatusServiceProtocol
//    var dataRepository = FirebaseLocationsRepository()
    var authService = FirebaseAuthService()
    
    init() {
        locatingStatusService = LocatingStatusService(locationManager: LocationManager(), dataRepository: FirebaseLocationsRepository())
    }
}
