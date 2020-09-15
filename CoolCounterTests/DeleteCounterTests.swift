//
//  DeleteCounterTests.swift
//  CoolCounterTests
//
//  Created by Luis Zapata on 14-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import XCTest
@testable import CoolCounter

class DeleteCounterTests: XCTestCase {

    private let interactor = CounterInteractor()
    private let worker = CounterWorker()
    var testCounters: [CounterModel.Counter] = []
    var expectedCountersCount = 5
    var testCountersIterator = 0

    let expInitTestCounters = XCTestExpectation(description: "Create counters for testing")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        worker.deleteAllLocalCounters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.requestCreateTestCounter()
        }
        wait(for: [self.expInitTestCounters], timeout: 10)
    }

    func requestCreateTestCounter() {
        interactor.createCounter(title: UUID().uuidString) { result in
            switch result {
            case .success(let counter):
                self.testCounters.append(counter)
                self.testCountersIterator += 1
                if self.testCounters.count < self.expectedCountersCount {
                    self.requestCreateTestCounter()
                } else if self.testCounters.count == self.expectedCountersCount {
                    self.expInitTestCounters.fulfill()
                }
            case .failure(let error):
                XCTFail("Failed init \(error)")
            }
        }
    }

    func testDeleteOne() throws {
        if testCounters.count < 1 {
            XCTFail("testCounters was not initialized")
            return
        }

        let testCounter = testCounters[Int.random(in: 0...expectedCountersCount - 1)]
        let expDelete = XCTestExpectation(description: "Delete counter \(testCounter.id)")
        interactor.deleteCounter(counterId: testCounter.id) { result in
            switch result {
            case .success(let counters):
                XCTAssertNil(counters.first(where: { testCounter.id == $0.id }), "Counter not deleted on server side")
            case .failure(let error):
                XCTFail("Service returned error \(error)")
            }
            expDelete.fulfill()
        }
        wait(for: [expDelete], timeout: 10)
    }

    func testDeleteManyLocal() throws {
        var countersToDelete: [CounterModel.Counter] = []
        let countToDelete = Int(testCounters.count / 2)
        print("countToDelete: \(countToDelete)")
        for _ in 1...countToDelete {
            let index = Int.random(in: 0...testCounters.count - 1)
            countersToDelete.append(testCounters[index])
            testCounters.remove(at: index)
        }

        if countersToDelete.count < 1 {
            XCTFail("Not enough counters to delete")
            return
        }

        let expDeleteMany = XCTestExpectation(description: "Delete \(countToDelete) counters locally")
        print("Deleting: \(countersToDelete)")
        interactor.deleteLocalCounters(counterIds: countersToDelete.compactMap({ $0.id })) { result in
            switch result {
            case .success:

                self.worker.getLocalCounters { result in
                    switch result {
                    case .success(let counters):
                        XCTAssertTrue(Set(counters).isDisjoint(with: countersToDelete),
                                      "Remaining counters contain at least one counter that should be deleted")
                        XCTAssertEqual(self.testCounters, counters, "Unexpected remaining array of counters")
                    case .failure(let error):
                        XCTFail("Service returned error \(error)")
                    }
                    expDeleteMany.fulfill()
                }

            case .failure(let error):
                XCTFail("Service returned error \(error)")
                expDeleteMany.fulfill()
            }
        }
        wait(for: [expDeleteMany], timeout: 10)

    }

    override func tearDownWithError() throws {
        worker.deleteAllLocalCounters()
    }
}
