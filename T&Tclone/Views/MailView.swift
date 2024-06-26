//
//  MailView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/23/23.
//

import Foundation
import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var trip: Trip
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, trip: trip)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        return context.coordinator.composeMail()
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        // Update view if needed
    }
}

