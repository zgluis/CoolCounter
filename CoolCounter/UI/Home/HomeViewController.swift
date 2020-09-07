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
    
    @IBOutlet weak var tvCounters: UITableView!
    @IBOutlet weak var lblCountersDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = UIText.loremShort
        
        let newBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapEdit))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = newBtn//self.navigationItem.leftBarButtonItems = [newBtn,anotherBtn]
        
        self.viewModel = HomeViewModel()
        self.viewModel.bindCounters = {
            DispatchQueue.main.async {
                self.tvCounters.reloadData()
                self.reloadCountersDetail()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tvCounters.register(UINib.init(nibName: "CounterCellView", bundle: nil), forCellReuseIdentifier: "counterCell")
        self.tvCounters.delegate = self
        self.tvCounters.dataSource = self
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
