//
//  WelcomeViewController.swift
//  CoolCounter
//
//  Created by Luis Zapata on 13-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var btnContinue: UIButton! {
        didSet {
            btnContinue.layer.cornerRadius = 8
            btnContinue.titleEdgeInsets = UIEdgeInsets(top: -16, left: -16, bottom: -16, right: -16)
            btnContinue.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    @IBOutlet weak var viewAddIconContainer: UIView! {
        didSet {
            viewAddIconContainer.layer.cornerRadius = 8
            viewAddIconContainer.layer.borderWidth = CGFloat(1)
            viewAddIconContainer.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.05)
        }
    }
    @IBOutlet weak var viewCountIconContainer: UIView! {
        didSet {
            viewCountIconContainer.layer.cornerRadius = 8
            viewCountIconContainer.layer.borderWidth = CGFloat(1)
            viewCountIconContainer.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.05)
        }
    }
    @IBOutlet weak var viewThoughtsIconContainer: UIView! {
        didSet {
            viewThoughtsIconContainer.layer.cornerRadius = 8
            viewThoughtsIconContainer.layer.borderWidth = CGFloat(1)
            viewThoughtsIconContainer.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.05)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapContinue(_ sender: Any) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let rootNavController = mainStoryBoard.instantiateViewController(withIdentifier: "mainNavController")
            as? UINavigationController {
            rootNavController.navigationBar.barStyle = .default
            rootNavController.modalPresentationCapturesStatusBarAppearance = true
            UIApplication.shared.windows.first?.rootViewController = rootNavController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }

}
