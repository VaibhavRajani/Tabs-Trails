//
//  AddExpenseView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/22/23.
//

import Foundation
import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var trip: Trip
    @State private var expenseName: String = ""
    @State private var paidBy: Person?
    @State private var amount: String = ""
    @State private var customSplit: Bool = false
    @State private var shares: [UUID: Double] = [:]  

    var body: some View {
        Form {
            Section(header: Text("Expense Name")) {
                TextField("Expense name", text: $expenseName)
            }

            Section(header: Text("Paid By")) {
                NavigationLink(destination: SelectPersonView(selectedPerson: $paidBy, context: .expense, people: trip.peopleArray)) {
                    HStack {
                        Text("Name: ")
                        Spacer()
                        Text("\(paidBy?.firstName ?? "") \(paidBy?.lastName ?? "")")
                            .foregroundStyle(.gray)
                    }
                }
            }


            Section(header: Text("Expense Amount")) {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Section(header: Text("Custom Split")) {
                Toggle(isOn: $customSplit) {
                    Text("Custom Split")
                }

                if customSplit {
                    ForEach(trip.peopleArray, id: \.self) { person in
                        HStack {
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                            Spacer()
                            TextField("Share", value: $shares[person.id!], format: .number)
                                .keyboardType(.decimalPad)
                        }
                    }
                }
            }

            Button("Add Expense") {
                if customSplit {
                                addCustomSplitExpense()
                            } else {
                                addExpense()
                            }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Add An Expense")
    }
    
    func addExpense() {
        guard let amountDouble = Double(amount), let payerID = paidBy?.id else { return }; let payer = paidBy;
        if trip.balances.isEmpty {
                trip.peopleArray.forEach { person in
                    trip.balances[person.id!] = 0
                }
            }
        let newExpense = Expense(context: managedObjContext)
            newExpense.id = UUID()
            newExpense.name = expenseName
            newExpense.amount = amountDouble
        newExpense.person = payer
            trip.addToExpense(newExpense)
        
        let splitAmount = amountDouble / Double(trip.peopleArray.count)
            for person in trip.peopleArray {
                if person.id == payerID {
                    trip.balances[payerID, default: 0] += amountDouble - splitAmount
                } else {
                    trip.balances[person.id!, default: 0] -= splitAmount
                }
            }
        print(expenseName)

        saveBalances()
        // Save the changes to the context
        DataController().save(context: managedObjContext)
    }
    
    func addCustomSplitExpense() {
        guard let totalAmountDouble = Double(amount), let payerID = paidBy?.id else { return }; let payer = paidBy;
        if trip.balances.isEmpty {
                trip.peopleArray.forEach { person in
                    trip.balances[person.id!] = 0
                }
            }
            let customSplitTotal = shares.values.reduce(0, +)

            guard customSplitTotal == totalAmountDouble else {
                print("Custom split amounts do not total up to the expense amount.")
                return
            }

            for person in trip.peopleArray {
                if let share = shares[person.id!] {
                    if person.id == payerID {
                        trip.balances[payerID, default: 0] += totalAmountDouble - share
                    } else {
                        trip.balances[person.id!, default: 0] -= share
                    }
                }
                print(expenseName)
            }
            saveBalances()

            DataController().save(context: managedObjContext)
        }
    
    func saveBalances() {
        if let encoded = try? JSONEncoder().encode(trip.balances) {
            UserDefaults.standard.set(encoded, forKey: "balances_\(String(describing: trip.id))")
        }
    }
    
}
