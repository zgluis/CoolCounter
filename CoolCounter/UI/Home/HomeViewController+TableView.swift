//
//  HomeViewController+TableView.swift
//  CoolCounter
//
//  Created by Luis Zapata on 27-03-21.
//  Copyright © 2021 Luis Zapata. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.counters?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "counterCell") as? CounterCellView
        if cell == nil {
            cell = CounterCellView.createCell()
        }

        if let counter = viewModel.counters?[safe: indexPath.row] {
            cell?.setUp(indexAt: indexPath.row, counter: counter, interactor: viewModel.counterInteractor)
            cell?.delegate = self
        }

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.counterSelection[indexPath.item] = true
        refreshEditButtons()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.counterSelection[indexPath.item] = false
        refreshEditButtons()
    }
}

