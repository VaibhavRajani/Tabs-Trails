//
//  SelectPersonView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/21/23.
//

import Foundation
import SwiftUI

enum SelectPersonContext {
    case trip
    case expense
}

struct SelectPersonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedPerson: Person?
    var context: SelectPersonContext
    var people: [Person]
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)])
    private var allPersons: FetchedResults<Person>

    var body: some View {
        List(peopleList, id: \.self) { person in
            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                .onTapGesture {
                    self.selectedPerson = person
                    self.presentationMode.wrappedValue.dismiss()
                }
        }
    }

    private var peopleList: [Person] {
        switch context {
        case .trip:
            return Array(allPersons)
        case .expense:
            return people
        }
    }
}

