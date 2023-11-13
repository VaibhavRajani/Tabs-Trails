//
//  TripPeopleView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/13/23.
//

import Foundation
import SwiftUI

struct TripPeopleView: View {
    var trip: Trip
    
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedPerson: Person?
    @State private var selectedPeople = Set<UUID>()
    @State private var currentTrip: Trip?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)],
        animation: .default)
    private var persons: FetchedResults<Person>
    
    
    var body: some View {
            Form {
                Section(header: Text("People")) {
                    if case let peopleArray = trip.peopleArray {
                        ForEach(peopleArray, id: \.self) { person in
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                        }
                    }
                    
                }
                
                Section(header: Text("Add A Person")) {
                    NavigationLink(destination: SelectPersonView(selectedPerson: $selectedPerson, context: .trip, people: [])) {
                        HStack{
                            Text("Name: ")
                            Spacer()
                            Text("\(selectedPerson?.firstName ?? "") \(selectedPerson?.lastName ?? "")")
                                .foregroundStyle(.gray)
                        }
                    }
                        
                    Button("Add Person") {
                        if let person = selectedPerson {
                            if !trip.peopleArray.contains(where: { $0.id == person.id }) {
                                addPersonToTrip(person: person)
                            }
                        }
                    }
                }
                
                Section(header: Text("Add A New Person")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    Button("Save Person") {
                        DataController().addPerson(firstName: firstName, lastName: lastName, context: managedObjContext)
                        firstName = ""
                        lastName = ""
                    }
                }
                
                Section{
                    HStack{
                        Spacer()
                        Button("Confirm Changes") {
                            DataController().save(context: managedObjContext)
                            dismiss()
                        }
                        Spacer()
                    }
                }
                if !selectedPeople.isEmpty {
                    Section(header: Text("People Added to Trip")) {
                        ForEach(persons.filter { selectedPeople.contains($0.id!) }, id: \.self) { person in
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                        }
                    }
                }
                
                NavigationLink(destination: ExpensesView(trip: trip)) {
                                Text("Expenses")
                            }
                
                NavigationLink(destination: SettleUpView(trip: trip)) {
                    Text("Settle Up")
                }
            }
            .navigationTitle(trip.name!)      
            .onAppear{
                loadBalances()
            }
    }
    private func addPersonToTrip(person: Person) {
        if trip != nil {
            DataController().addPersonToTrip(person: selectedPerson!, trip: trip, context: managedObjContext)
            if trip.balances[person.id!] == nil {
                trip.balances[person.id!] = 0
                    }
        } else {
            print("Error Adding to Trip")
        }
    }
    
    func loadBalances() {
        if let savedBalances = UserDefaults.standard.object(forKey: "balances_\(String(describing: trip.id))") as? Data {
            if let decodedBalances = try? JSONDecoder().decode([UUID: Double].self, from: savedBalances) {
                trip.balances = decodedBalances
            }
        }
    }
}

#Preview {
    ContentView()
}
