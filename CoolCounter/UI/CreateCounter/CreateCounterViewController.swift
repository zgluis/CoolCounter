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
        viewModel.createCounterSucceeded = { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
        
        viewModel.createCounterError = { [weak self] error in
            guard let self = self else { return }
            let alert = UIAlertController(title: UIText.errorCreateCounterFailedTitle,
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)

            DispatchQueue.main.async {
                alert.view.tintColor = UIColor(appColor: .accent)
                alert.addAction(UIAlertAction(title: UIText.btnDismiss, style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        viewModel.isLoadingChanged = { [weak self] isLoading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.enableForm(!isLoading)
                if isLoading {
                    self.viewActivityIndicatorContainer.fadeIn()
                } else {
                    self.viewActivityIndicatorContainer.fadeOut()
                }
            }
        }
        
    }
    
    @objc private func textFieldTitleDidChange() {
        btnSave.isEnabled = tfCounterTitle.text?.count ?? 0 > 0
    }
    
    @objc private func didTapCaption(_ gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblCaption, inRange: NSRange(location: 36, length: 8)) {
            print("example tapped")
        }
    }
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        if tfCounterTitle.text != nil && !viewModel.isLoading {
            viewModel.createCounter(title: tfCounterTitle.text!)
        }
    }
    
    private func enableForm(_ enable: Bool) {
        tfCounterTitle.isEnabled = enable
        btnSave.isEnabled = enable
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
