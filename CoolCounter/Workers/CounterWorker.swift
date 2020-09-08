//
//  CounterWorker.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

protocol CounterWorkerProtocol {
    func getRemoteCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func incrementCount(request: CounterModel.Increment.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func decrementCount(request: CounterModel.Decrement.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func deleteCounter(request: CounterModel.Delete.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
    func createCounter(request: CounterModel.Create.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void)
}

class CounterWorker: CounterWorkerProtocol {
    
    func getRemoteCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.get(resource: "counters", completion: completion)
    }
    
    func incrementCount(request: CounterModel.Increment.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter/inc", parameters: request.toParameters(), completion: completion)
    }
    
    func decrementCount(request: CounterModel.Decrement.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter/dec", parameters: request.toParameters(), completion: completion)
    }
    
    func deleteCounter(request: CounterModel.Delete.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.delete(resource: "counter", parameters: request.toParameters(), completion: completion)
    }
    
    func createCounter(request: CounterModel.Create.Request, _ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.post(resource: "counter", parameters: request.toParameters(), completion: completion)
    }
    
}
