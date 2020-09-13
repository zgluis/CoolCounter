//
//  SearchCounterResultsViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 10-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class SearchCounterResultsViewModel {
    var counterInteractor: CounterBusinessLogic?
    var counters: [CounterModel.Counter]?
    
    var bindFilteredCounters: (() -> Void) = {}
    private(set) var filteredCounters: [CounterModel.Counter] = [] {
        didSet {
            self.bindFilteredCounters()
        }
    }
    
    var bindSearchError: (() -> Void) = {}
    private(set) var searchError: AppError? {
        didSet {
            self.bindSearchError()
        }
    }
    
    func search(term: String) {
        if counters != nil {
            filteredCounters = counters!.filter({ counter in
                return counter.title.lowercased().contains(term.lowercased())
            })
        }


//        counterInteractor?.searchCounter(term: term) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let counters):
//                if counters.count == 0 {
//                    self.searchError = AppError(id: .noData)
//                } else {
//                    self.searchError = nil
//                    self.filteredCounters = counters
//                }
//            case .failure(let error):
//                self.searchError = error
//            }
//        }
    }
}
