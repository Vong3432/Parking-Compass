//
//  ContentView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 31/01/2022.
//

import SwiftUI

enum MenuItem {
    case PARKING, PROFILE, FAVOURITES
}

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        TabView {
            NavigationView {
                HomeView(locatingStatusService: appState.locatingStatusService)
                    .navigationTitle("My Parking")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("My Parking", systemImage: "parkingsign.circle.fill")
            }
            NavigationView {
                FavouriteView()
                    .navigationTitle("Favourites")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "star.fill")
                Label("Favourites", systemImage: "parkingsign.circle.fill")
            }
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "person.fill")
                Label("Profile", systemImage: "parkingsign.circle.fill")
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .accentColor(Color.theme.primary)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
