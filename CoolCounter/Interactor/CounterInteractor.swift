//
//  CounterInteractor.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

protocol CounterBusinessLogic {
    func fetchCounters(_ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void)
    func incrementCount(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func decrementCount(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func deleteCounter(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void)
    func createCounter(title: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void)
    func searchCounter(term: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void)
}

class CounterInteractor: CounterBusinessLogic {
    
    private var counterWorker = CounterWorker()
    
    func fetchCounters(_ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void) {
        counterWorker.getRemoteCounters { result in
            switch result {
            case .success(let counters):
                completion(.success(counters))
            case .failure:
                completion(.failure(AppError(message: UIText.loremShort)))
            }
        }
    }
    
    func incrementCount(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.incrementCount(request: CounterModel.Increment.Request(id: counterId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(AppError(message: UIText.loremShort)))
            }
        }
    }
    
    func decrementCount(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.decrementCount(request: CounterModel.Decrement.Request(id: counterId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(AppError(message: UIText.loremShort)))
            }
        }
    }
    
    func deleteCounter(counterId: String, _ completion: @escaping (Result<Void, AppError>) -> Void) {
        counterWorker.deleteCounter(request: CounterModel.Delete.Request(id: counterId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure:
                completion(.failure(AppError(message: UIText.loremShort)))
            }
        }
    }
    
    func createCounter(title: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void) {
        counterWorker.createCounter(request: CounterModel.Create.Request(title: title)) { result in
            switch result {
            case .success(let counters):
                completion(.success(counters))
            case .failure:
                completion(.failure(AppError(message: UIText.errorNetwork)))
            }
        }
    }
    
    func searchCounter(term: String, _ completion: @escaping (Result<[CounterModel.Counter], AppError>) -> Void) {
        completion(.success([CounterModel.Counter(id: "123", title: "Prueba", count: 1)]))
    }
    
}
