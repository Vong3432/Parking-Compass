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
    
    @State private var showingSignInSheet = false
    
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
                FavouriteView(
                    locatingStatusService: appState.locatingStatusService,
                    authService: appState.authService,
                    showLoginSheet: showSignInSheet)
                    .navigationTitle("Favourites")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Favourites", systemImage: "parkingsign.circle.fill")
                    .accessibilityIdentifier("FavouriteTabBarItem")
            }
            NavigationView {
                ProfileView(
                    authService: appState.authService,
                    showLoginSheet: showSignInSheet
                )
                    .navigationTitle("Profile")
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingSignInSheet) {
            if appState.authService.user != nil { }
            else {
                SignInView(authService: appState.authService)
            }
        }
        .accentColor(Color.theme.primary)
    }
    
    private func showSignInSheet() {
        showingSignInSheet.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
