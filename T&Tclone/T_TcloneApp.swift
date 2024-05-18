//
//  T_TcloneApp.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/12/23.
//

import SwiftUI

@main
struct T_TcloneApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var authenticationManager = AuthenticationManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(authenticationManager)
        }
    }
}
