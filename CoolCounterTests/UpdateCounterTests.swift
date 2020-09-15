//
//  UpdateCounterTests.swift
//  CoolCounterTests
//
//  Created by Luis Zapata on 14-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import XCTest
@testable import CoolCounter

class UpdateCounterTests: XCTestCase {

    private let interactor = CounterInteractor()
    private let worker = CounterWorker()
    var testTitle: String?

    override func setUpWithError() throws {
        testTitle = UUID().uuidString
    }

    func testIncrementCounter() throws {
        let expectation = XCTestExpectation(description: "Request increment counter")
        interactor.createCounter(title: testTitle!) { result in

            //Create one counter for testing
            let testCounter: CounterModel.Counter?
            do {
                testCounter = try result.get()
            } catch let error {
                XCTFail("Couln't create test counter \(error)" )
                return
            }

            self.interactor.incrementCount(counter: testCounter!) { result in
                switch result {
                case .success:
                    self.interactor.fetchCounters { result, resultType in
                        if resultType == .local {
                            XCTFail("Couldn't fetch counters from server")
                        }
                        var counters: [CounterModel.Counter]?
                        do {
                            counters = try result.get()
                        } catch let error {
                            XCTFail("Couln't fetch updated counter \(error)" )
                        }

                        guard let updatedCounter = counters?.first(where: { $0.id == testCounter!.id }) else {
                            XCTFail("Couln't fetch updated counter from \(resultType)" )
                            return
                        }

                        XCTAssertEqual(testCounter!.count + 1, updatedCounter.count,
                                       "Fetched updated counter from \(resultType) but count was not incremented by 1")
                        expectation.fulfill()
                    }
                case .failure(let error):
                    expectation.fulfill()
                    XCTFail("Couln't create test counter \(error)" )
                }
            }

        }
        wait(for: [expectation], timeout: 8.0)
    }

}
