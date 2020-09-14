//
//  CounterExamplesViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 09-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit
protocol CounterExamplesViewDelegate: class {
    func userSelectedExample(title: String)
}

class CounterExamplesViewController: UIViewController {

    private var viewModel: CounterExamplesViewModel!
    weak var delegate: CounterExamplesViewDelegate?

    @IBOutlet weak var hsDrinks: UIStackView!
    @IBOutlet weak var hsFood: UIStackView!
    @IBOutlet weak var hsMisc: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = CounterExamplesViewModel()
        setupNavigationBar()

        viewModel.drinksExamples.forEach { drink in
            if let itemView = CounterExampleItem.instantiate(title: drink, delegate: self) {
                itemView.layer.cornerRadius = 8
                hsDrinks.addArrangedSubview(itemView)
            }
        }

        viewModel.foodExamples.forEach { food in
            if let itemView = CounterExampleItem.instantiate(title: food, delegate: self) {
                itemView.layer.cornerRadius = 8
                hsFood.addArrangedSubview(itemView)
            }
        }

        viewModel.miscExamples.forEach { misc in
            if let itemView = CounterExampleItem.instantiate(title: misc, delegate: self) {
                itemView.layer.cornerRadius = 8
                hsMisc.addArrangedSubview(itemView)
            }
        }
    }

    private func setupNavigationBar() {
        self.navigationItem.title = UIText.counterExamplesNavTitle
    }

}

extension CounterExamplesViewController: CounterExampleDelegate {
    func didTapExample(title: String) {
        DispatchQueue.main.async {
            self.delegate?.userSelectedExample(title: title)
            if let navigator = self.navigationController {
                navigator.popViewController(animated: true)
            }
        }
    }
}
