//
//  ProfileView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 07/02/2022.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var vm: ProfileViewModel
    let showLoginSheet: () -> Void
    
    init(authService: AuthServiceProtocol, showLoginSheet: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: ProfileViewModel(authService: authService))
        self.showLoginSheet = showLoginSheet
    }
    
    var body: some View {
        Group {
            if let user = vm.user {
                userProfileView
            } else {
                guestProfileView
            }
        }
        .toolbar {
            if let user = vm.user {
                CircularAvatarView(user: user)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(authService: FirebaseAuthService()) { }
            .navigationTitle("Profile")
        }
    }
}

extension ProfileView {
    private var guestProfileView: some View {
        ZStack(alignment: .center) {
            
            VStack {
                Spacer()
                Image("Profile")
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
                
                Spacer()
                
            }
            
        }
    }
    
    private var userProfileView: some View {
        List {
            Section("Personal") {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Button("Logout") { vm.logout() }
                }.tint(Color.theme.accent)
            }
        }
    }
}
