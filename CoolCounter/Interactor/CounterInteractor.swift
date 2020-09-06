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
}

class CounterInteractor: CounterBusinessLogic {
    
    var counterWorker = CounterWorker()
    
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
    
}
