//
//  Trip+CoreDataClass.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/22/23.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    var balances = [UUID: Double]()
}
