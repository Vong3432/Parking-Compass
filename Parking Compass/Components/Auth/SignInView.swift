//
//  SignInView.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 01/03/2022.
//

import SwiftUI

/// A Sign In/Sign Up form
struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm: SignInViewModel
    
    private var showSignInButton: Bool {
        vm.email.isNotEmpty && vm.password.isNotEmpty
    }
    
    init(authService: AuthServiceProtocol) {
        _vm = StateObject(wrappedValue: SignInViewModel(authService: authService))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.theme.primary
                .ignoresSafeArea()
            
            VStack {
                Image("Parking")
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * 0.35)
//                    .luminanceToAlpha()
                    .contrast(0.7)
                    .opacity(0.2)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        if vm.showingSignInForm {
                            Text("Sign In")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibilityIdentifier("SignInTitle")
                            Text("Login to your account and view your parking history.")
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.theme.secondaryText)
                        } else {
                            Text("Sign Up")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .accessibilityIdentifier("SignUpTitle")
                            Text("Create a new account to store and view your parking history.")
                                .font(.subheadline)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Section("Email") {
                            TextField(text: $vm.email, prompt: Text("Required")) {
                                Text("Email")
                            }
                            .accessibilityIdentifier("EmailTextField")
                        }
                        
                        Section("Password") {
                            SecureField(text: $vm.password, prompt: Text("Required")) {
                                Text("Password")
                            }
                            .accessibilityIdentifier("PasswordField")
                        }
                    }
                    .onChange(of: vm.email) { _ in vm.clearError() }
                    .onChange(of: vm.password) { _ in vm.clearError()}
                    
                    if let errorMsg = vm.errorMsg {
                        Text(errorMsg)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color.theme.red)
                            .accessibilityIdentifier("ErrorMsgText")
                    }
                    
                    if showSignInButton {
                        Button {
                            vm.signInButtonTapped { result in
                                guard (try? result.get()) != nil else { return }
                                
                                // success
                                dismiss()
                            }
                        } label: {
                            Text(vm.showingSignInForm ? "Sign In" : "Sign Up")
                                .padding(5)
                                .frame(maxWidth: .infinity)
                        }
                        .tint(Color.theme.primary)
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("SignInUpButton")
                    }
                    
                    Button(vm.showingSignInForm ? "I don't have an account" : "I have an account already") {
                        vm.changeView(!vm.showingSignInForm)
                    }.frame(maxWidth: .infinity)
                    .foregroundColor(Color.theme.primary)
                    .accessibilityIdentifier("ChangeFormButton")
                    
                    Spacer()
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                .padding(.vertical)
                .background(.white)
            }
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("asd")
        }.sheet(isPresented: .constant(true)) {
            SignInView(authService: FirebaseAuthService())
        }
    }
}
