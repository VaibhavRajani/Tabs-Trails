//
//  SettleUpView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/22/23.
//

import Foundation
import SwiftUI
import MessageUI

struct SettleUpView: View {
    var trip: Trip
    @State private var showMailView = false
    @State private var mailMessageBody = ""
    
    var body: some View {
        VStack{
            List {
                ForEach(trip.peopleArray, id: \.self) { person in
                    Section(header: Text(person.firstName ?? "Unknown")) {
                        ForEach(settleUp(person: person), id: \.self) { transaction in
                            Text(transaction)
                        }
                    }
                }
            }
            Spacer()
            
            Button("Remind People") {
                if MFMailComposeViewController.canSendMail() {
                    mailMessageBody = createMailBody()
                    showMailView = true
                } else {
                    // Handle the scenario where mail services are not available
                }
            }
            .padding()
        }
        .navigationTitle("Settle Up!")
        .sheet(isPresented: $showMailView) {
            MailView(subject: "Reminder from Budgetly", messageBody: mailMessageBody)
        }
    }
    
    func settleUp(person: Person) -> [String] {
        var transactions = [String]()
        let personBalance = trip.balances[person.id!] ?? 0
        
        if personBalance < 0 {
            for creditor in trip.peopleArray {
                let creditorBalance = trip.balances[creditor.id!] ?? 0
                if creditorBalance > 0 {
                    let amount = min(-personBalance, creditorBalance)
                    if amount > 0 {
                        transactions.append("Owes \(creditor.firstName ?? "") \(amount)$")
                    }
                }
            }
        } else if personBalance > 0 {
            transactions.append("Gets back \(personBalance)$")
        } else {
            transactions.append("Balanced")
        }
        
        return transactions
    }
    
    func createMailBody() -> String {
        var body = "Trip Name: \(trip.name ?? "Trip")\n\n"
        for person in trip.peopleArray {
            let transactions = settleUp(person: person)
            for transaction in transactions {
                body += "\(transaction)\n"
            }
        }
        return body
    }
    
}
