//
//  ExpenseDetailView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 12/1/23.
//

import SwiftUI

struct ExpenseDetailView: View {
    var expense: Expense
    var people: [Person] // List of people involved in the expense
    let userCurrency = UserDefaults.standard.string(forKey: "currency") ?? "USD"
    var customSplit: Bool
    var shares: [UUID: Double]
    
    var body: some View {
        List{
            Section(header: Text("Paid By")) {
                Text("\(expense.person?.firstName ?? "Unknown") \(expense.person?.lastName ?? "")")
            }
            
            Section(header: Text("Amount")) {
                let convertedAmount = CurrencyConverter.shared.convertAmount(amount: expense.amount, from: "USD", to: userCurrency)
                Text("\(String(format: "%.2f", convertedAmount))\(userCurrency == "USD" ? "$" : "€")")
            }
            
            Section(header: Text("Date")) {
                Text(expense.date ?? Date(), formatter: itemFormatter)
            }
            
            Section(header: Text("Shares")) {
                            ForEach(people, id: \.self) { person in
                                let share = customSplit ?
                                    ExpenseSplitCalculator.calculateCustomShare(expense: expense, person: person, shares: shares) :
                                    ExpenseSplitCalculator.calculateRegularShare(expense: expense, person: person, peopleCount: people.count)
                                Text(ExpenseSplitCalculator.formatShare(share: share, person: person, isPayer: person.id == expense.person?.id, currencySymbol: (userCurrency == "USD" ? "$" : "€")))
                            }
                        }
            
            Section(header: Text("Receipt")) {
                if let imageData = expense.image, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No receipt image available")
                }
            }
        }
        .navigationTitle(expense.name ?? "Unknown Expense")
    }
    
    private func calculateShare(for person: Person) -> Double {
        let splitAmount = CurrencyConverter.shared.convertAmount(amount: expense.amount / Double(people.count), from: "USD", to: userCurrency)
        if person.id == expense.person?.id {
            return CurrencyConverter.shared.convertAmount(amount: expense.amount - splitAmount, from: "USD", to: userCurrency)
        } else {
            return splitAmount
        }
    }
    
    private func formatShare(_ share: Double, for person: Person) -> String {
        let formattedShare = String(format: "%.2f", share) + (userCurrency == "USD" ? "$" : "€")
        if person.id == expense.person?.id {
            return "\(person.firstName ?? "Unknown") gets back \(formattedShare)"
        } else {
            return "\(person.firstName ?? "Unknown") owes \(formattedShare)"
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()
