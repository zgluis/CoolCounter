//
//  CreateCounterViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 08-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class CreateCounterViewModel {
    var counterInteractor: CounterBusinessLogic?

    var isLoadingChanged: ((Bool) -> Void)?
    private(set) var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }
    var createCounterSucceeded: ((CounterModel.Counter) -> Void)?
    var createCounterError: ((AppError) -> Void)?

    func createCounter(title: String) {
        isLoading = true
        counterInteractor?.createCounter(title: title) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let counter):
                self.createCounterSucceeded?(counter)
            case .failure(let error):
                self.createCounterError?(error)
            }
        }
    }
}
