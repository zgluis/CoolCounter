//
//  CounterCellView.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

class CounterCellView: UITableViewCell {
    
    private var viewModel: CounterCellViewModel?
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stpCount: UIStepper!
    @IBOutlet weak var viewContainer: UIView!
    
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
    }
    
    public func setData(counter: CounterModel.Counter, interactor: CounterBusinessLogic?) {
        self.viewModel = CounterCellViewModel(counter: counter, interactor: interactor)
        lblTitle.text = counter.title
        lblCount.text = counter.count.description
        stpCount.value = Double(counter.count)
        setCountColor(countValue: counter.count)
    }
    
    func setCountColor(countValue: Int) {
        lblCount.textColor = countValue == 0 ? UIColor(appColor: .silver) : UIColor(appColor: .accent)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let newValue = Int(sender.value)
        setCountColor(countValue: newValue)
        lblCount.text = newValue.description
        
        if newValue > viewModel?.stepperValue ?? 0 {
            viewModel?.incrementCount()
        } else {
            viewModel?.decrementCount()
        }
        
        viewModel?.stepperValue = newValue
    }
    
    class func createCell() -> CounterCellView? {
        let nib = UINib(nibName: "CounterCell", bundle: nil)
        let cell = nib.instantiate(withOwner: self, options: nil).last as? CounterCellView
        return cell
    }
    
}
