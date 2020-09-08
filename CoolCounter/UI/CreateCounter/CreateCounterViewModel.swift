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
    
    var createCounterSucceeded: Observable<Bool> = Observable(false)
    var createCounterError: Observable<AppError?> = Observable(nil)
    
    func createCounter(title: String) {
        counterInteractor.createCounter(title: title) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.createCounterSucceeded = Observable(true)
            case .failure(let error):
                self.createCounterError = Observable(error)
            }
        }
    }
}
