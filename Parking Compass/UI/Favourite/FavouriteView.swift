//
//  FavouriteView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import SwiftUI

struct FavouriteView: View {
    
    @StateObject private var vm: FavouriteViewModel
    let showLoginSheet: () -> Void
    
    init(
        locatingStatusService: LocatingStatusServiceProtocol,
        authService: AuthServiceProtocol,
        showLoginSheet: @escaping () -> Void) {
            _vm = StateObject(wrappedValue: FavouriteViewModel(
                locatingStatusService: locatingStatusService,
                authService: authService))
        self.showLoginSheet = showLoginSheet
    }
    
    var body: some View {
        if vm.isGuest {
            guestFavoriteView
        } else {
            userFavoriteView
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavouriteView(
                locatingStatusService: LocatingStatusService(locationManager: LocationManager(), dataRepository: FirebaseLocationsRepository()),
                authService: FirebaseAuthService(),
                showLoginSheet: {}
            )
                .navigationTitle("Favourites")
        }
    }
}

extension FavouriteView {
    private var guestFavoriteView: some View {
        ZStack(alignment: .center) {
            
            VStack {
                Spacer()
                Image("Favourite")
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                
                Text("Ops! You are not signed in yet ...")
                    .font(.body)
                    .foregroundColor(Color.theme.secondaryText)
                
                Spacer()
                
                Button { showLoginSheet() } label: {
                    Text("Sign In")
                        .font(.headline)
                        .padding()
                        .padding(.horizontal)
                }
                .foregroundColor(.white)
                .background(Color.theme.primary)
                .clipShape(Capsule())
                .accessibilityIdentifier("SignInButton")
                
                Spacer()
                
            }
            
        }
    }
    
    private var userFavoriteView: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(vm.locations) { location in
                        NavigationLink {
                            LocatingDetailsView(
                                parkingLocation: location.toCLLocation,
                                locatingStatusService: vm.locatingStatusService,
                                shouldShowClearBtn: false
                            )
                        } label: {
                            ParkingLocationRow(location: location)
                        }.buttonStyle(.plain)
                    }
                }
            }.padding()
        }
    }
}
