//
//  CounterCellView.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

protocol CounterCellViewDelegate: class {
    func countUpdated(id: String, newValue: Int)
}

class CounterCellView: UITableViewCell {
    
    private var viewModel: CounterCellViewModel?
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stpCount: UIStepper!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var aiUpdate: UIActivityIndicatorView!
    @IBOutlet weak var constraintActivityIndicatorWidth: NSLayoutConstraint!
    
    weak var delegate: CounterCellViewDelegate?
    private var backgroundUpdated = false
    var counterId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContainer.layer.cornerRadius = 8
        
        // Work around to this issue: https://developer.apple.com/forums/thread/121495
        stpCount.setDecrementImage(stpCount.decrementImage(for: .normal), for: .normal)
        stpCount.setIncrementImage(stpCount.incrementImage(for: .normal), for: .normal)
        
        lblCount.font = .rounded(ofSize: 32, weight: .semibold)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected && !backgroundUpdated {
            let newBackgroundView = UIView()
            newBackgroundView.backgroundColor = UIColor(appColor: .grayLight)
            selectedBackgroundView = newBackgroundView
            backgroundUpdated = true
        }
    }
    
    @objc func showLoading() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.aiUpdate.startAnimating()
                self?.stpCount.isEnabled = false
                self?.aiUpdate.isHidden = false
                self?.constraintActivityIndicatorWidth.constant = CGFloat(20)
                self?.contentView.layoutIfNeeded()
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.stpCount.isEnabled = true
                self?.aiUpdate.isHidden = true
                self?.constraintActivityIndicatorWidth.constant = CGFloat(0)
                self?.contentView.layoutIfNeeded()
            }
        }
    }
    
    public func setData(indexAt: Int, counter: CounterModel.Counter, interactor: CounterBusinessLogic?) {
        self.viewModel = CounterCellViewModel(counter: counter, interactor: interactor)
        lblTitle.text = counter.title
        lblCount.text = counter.count.description
        refreshCountColor()
        stpCount.value = Double(counter.count)
        counterId = counter.id
        viewModel?.isLoadingChanged = { [weak self] isLoading in
            if isLoading {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    //Is still loading?
                    if self?.viewModel?.isLoading ?? false {
                        self?.showLoading()
                    }
                }
            } else {
                self?.hideLoading()
            }
        }
        
        viewModel?.incrementSucceeded = { [weak self] in
            self?.handleSuccess(isIncrement: true)
        }
        
        viewModel?.incrementError = { [weak self] error in
            self?.handleError(error: error, isIncrement: true)
        }
        
        viewModel?.decrementSucceeded = { [weak self] in
            self?.handleSuccess(isIncrement: false)
        }
        
        viewModel?.decrementError = { [weak self] error in
            self?.handleError(error: error, isIncrement: false)
        }
    }
    
    func handleSuccess(isIncrement: Bool) {
        DispatchQueue.main.async {
            let newValue = isIncrement ? self.getCurrentValue() + 1 : self.getCurrentValue() - 1
            self.lblCount.text = newValue.description
            self.refreshCountColor()
            if let id = self.counterId {
                self.delegate?.countUpdated(id: id, newValue: newValue)
            }
        }
    }
    
    func handleError(error: AppError, isIncrement: Bool) {
        DispatchQueue.main.async {
            let newValue = isIncrement ? self.getCurrentValue() + 1 : self.getCurrentValue() - 1
            let alert = UIAlertController(title: "Couldn't update the \(self.lblTitle.text ?? "") counter to \(newValue)",
                message: error.localizedDescription,
                preferredStyle: .alert)
            alert.view.tintColor = UIColor(appColor: .accent)
            //TODO: check if it would be better to swap the styles
            alert.addAction(UIAlertAction(title: UIText.btnRetry, style: .cancel, handler: { _ in
                if isIncrement {
                    self.viewModel?.incrementCount()
                } else {
                    self.viewModel?.decrementCount()
                }
            }))
            alert.addAction(UIAlertAction(title: UIText.btnDismiss, style: .default, handler: nil))
            self.parentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func refreshCountColor() {
        lblCount.textColor = getCurrentValue() == 0 ? UIColor(appColor: .silver) : UIColor(appColor: .accent)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender.value > Double(getCurrentValue()) {
            viewModel?.incrementCount()
        } else {
            viewModel?.decrementCount()
        }
    }
    
    func getCurrentValue() -> Int {
        return Int(lblCount.text ?? "0") ?? 0
    }
    
    class func createCell() -> CounterCellView? {
        let nib = UINib(nibName: "CounterCell", bundle: nil)
        let cell = nib.instantiate(withOwner: self, options: nil).last as? CounterCellView
        return cell
    }
    
}
