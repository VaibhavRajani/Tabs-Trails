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
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var receiptImageData: Data?
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        receiptImageData = inputImage.jpegData(compressionQuality: 1.0)
    }
    
    
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
                    Spacer()
                        .frame(height: 20)
                        .background(Color.gray.opacity(0.2))
                    Section(header: Text("Receipt")) {
                        Button("Add Picture") {
                            showingImagePicker = true
                        }
                        if let imageData = receiptImageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("No receipt image available")
                        }
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(isShown: $showingImagePicker, image: $inputImage)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(isShown: $showingImagePicker, image: $inputImage)
            }
            
            
            Button("Add Expense") {
                guard let amountDouble = Double(amount), let payerID = paidBy?.id else { return }; let payer = paidBy;
                
                if customSplit {
                    ExpenseController.addCustomSplitExpense(to: trip, name: expenseName, amount: amountDouble, paidBy: paidBy ?? Person(), customSplit: true, shares: shares, imageData: receiptImageData, context: managedObjContext)
                    
                } else {
                    ExpenseController.addExpense(to: trip, name: expenseName, amount: amountDouble, paidBy: paidBy ?? Person(), customSplit: false, shares: [:], imageData: receiptImageData, context: managedObjContext)
                }
                saveBalances()
                
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Add An Expense")
    }
    
    func saveBalances() {
        if let encoded = try? JSONEncoder().encode(trip.balances) {
            UserDefaults.standard.set(encoded, forKey: "balances_\(String(describing: trip.id))")
        }
    }
    
}
