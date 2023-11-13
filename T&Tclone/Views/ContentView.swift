//
//  ContentView.swift
//  T&Tclone
//
//  Created by Vaibhav Rajani on 11/12/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]) var trip: FetchedResults<Trip>
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(trip) { trip in
                        NavigationLink(destination: TripPeopleView(trip: trip)){
                            HStack{
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(trip.name!)
                                        .bold()
                                    HStack{
                                        Text(trip.startDate != nil ? formatDate(trip.startDate!) : "No Date")
                                        Text(" - ")
                                        Text(trip.endDate != nil ? formatDate(trip.endDate!) : "No Date")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    
                                    
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTrip)
                }
                .listStyle(.plain)
                
            }
            .navigationTitle("Trips")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Trip", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView){
                AddTripView()
            }
        }
    }
    
    private func deleteTrip(offsets: IndexSet) {
        //pass
    }
}

#Preview {
    ContentView()
}
