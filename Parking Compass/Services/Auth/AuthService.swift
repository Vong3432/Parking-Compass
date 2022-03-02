//
//  AuthService.swift
//  Parking Compass
//
//  Created by Vong Nyuksoon on 28/02/2022.
//

import Foundation
import CommonCrypto

enum AuthError: LocalizedError {
    case incorrect, registered, invalidEmail, unknown
    
    var errorDescription: String? {
        switch self {
        case .incorrect:
            return "Incorrect info. Please try again."
        case .registered:
            return "This email is already registered."
        case .unknown:
            return "Something went wrong"
        case .invalidEmail:
            return "Invalid email"
        }
    }
}

protocol AuthServiceProtocol: AnyObject {
    var user: User? { get set }
    var userPublisher: Published<User?> { get }
    var userPublished: Published<User?>.Publisher { get }
    
    func login(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void ) -> Void
    func register(_ email: String, _ password: String, handler: @escaping (Result<User, AuthError>) -> Void ) -> Void
    
    func logout() -> Void
}

extension AuthServiceProtocol {
    var isAuthenticated: Bool {
        self.user != nil
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    //    @available(iOS 13, *)
    //    private func sha256(_ input: String) -> String {
    //        let inputData = Data(input.utf8)
    //        let hashedData = SHA256.hash(data: inputData)
    //        let hashString = hashedData.compactMap {
    //            String(format: "%02x", $0)
    //        }.joined()
    //
    //        return hashString
    //    }
    
}
