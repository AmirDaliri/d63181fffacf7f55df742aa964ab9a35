//
//  d63181fffacf7f55df742aa964ab9a35Tests.swift
//  d63181fffacf7f55df742aa964ab9a35Tests
//
//  Created by amir on 23.12.2020.
//

import XCTest
@testable import d63181fffacf7f55df742aa964ab9a35

class d63181fffacf7f55df742aa964ab9a35Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testEncoding() {
        guard let url = URL(string: "https:www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: Parameters = [
            "UserID": 1,
            "Name": "Malcolm",
            "Email": "malcolm@network.com",
            "IsCool": true
        ]
        do {
            let encoder = URLParameterEncoder()
            try encoder.encode(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }

            let expectedURL = "https:www.google.com/?Name=Malcolm&Email=malcolm%2540network.com&UserID=1&IsCool=true"
            XCTAssertEqual(fullURL.absoluteString.sorted(), expectedURL.sorted())
        } catch {}
    }
}
