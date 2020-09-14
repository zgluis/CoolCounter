//
//  UIActivityViewControllerExtensions.swift
//  CoolCounter
//
//  Created by Luis Zapata on 13-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

extension UIActivityViewController {

    func setDefaultStyle(sourceView: UIView) {
        if let popoverController = self.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2,
                                                  y: UIScreen.main.bounds.height / 2,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        } else {

            self.isModalInPresentation = true
        }
        self.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading
    }
}
