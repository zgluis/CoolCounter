//
//  HomeViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class HomeViewModel {
    private var counterInteractor: CounterBusinessLogic?
    
    var bindCounters: (() -> Void) = {}
    private(set) var counters: [CounterModel.Counter]! {
        didSet {
            self.bindCounters()
        }
    }
    
    init() {
        counterInteractor = CounterInteractor()
        fetchCounters()
    }
    
    func fetchCounters() {
        counterInteractor?.fetchCounters { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                print("Counters: \(counters)")
                self.counters = counters
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
