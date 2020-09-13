//
//  SearchCounterResultsViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 10-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

enum SearchCounterResultsViewState {
    case hasContent
    case noContent
    case noResult
}

class SearchCounterResultsViewController: UIViewController {

    private var viewState: SearchCounterResultsViewState = .noContent
    @IBOutlet weak var tvResults: UITableView!
    @IBOutlet weak var lblNoResult: UILabel!
    @IBOutlet weak var constraintCenterYLblNoResult: NSLayoutConstraint!
    
    //TODO: avoid coupling
    weak var viewModel: HomeViewModel? {
        didSet {
            viewModel?.bindFilteredCounters = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateViewState(state: .hasContent)
                }
            }
            
            viewModel?.bindSearchError = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateViewState(state: .noResult)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Table View
        self.tvResults.register(UINib.init(nibName: "CounterCellView", bundle: nil), forCellReuseIdentifier: "counterCell")
        self.tvResults.delegate = self
        self.tvResults.dataSource = self
        
        updateViewState(state: .noContent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    private var updated = false
    @objc fileprivate func keyboardDidShow(notification: NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //TODO: animate, specially on device rotation
            self.constraintCenterYLblNoResult.constant = (keyboardRectValue.height / 2) * -1
        }
    }
    
    func updateViewState(state: SearchCounterResultsViewState) {
        switch state {
        case .hasContent:
            tvResults.reloadData()
            lblNoResult.isHidden = true
        case .noContent:
            lblNoResult.isHidden = true
        case .noResult:
            tvResults.reloadData()
            lblNoResult.isHidden = false
        }
    }
    
}

extension SearchCounterResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel?.search(term: searchController.searchBar.text!)
    }
}

extension SearchCounterResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filteredCounters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "counterCell") as? CounterCellView
        if cell == nil {
            cell = CounterCellView.createCell()
        }
        
        if let counter = viewModel?.filteredCounters[safe: indexPath.row] {
            cell?.setData(indexAt: indexPath.row, counter: counter, interactor: viewModel?.counterInteractor)
            cell?.delegate = self
        }
        
        return cell ?? UITableViewCell()
    }
}

extension SearchCounterResultsViewController: CounterCellViewDelegate {
    func countUpdated(id: String, newValue: Int) {
        viewModel?.updateCounter(id: id, newValue: newValue)
    }
}
