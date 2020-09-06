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
}

class CounterWorker: CounterWorkerProtocol {
    func getRemoteCounters(_ completion: @escaping (Result<[CounterModel.Counter], Error>) -> Void) {
        requestHandler.get(resource: "counters", completion: completion)
    }
}
