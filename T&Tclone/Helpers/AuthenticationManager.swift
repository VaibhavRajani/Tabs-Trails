//
//  AuthenticationManager.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 5/17/24.
//

import Foundation
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false

    func updateAuthentication(_ isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
}
