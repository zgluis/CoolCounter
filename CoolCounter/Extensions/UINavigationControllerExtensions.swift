//
//  UINavigationControllerExtensions.swift
//  CoolCounter
//
//  Created by Luis Zapata on 07-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    @IBInspectable var backgroundColor: UIColor {
        get {
            return self.view.backgroundColor ?? UIColor.black
        }
        set {
            self.view.backgroundColor = newValue
        }
    }
    
    func setStatusBarColor(_ : UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }
    
}
