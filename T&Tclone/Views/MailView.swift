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
    let subject: String
    let messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentationMode: PresentationMode

        init(presentationMode: Binding<PresentationMode>) {
            _presentationMode = presentationMode
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            $presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = context.coordinator
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: false)
        // Set the sender email if needed
        return mailVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

