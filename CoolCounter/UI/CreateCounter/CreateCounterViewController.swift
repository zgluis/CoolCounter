//
//  CreateCounterViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

class CreateCounterViewController: UIViewController {
    
    private var viewModel: CreateCounterViewModel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var viewActivityIndicatorContainer: UIView! {
        didSet {
            viewActivityIndicatorContainer.applyHorizontalGradient(colours:
                [UIColor.white.withAlphaComponent(0), UIColor(appColor: .whitePearl)])
        }
    }
    
    @IBOutlet weak var tfCounterTitle: UITextField! {
        didSet {
            tfCounterTitle.layer.cornerRadius = 8
            tfCounterTitle.addPadding(.both(16))
            tfCounterTitle.becomeFirstResponder()
            tfCounterTitle.addTarget(self, action: #selector(textFieldTitleDidChange), for: .editingChanged)
        }
    }
    
    //@IBOutlet weak var tvCaption: UITextView!
    @IBOutlet weak var lblCaption: UILabel! {
        didSet {
            let attributedCaption = NSMutableAttributedString(string: UIText.createCounterCaption)
            attributedCaption.addAttribute(NSAttributedString.Key.underlineStyle,
                                           value: NSUnderlineStyle.single.rawValue,
                                           range: NSRange(location: 36, length: 8))

            lblCaption.attributedText = attributedCaption
            lblCaption.isUserInteractionEnabled = true
            lblCaption.lineBreakMode = .byWordWrapping
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapCaption(_:)))
            tapGesture.numberOfTouchesRequired = 1
            lblCaption.addGestureRecognizer(tapGesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CreateCounterViewModel()
        
        viewModel.createCounterSucceeded.bind { success in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
        
        viewModel.createCounterError.bind { (_) in
            self.tfCounterTitle.isEnabled = true
            //TODO: show error
        }
        
    }
    
    @objc func textFieldTitleDidChange() {
        btnSave.isEnabled = tfCounterTitle.text?.count ?? 0 > 0
    }
    
    @objc func didTapCaption(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblCaption, inRange: NSRange(location: 36, length: 8)) {
            print("example tapped")
        }
    }
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        if let title = tfCounterTitle.text {
            tfCounterTitle.isEnabled = false
            viewModel.createCounter(title: title)
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
