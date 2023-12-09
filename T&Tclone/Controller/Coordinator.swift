//
//  Coordinator.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 12/8/23.
//

import Foundation
import SwiftUI
import MessageUI

class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    @Binding var presentationMode: PresentationMode
    var trip: Trip

    init(presentationMode: Binding<PresentationMode>, trip: Trip) {
        _presentationMode = presentationMode
        self.trip = trip
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        $presentationMode.wrappedValue.dismiss()
    }

    func composeMail() -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        let subject = "Reminder from Budgetly"
        let messageBody = MailComposer.createMailBody(for: trip)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: false)
        // Set the sender email if needed
        return mailVC
    }
}
