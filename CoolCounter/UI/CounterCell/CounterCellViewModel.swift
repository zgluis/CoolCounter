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
    var stepperValue: Int = 0
    
    init(counter: CounterModel.Counter, interactor: CounterBusinessLogic?) {
        self.counter = counter
        self.stepperValue = counter.count
        self.counterInteractor = interactor
    }
    
    func incrementCount() {
        counterInteractor?.incrementCount(counter: counter) { result in
            switch result {
            case .success :
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func decrementCount() {
        counterInteractor?.decrementCount(counter: counter) { result in
            switch result {
            case .success :
                break
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
