//
//  HomeViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    //TODO: Pass viewController
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    private var refreshControl: UIRefreshControl?
    @IBOutlet weak var tvCounters: UITableView!
    @IBOutlet weak var lblCountersDetail: UILabel!
    @IBOutlet weak var btnAddToolbar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeViewModel()
        self.viewModel.bindCounters = {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tvCounters.reloadData()
                self.reloadCountersDetail()
            }
        }
        
        setupNavigationBar()
        
        //Table View
        self.tvCounters.register(UINib.init(nibName: "CounterCellView", bundle: nil), forCellReuseIdentifier: "counterCell")
        self.tvCounters.delegate = self
        self.tvCounters.dataSource = self
        
        //Toolbar
        btnAddToolbar.action = #selector(didTapAdd)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action:
            #selector(handleRefresh),
                                 for: UIControl.Event.valueChanged)
        tvCounters.refreshControl = refreshControl
    }
    
    private func setupNavigationBar() {
        //TODO: Change statusBar color, fix; status bar is overlapping navigation bar
        //navigationController?.setStatusBarColor(UIColor(appColor: .grayLight))
        self.navigationItem.title = UIText.loremShort
        
        //Buttons
        self.editButtonItem.action = #selector(didTapEdit)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //Search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true

        navigationItem.searchController = searchController
    }
    
    @objc func handleRefresh() {
        viewModel.fetchCounters()
    }
    
    func reloadCountersDetail() {
        if viewModel.counters?.count ?? 0 > 0 {
            lblCountersDetail.isHidden = false
            let counted = viewModel.counters.reduce(0) { $0 + $1.count}
            lblCountersDetail.text = "\(viewModel.counters.count) items ᛫ Counted \(counted) times"
        } else {
            lblCountersDetail.isHidden = true
        }
    }
    
    @objc func didTapEdit() {
        
    }
    
    @objc func didTapAdd() {        
        if let createCounterVC = self.storyboard?
            .instantiateViewController(withIdentifier: "createCounterViewController") as? CreateCounterViewController {
            let navController = UINavigationController(rootViewController: createCounterVC)
            navController.view.backgroundColor = UIColor(appColor: .navBar)
            navController.view.tintColor = UIColor(appColor: .accent)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.counters?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "counterCell") as? CounterCellView
        if cell == nil {
            cell = CounterCellView.createCell()
        }
        cell?.setData(counter: viewModel.counters[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension HomeViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}
