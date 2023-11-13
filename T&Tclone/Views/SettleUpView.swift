//
//  SettleUpView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/22/23.
//

import Foundation
import SwiftUI

struct SettleUpView: View {
    var trip: Trip

    var body: some View {
        List {
            ForEach(trip.peopleArray, id: \.self) { person in
                Section(header: Text(person.firstName ?? "Unknown")) {
                    ForEach(settleUp(person: person), id: \.self) { transaction in
                        Text(transaction)
                    }
                }
            }
        }
        .navigationTitle("Settle Up")
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

}
