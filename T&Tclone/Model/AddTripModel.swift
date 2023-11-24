//
//  AddTripModel.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/30/23.
//

import Foundation
import CoreData

class AddTripViewController: ObservableObject {
    
    @Published var name = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var selectedPerson: Person?
    @Published var selectedPeople = Set<UUID>()
    @Published var currentTrip: Trip?
    
}
