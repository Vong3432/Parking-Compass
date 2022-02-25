//
//  Parking_CompassApp.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 31/01/2022.
//

import SwiftUI

@main
struct Parking_CompassApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
