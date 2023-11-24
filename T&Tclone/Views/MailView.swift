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
        let subject = "Reminder from Budgetly"
        let messageBody = createMailBody(for: trip)
        print(messageBody)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: false)
        // Set the sender email if needed
        return mailVC
    }
    
    func createMailBody(for trip: Trip) -> String {
        var body = "Trip Name: \(trip.name ?? "Trip")\n\n"
        for person in trip.peopleArray {
            
            let transactions = SettlementCalculator.settleUp(trip:trip, for: person)
            for transaction in transactions {
                body += "\(person.firstName!)" + ": " + "\(transaction)\n"
            }
        }
        return body
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
}

