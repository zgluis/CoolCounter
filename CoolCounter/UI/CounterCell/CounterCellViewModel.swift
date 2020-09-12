//
//  CounterCellViewModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 07-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class CounterCellViewModel {
    
    var counterInteractor: CounterBusinessLogic?
    let counter: CounterModel.Counter

    var isLoadingChanged: ((Bool) -> Void)?
    private(set) var isLoading = false {
        didSet {
            isLoadingChanged?(isLoading)
        }
    }
    
    var incrementSucceeded: (() -> Void)?
    var incrementError: ((AppError) -> Void)?
    
    var decrementSucceeded: (() -> Void)?
    var decrementError: ((AppError) -> Void)?
    
    init(counter: CounterModel.Counter, interactor: CounterBusinessLogic?) {
        self.counter = counter
        self.counterInteractor = interactor
    }
    
    func incrementCount() {
        self.isLoading = true
        counterInteractor?.incrementCount(counter: counter) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success :
                self?.incrementSucceeded?()
            case .failure(let error):
                self?.incrementError?(error)
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func decrementCount() {
        isLoading = true
        counterInteractor?.decrementCount(counter: counter) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success :
                self?.decrementSucceeded?()
            case .failure(let error):
                self?.decrementError?(error)
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
