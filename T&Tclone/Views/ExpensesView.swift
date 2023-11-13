//
//  ExpensesView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/21/23.
//

import Foundation
import SwiftUI

struct ExpensesView: View {
    var trip: Trip
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) var expenses: FetchedResults<Expense>
    
    init(trip: Trip) {
        self.trip = trip
        self._expenses = FetchRequest<Expense>(
            entity: Expense.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Expense.name, ascending: true)],
            predicate: NSPredicate(format: "trip == %@", trip)
        )
    }
    var body: some View {
        List {
            ForEach(expenses) { expense in
                VStack(alignment: .leading) {
                    Text(expense.name ?? "Unnamed")
                    Text("\(expense.person?.firstName ?? "Unknown") \(expense.person?.lastName ?? "") paid \(expense.amount)$")
                }
            }
        }
        
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddExpenseView(trip: trip)) {
                    Image(systemName: "plus")
                }
            }
        }
        
    }
}
