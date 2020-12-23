//
//  StationsModelTest.swift
//  d63181fffacf7f55df742aa964ab9a35Tests
//
//  Created by amir on 23.12.2020.
//  Copyright © 2020 Amir Daliri. All rights reserved.
//

import XCTest
@testable import d63181fffacf7f55df742aa964ab9a35

class StationsModelTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataModelParsedCorrectly() {
        var stations = Stations()
        stations = Stations(arrayLiteral: Station(name: "test name", coordinateX: Double(2), coordinateY: Double(1), need: 5000, capacity: 10000, stock: 5000))
        XCTAssertNotEqual(stations.count, 0)
        XCTAssertEqual(stations.first?.name, "test name")
        XCTAssertEqual(stations.first?.coordinateX, 2)
        XCTAssertEqual(stations.first?.coordinateY, 1)
        XCTAssertEqual(stations.first?.capacity, 10000)
        XCTAssertEqual(stations.first?.stock, 5000)
        XCTAssertEqual(stations.first?.need, 5000)
    }
}
