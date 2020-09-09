//
//  CounterExampleItem.swift
//  CoolCounter
//
//  Created by Luis Zapata on 09-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

protocol CounterExampleDelegate: class {
    func didTapExample(title: String)
}

class CounterExampleItem: UIView {

    @IBOutlet weak var btnItem: UIButton!
    weak var delegate: CounterExampleDelegate?
    
    static func instantiate(title: String, delegate: CounterExampleDelegate) -> CounterExampleItem? {
        let view: CounterExampleItem? = initFromNib()
        view?.btnItem.setTitle(title, for: .normal)
        view?.delegate = delegate
        return view
    }
    
    @IBAction func didTapExample(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            delegate?.didTapExample(title: title)
        }
    }
    
}
