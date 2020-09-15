//
//  CreateCounterTests.swift
//  CoolCounterTests
//
//  Created by Luis Zapata on 14-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import XCTest
@testable import CoolCounter

class CreateCounterTests: XCTestCase {

    private let interactor = CounterInteractor()
    private let worker = CounterWorker()
    var testTitle: String?

    override func setUpWithError() throws {
        testTitle = UUID().uuidString
    }

    func testCreation() throws {
        let expectation = XCTestExpectation(description: "Request create counter and fetch it")

        interactor.createCounter(title: testTitle!) { result in
            switch result {
            case .success(let counter):
                XCTAssertEqual(self.testTitle, counter.title, "Interactor did not return the right counter")
                self.interactor.fetchCounters { result, resultType in
                    switch result {
                    case .success(let counters):
                        if resultType == .local {
                            XCTFail("Couldn't fetch counters from server")
                        }
                        XCTAssertNotNil(counters.first(where: { $0.id == counter.id }),
                                        "Counter not created propertly, couln't find in \(resultType) response ")
                        expectation.fulfill()
                    case .failure(let error):
                        XCTAssertNil(error, "Fetch \(resultType) returned error")
                        expectation.fulfill()
                    }
                }
            case .failure(let appError):
                XCTAssertNil(appError, "Failed connecting to service")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 8.0)
    }

}
