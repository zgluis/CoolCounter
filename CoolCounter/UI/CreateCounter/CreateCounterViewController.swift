//
//  CreateCounterViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

protocol CreateCounterDelegate: class {
    func counterCreated(counter: CounterModel.Counter)
}

class CreateCounterViewController: UIViewController {
    
    var viewModel: CreateCounterViewModel = CreateCounterViewModel()
    weak var delegate: CreateCounterDelegate?
    
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
        setupNavigationBar()
        viewModel.createCounterSucceeded = { [weak self] counter in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.delegate?.counterCreated(counter: counter)
                self.dismiss(animated: true)
            }
        }
        
        viewModel.createCounterError = { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: UIText.errorCreateCounterFailedTitle,
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
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
    
    private func setupNavigationBar() {
        self.navigationItem.title = UIText.createCounterNavTitle
        //Buttons
        let cancelBtn = UIBarButtonItem(title: UIText.btnCancel, style: .plain, target: self, action: #selector(didTapCancel(_:)))
        self.navigationItem.leftBarButtonItem = cancelBtn
        
        let saveBtn = UIBarButtonItem(title: UIText.btnSave, style: .plain, target: self, action: #selector(didTapSave(_:)))
        saveBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc private func textFieldTitleDidChange() {
        navigationItem.rightBarButtonItem?.isEnabled = tfCounterTitle.text?.count ?? 0 > 0
    }
    
    @objc private func didTapCaption(_ gesture: UITapGestureRecognizer) {
        //TODO: fix; underline text is not tappable in landscape mode
        /*if gesture.didTapAttributedTextInLabel(label: lblCaption, inRange: NSRange(location: 36, length: 8)) {
         navToExamples()
         }*/
        navToExamples()
    }
    
    func navToExamples() {
        if let counterExamplesVC = self.storyboard?
            .instantiateViewController(withIdentifier: "counterExamplesViewController") as? CounterExamplesViewController {
            if let navigator = navigationController {
                counterExamplesVC.delegate = self
                navigator.pushViewController(counterExamplesVC, animated: true)
            }
        }
    }
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        if tfCounterTitle.text != nil && !viewModel.isLoading {
            viewModel.createCounter(title: tfCounterTitle.text!)
        }
    }
    
    private func enableForm(_ enable: Bool) {
        tfCounterTitle.isEnabled = enable
        navigationItem.rightBarButtonItem?.isEnabled = enable
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension CreateCounterViewController: CounterExamplesViewDelegate {
    func userSelectedExample(title: String) {
        self.tfCounterTitle.text = title
        self.textFieldTitleDidChange()
    }
}
