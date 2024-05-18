//
//  LoginView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 5/17/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authentication: AuthenticationManager

    var body: some View {
        VStack {
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        print("Authentication successful: \(authResults)")
                        authentication.updateAuthentication(true)
                    case .failure(let error):
                        print("Authentication failed: \(error.localizedDescription)")
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(width: 280, height: 50)
            .padding()

            Button("Skip Authentication") {
                authentication.updateAuthentication(true)
            }
            .padding()
            .cornerRadius(10)
        }
    }
}

