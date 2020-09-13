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
    private var refreshControl: UIRefreshControl?
    private var viewState: HomeViewState = .loading
    
    @IBOutlet weak var tvCounters: UITableView!
    @IBOutlet weak var lblCountersDetail: UILabel!
    @IBOutlet weak var btnAddToolbar: UIBarButtonItem!
    @IBOutlet weak var aiFetch: UIActivityIndicatorView!
    @IBOutlet weak var viewInsetMessage: InsetMessageView!
    @IBOutlet weak var toolbarEdit: UIToolbar!
    @IBOutlet weak var toolbarAdd: UIToolbar!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
    private lazy var btnSelectAll = UIBarButtonItem(title: UIText.btnSelectAll, style: .plain, target: self,
                                                       action: #selector(didTapSelectAll(sender:)))
    private lazy var btnUnselectAll = UIBarButtonItem(title: UIText.btnUnselectAll, style: .plain, target: self,
                                                    action: #selector(didTapSelectAll(sender:)))
    private var didSelectAllRows = false
    
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
            navigationItem.leftBarButtonItem?.isEnabled = false
        case .hasContent:
            tvCounters.alpha = CGFloat(1)
            viewInsetMessage.isHidden = true
            aiFetch.stopAnimating()
            refreshControl?.endRefreshing()
            let selectedRows = tvCounters.indexPathsForSelectedRows
            tvCounters.reloadData()
            selectedRows?.forEach({ (selectedRow) in
                tvCounters.selectRow(at: selectedRow, animated: false, scrollPosition: .none)
            })
            reloadCountersDetail()
            navigationItem.leftBarButtonItem?.isEnabled = true
        case .noContent, .error:
            setMessage()
            tvCounters.alpha = CGFloat(0)
            viewInsetMessage.isHidden = false
            aiFetch.stopAnimating()
            refreshControl?.endRefreshing()
            tvCounters.reloadData()
            reloadCountersDetail()
            navigationItem.leftBarButtonItem?.isEnabled = false
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
        toolbarAdd.isHidden = editing
        toolbarEdit.isHidden = !editing
        if editing {
            btnShare.isEnabled = false
            btnDelete.isEnabled = false
            didSelectAllRows = false
            navigationItem.rightBarButtonItem = btnSelectAll
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
}

// MARK: Toolbars controlls
extension HomeViewController {
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
    
    @IBAction func didTapDelete(_ sender: Any) {
        
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        if tvCounters.indexPathsForSelectedRows == nil || tvCounters.indexPathsForSelectedRows!.count < 1 {
           return
        }
        var shareItems: [String] = []
        if tvCounters.indexPathsForSelectedRows!.count > 1 {
            shareItems.append(UIText.shareMultipleTitle)
            for indexPath in tvCounters.indexPathsForSelectedRows! {
                if let cell = tvCounters.cellForRow(at: indexPath) as? CounterCellView,
                    let title = cell.lblTitle.text,
                    let count = cell.lblCount.text {
                    shareItems.append("· \(count) x \(title)")
                }
            }
        } else {
            if let cell = tvCounters.cellForRow(at: tvCounters.indexPathsForSelectedRows!.first!) as? CounterCellView,
                    let title = cell.lblTitle.text,
                    let count = cell.lblCount.text {
                    shareItems.append("\(count) x \(title)")
            }
        }
                
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: shareItems,
                                                                                        applicationActivities: nil)
        activityViewController.setDefaultStyle(sourceView: self.view)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func refreshEditButtons() {
        btnShare.isEnabled = tvCounters.indexPathsForSelectedRows?.count ?? 0 > 0
        btnDelete.isEnabled = btnShare.isEnabled
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        refreshEditButtons()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        refreshEditButtons()
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

extension HomeViewController {
    @objc func didTapSelectAll(sender: UIBarButtonItem) {
        didSelectAllRows = !didSelectAllRows
        print("didSelectAllRows: \(didSelectAllRows)")
        if didSelectAllRows {
            navigationItem.rightBarButtonItem = btnUnselectAll
            for row in 0..<tvCounters.numberOfRows(inSection: 0) {
                tvCounters.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
            }
        } else {
            navigationItem.rightBarButtonItem = btnSelectAll
            for row in 0..<tvCounters.numberOfRows(inSection: 0) {
                tvCounters.deselectRow(at: IndexPath(row: row, section: 0), animated: false)
            }
        }
        refreshEditButtons()
    }
}
