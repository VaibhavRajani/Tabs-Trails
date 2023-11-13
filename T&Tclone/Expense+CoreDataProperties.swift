//
//  Expense+CoreDataProperties.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/22/23.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var person: Person?
    @NSManaged public var trip: Trip?

}

extension Expense : Identifiable {

}
