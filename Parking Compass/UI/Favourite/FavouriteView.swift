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
    
    init(authService: AuthServiceProtocol, showLoginSheet: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: FavouriteViewModel(authService: authService))
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
            FavouriteView(authService: FirebaseAuthService(), showLoginSheet: {})
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
                    ForEach(0..<5) { _ in
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.cyan)
                                Text("123 Jalan Sutera Utama, 2/12 Sutera Utama")
                                    .font(.body)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.theme.background.opacity(0.7))
                        .cornerRadius(12)
                    }
                }
            }.padding()
        }
    }
}
