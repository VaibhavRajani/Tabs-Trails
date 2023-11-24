//
//  T_TcloneTests.swift
//  T&TcloneTests
//
//  Created by Vaibhav Rajani on 11/12/23.
//

import XCTest
@testable import T_Tclone
import CoreData

final class T_TcloneTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testAddTrip() {
        let dataController = DataController(inMemory: true)
        let tripName = "Test Trip"
        let startDate = Date()
        let endDate = Date().addingTimeInterval(24 * 60 * 60) // 1 day later

        dataController.addTrip(name: tripName, startDate: startDate, endDate: endDate, context: dataController.container.viewContext)

        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        let trips = try? dataController.container.viewContext.fetch(fetchRequest)

        XCTAssertEqual(trips?.count, 1)
        XCTAssertEqual(trips?.first?.name, tripName)
        XCTAssertEqual(trips?.first?.startDate, startDate)
        XCTAssertEqual(trips?.first?.endDate, endDate)
    }
    
    func testAddPerson() {
        let dataController = DataController()
        let personName = "John Doe"
        
        dataController.addPerson(firstName: "John", lastName: "Doe", email: "john@example.com", context: dataController.container.viewContext)

        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let persons = try? dataController.container.viewContext.fetch(fetchRequest)

        XCTAssertEqual(persons?.count, 1)
        XCTAssertEqual(persons?.first?.fullName, personName)
    }
    
}
extension Person {
    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
}
