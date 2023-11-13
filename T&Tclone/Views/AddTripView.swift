//
//  AddTripView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/12/23.
//

import SwiftUI

struct AddTripView: View {
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
            Section(header: Text("Trip Details")) {
                Text("Trip Name")
                    .foregroundColor(.gray)
                    .font(.caption)
                TextField("Trip name", text: $name)
                
                Text("Trip Duration")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                VStack(alignment: .leading) {
                    Text("FROM:")
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                    
                    Text("TO:")
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                HStack{
                    Spacer()
                    Button("Submit") {
                        DataController().save(context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
                
            }
            
            Section(header: Text("Add New Person")) {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                Button("Save Person") {
                    DataController().addPerson(firstName: firstName, lastName: lastName, context: managedObjContext)
                }
            }
            
            Section(header: Text("Select Person for Trip")) {
                List(persons, id: \.self) { person in
                    HStack {
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                        Spacer()
                        if selectedPerson == person {
                            Image(systemName: "checkmark")
                        }
                    }
                    .onTapGesture {
                        if selectedPeople.contains(person.id!) {
                            selectedPeople.remove(person.id!)
                        } else {
                            selectedPeople.insert(person.id!)
                        }
                    }
                }
            }
            
            Button("Add to Trip") {
                for personId in selectedPeople {
                    if let person = persons.first(where: { $0.id == personId }) {
                        addPersonToTrip(person: person)
                    }
                }
            }
            
            if !selectedPeople.isEmpty {
                Section(header: Text("People Added to Trip")) {
                    ForEach(persons.filter { selectedPeople.contains($0.id!) }, id: \.self) { person in
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                    }
                }
            }
        }
    }
    
    private func addPersonToTrip(person: Person) {
        if currentTrip == nil {
            currentTrip = Trip(context: managedObjContext) 
            currentTrip!.id = UUID()
            currentTrip!.name = name
            currentTrip!.startDate = startDate
            currentTrip!.endDate = endDate
            let selectedPeopleObjects = persons.filter { selectedPeople.contains($0.id!) }
            DataController().addPeopleToTrip(people: Set(selectedPeopleObjects), trip: currentTrip!, context: managedObjContext)
        } else {
            print("Error Adding to Trip")
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View{
        AddTripView()
    }
}
