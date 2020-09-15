//
//  CounterInteractor.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

protocol CounterBusinessLogic {
    func fetchCounters(_ completion: @escaping (Result<[CounterModel.Counter], AppError>, ResultType) -> Void)
    func incrementCount(counter: CounterModel.Counter, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func decrementCount(counter: CounterModel.Counter, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func deleteCounter(counterId: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void)
    func createCounter(title: String, _ completion: @escaping (Result<CounterModel.Counter, AppError>) -> Void)
    func deleteLocalCounters(counterIds: [String], _ completion: @escaping (Result<Void, AppError>) -> Void)
}

class CounterInteractor: CounterBusinessLogic {

    private var counterWorker: CounterWorkerProtocol = CounterWorker()
    private var userDefaults = Defaults()
    private var hasLocalCounters: Bool?

    func fetchCounters(_ completion: @escaping (Result<[CounterModel.Counter], AppError>, ResultType) -> Void) {
        counterWorker.getRemoteCounters { [weak self] result in
            switch result {
            case .success(let counters):
                completion(.success(counters), .remote)
            case .failure:

                guard let self = self else {
                    completion(.failure(AppError()), .remote)
                    return
                }

                // dosn't have local counter? -> return same error
                if self.hasLocalCounters != nil && !self.hasLocalCounters! {
                    completion(.failure(AppError()), .remote)
                    return
                }

                self.counterWorker.getLocalCounters { result in
                    switch result {
                    case .success(let counters):
                        self.userDefaults.set(key: .hasLocalCounters, value: counters.count > 0)
                        self.hasLocalCounters = counters.count > 0

                        completion(.success(counters), .local)
                    case .failure:
                        completion(.failure(AppError()), .local)
                    }
                }
            }
        }
    }

    func incrementCount(counter: CounterModel.Counter, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.incrementCount(request: CounterModel.Increment.Request(id: counter.id)) { [weak self] result in
            switch result {
            case .success:
                completion(.success(()))
                if let self = self {
                    self.counterWorker.updateLocalCounter(counter: counter, increment: true)
                }
            case .failure:
                completion(.failure(AppError(id: .network, message: UIText.errorNetwork)))
            }
        }
    }

    func decrementCount(counter: CounterModel.Counter, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.decrementCount(request: CounterModel.Decrement.Request(id: counter.id)) { [weak self] result in
            switch result {
            case .success:
                completion(.success(()))
                if let self = self {
                    self.counterWorker.updateLocalCounter(counter: counter, increment: false)
                }
            case .failure:
                completion(.failure(AppError(id: .network, message: UIText.errorNetwork)))
            }
        }
    }

    func deleteCounter(counterId: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void) {
        let request = CounterModel.Delete.Request(id: counterId)
        counterWorker.deleteCounter(request: request) { result in
            switch result {
            case .success(let counters):
                if counters.count == 0 {
                    self.userDefaults.set(key: .hasLocalCounters, value: false)
                    self.hasLocalCounters = false
                }
                completion(.success(counters))
            case .failure:
                completion(.failure(AppError()))
            }
        }
    }

    func createCounter(title: String, _ completion: @escaping (Result<CounterModel.Counter, AppError>) -> Void) {
        counterWorker.createCounter(request: CounterModel.Create.Request(title: title)) { [weak self] result in
            switch result {
            case .success(let counters):
                if let counter = counters.last, let self = self {
                    self.hasLocalCounters = true
                    self.counterWorker.storeCounter(counter: counter)
                    if self.hasLocalCounters == nil || !self.hasLocalCounters! {
                        self.userDefaults.set(key: .hasLocalCounters, value: true)
                    }
                    completion(.success(counter))
                } else {
                    completion(.failure(AppError()))
                }
            case .failure:
                completion(.failure(AppError()))
            }
        }
    }

    func deleteLocalCounters(counterIds: [String], _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.deleteLocalCounters(countersIds: counterIds) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(AppError(id: .coreData)))
            }
        }
    }
}
