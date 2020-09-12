//
//  HomeViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

enum HomeViewState {
    case loading
    case hasContent
    case noContent
    case error
    case refreshing
}

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    private var searchViewController: SearchCounterResultsViewController?
    private var searchController: UISearchController?
    private var isSearchBarEmpty: Bool {
      return searchController?.searchBar.text?.isEmpty ?? true
    }
    private var refreshControl: UIRefreshControl?
    private var viewState: HomeViewState = .loading
    
    @IBOutlet weak var tvCounters: UITableView!
    @IBOutlet weak var lblCountersDetail: UILabel!
    @IBOutlet weak var btnAddToolbar: UIBarButtonItem!
    @IBOutlet weak var aiFetch: UIActivityIndicatorView!
    @IBOutlet weak var viewInsetMessage: InsetMessageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = HomeViewModel()
        self.viewModel.bindCounters = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateViewState(state: .hasContent)
            }
        }
        
        self.viewModel.bindFetchCountersError = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateViewState(state: .error)
            }
        }
        
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
        fetchCounters()
        
        //Search
        searchViewController = SearchCounterResultsViewController()
        searchViewController?.viewModel.counterInteractor = self.viewModel.counterInteractor
        
        searchController = UISearchController(searchResultsController: searchViewController)
        searchController?.searchResultsUpdater = searchViewController
        definesPresentationContext = true
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        //TODO: Change statusBar color, fix; status bar is overlapping navigation bar
        //navigationController?.setStatusBarColor(UIColor(appColor: .grayLight))
        self.navigationItem.title = UIText.homeNavTitle
        
        //Buttons
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Search
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        
        navigationItem.searchController = searchController
    }
    
    func fetchCounters(isRefresh: Bool = false) {
        updateViewState(state: isRefresh ? .refreshing : .loading)
        viewModel.fetchCounters()
    }
    
    func updateViewState(state: HomeViewState) {
        switch state {
        case .loading:
            tvCounters.alpha = CGFloat(0)
            viewInsetMessage.isHidden = true
            aiFetch.isHidden = false
            aiFetch.startAnimating()
        case .hasContent:
            tvCounters.alpha = CGFloat(1)
            viewInsetMessage.isHidden = true
            aiFetch.stopAnimating()
            refreshControl?.endRefreshing()
            tvCounters.reloadData()
            reloadCountersDetail()
        case .noContent, .error:
            setMessage()
            tvCounters.alpha = CGFloat(0)
            viewInsetMessage.isHidden = false
            aiFetch.stopAnimating()
            refreshControl?.endRefreshing()
            tvCounters.reloadData()
            reloadCountersDetail()
        case .refreshing:
            break
        }
    }
    
    func setMessage() {
        if let appError = self.viewModel.fetchError {
            if appError.id == .noData {
                self.viewInsetMessage.setUpView(insetMessage: .emptyCounters, delegate: self)
            } else {
                self.viewInsetMessage.setUpView(insetMessage: .error, delegate: self)
            }
        }
    }
    
    @objc func handleRefresh() {
        fetchCounters(isRefresh: true)
    }
    
    func reloadCountersDetail() {
        if viewModel.counters?.count ?? 0 > 0  && viewModel.fetchError == nil {
            lblCountersDetail.isHidden = false
            if let counted = viewModel.counters?.reduce(0, { $0 + $1.count}) {
                lblCountersDetail.text = "\(viewModel.counters!.count) items ᛫ Counted \(counted) times"
            }
        } else {
            lblCountersDetail.isHidden = true
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tvCounters.setEditing(editing, animated: true)
    }
    
    @objc func didTapAdd() {        
        if let createCounterVC = self.storyboard?
            .instantiateViewController(withIdentifier: "createCounterViewController") as? CreateCounterViewController {
            createCounterVC.viewModel.counterInteractor = self.viewModel.counterInteractor
            createCounterVC.delegate = self
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
        
        if let counter = viewModel.counters?[indexPath.row] {
            cell?.setData(indexAt: indexPath.row, counter: counter, interactor: viewModel.counterInteractor)
            cell?.delegate = self
        }
        
        return cell ?? UITableViewCell()
    }
}

extension HomeViewController: InsetMessageDelegate {
    func didTapActionButton() {
        if viewModel.fetchError?.id == .noData {
            didTapAdd()
        } else {
            fetchCounters()
        }
    }
}

extension HomeViewController: CounterCellViewDelegate {
    func countUpdated(atIndex: Int, newValue: Int) {
        viewModel.updateCounter(atIndex: atIndex, newValue: newValue)
    }
}

extension HomeViewController: CreateCounterDelegate {
    func counterCreated(counter: CounterModel.Counter) {
        viewModel.addCounter(counter: counter)
    }
}
