//
//  SettlementCalculator.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/24/23.
//

import Foundation

class SettlementCalculator {
    static func settleUp(trip: Trip, for person: Person) -> [String] {
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
