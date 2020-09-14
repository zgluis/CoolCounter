//
//  UIFontExtensions.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont

        if #available(iOS 13.0, *) {
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                font = UIFont(descriptor: descriptor, size: size)
            } else {
                font = systemFont
            }
        } else {
            font = systemFont
        }

        return font
    }
}
