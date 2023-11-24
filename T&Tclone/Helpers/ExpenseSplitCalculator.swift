//
//  ExpenseCalculator.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 12/7/23.
//

import SwiftUI

struct ExpenseSplitCalculator {
    static func calculateRegularShare(expense: Expense, person: Person, peopleCount: Int) -> Double {
        let splitAmount = expense.amount / Double(peopleCount)
        if person.id == expense.person?.id {
            return expense.amount - splitAmount
        } else {
            return splitAmount
        }
    }

    static func calculateCustomShare(expense: Expense, person: Person, shares: [UUID: Double]) -> Double {
        guard let personShare = shares[person.id!] else { return 0 }
        let totalAmount = expense.amount
        let payer = expense.person

        if person.id == payer?.id {
            let totalShares = shares.values.reduce(0, +)
            return totalAmount - personShare
        } else {
            return personShare
        }
    }

    static func formatShare(share: Double, person: Person, isPayer: Bool, currencySymbol: String) -> String {
        let formattedShare = String(format: "%.2f", share) + currencySymbol
        if isPayer {
            return "\(person.firstName ?? "Unknown") gets back \(formattedShare)"
        } else {
            return "\(person.firstName ?? "Unknown") owes \(formattedShare)"
        }
    }
}
