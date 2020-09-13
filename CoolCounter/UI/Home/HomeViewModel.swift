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
    var counterSelection: [Bool] = []
    
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
                    self.counters = nil
                } else {
                    self.fetchError = nil
                    self.counters = counters
                }
            case .failure(let error):
                self.fetchError = error
            }
        }
    }
    
    private var selectedIds: [String] = []
    private var deletedIds: [String] = []
    private var deleteIterator = 0
    
    func deleteCounters(selectedIds: [String]) {
        self.selectedIds = selectedIds
        deletedIds = []
        deleteIterator = 0
        requestDeleteCounter(id: selectedIds[deleteIterator])
    }
    
    func requestDeleteCounter(id: String) {
        counterInteractor.deleteCounter(counterId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let counters):
                if self.deleteIterator == self.selectedIds.count - 1 {
                    if counters.count == 0 {
                        self.fetchError = AppError(id: .noData, message: "")
                        self.counters = nil
                    } else {
                        self.fetchError = nil
                        self.counters = counters
                        self.counterInteractor.deleteLocalCounters(counterIds: self.deletedIds) { _ in
                        }
                    }
                } else {
                    self.deletedIds.append(id)
                    self.deleteIterator += 1
                    self.requestDeleteCounter(id: self.selectedIds[self.deleteIterator])
                }
            case .failure:
                //TODO: show error message
                break
            }
        }
    }
    
    func updateCounter(atIndex: Int, newValue: Int) {
        counters?[atIndex].count = newValue
    }
    
    func addCounter(counter: CounterModel.Counter) {
        if counters == nil {
            counters = [counter]
        } else {
            counters!.append(counter)
        }
    }
}
