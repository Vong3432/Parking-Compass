//
//  AppState.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 10/02/2022.
//

import Foundation

@MainActor class AppState: ObservableObject {
    @Published var locatingStatusService = LocatingStatusService(locationManager: LocationManager())
    var authService = FirebaseAuthService()
}
