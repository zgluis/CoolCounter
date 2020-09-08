//
//  CreateCounterViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 08-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class CreateCounterViewModel {
    private lazy var counterInteractor: CounterBusinessLogic = CounterInteractor()
    
    var isLoadingChanged: ((Bool) -> Void)?
    private(set) var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }
    var createCounterSucceeded: ((Bool) -> Void)?
    var createCounterError: ((AppError) -> Void)?
    
    func createCounter(title: String) {
        isLoading = true
        counterInteractor.createCounter(title: title) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success:
                self.createCounterSucceeded?(true)
            case .failure(let error):
                self.createCounterError?(error)
            }
        }
    }
}
