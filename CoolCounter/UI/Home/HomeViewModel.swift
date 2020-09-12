//
//  HomeViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class HomeViewModel {
    var counterInteractor: CounterBusinessLogic = CounterInteractor()
    
    var bindCounters: (() -> Void) = {}
    private(set) var counters: [CounterModel.Counter]? {
        didSet {
            self.bindCounters()
        }
    }
    
    var bindFetchCountersError: (() -> Void) = {}
    private(set) var fetchError: AppError? {
        didSet {
            self.bindFetchCountersError()
        }
    }
    
    func fetchCounters() {
        counterInteractor.fetchCounters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                if counters.count == 0 {
                    self.fetchError = AppError(id: .noData, message: "")
                } else {
                    self.fetchError = nil
                    self.counters = counters
                }
            case .failure(let error):
                self.fetchError = error
            }
        }
    }
    
    func updateCounter(atIndex: Int, newValue: Int) {
        counters?[atIndex].count = newValue
    }
    
    func addCounter(counter: CounterModel.Counter) {
        counters?.append(counter)
    }
}
