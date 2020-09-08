//
//  UIColorExtensions.swift
//  CoolCounter
//
//  Created by Luis Zapata on 07-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import UIKit

enum AppColor {
    case silver
    case gray
    case grayLight
    case whitePearl
    case accent
}

extension UIColor {
    convenience init(appColor: AppColor) {
        switch appColor {
        case .silver:
            self.init(named: "SilverColor")!
        case .gray:
            self.init(named: "GrayColor")!
        case .grayLight:
            self.init(named: "GrayLightColor")!
        case .whitePearl:
            self.init(named: "WhitePearlColor")!
        case .accent:
            self.init(named: "AccentColor")!
        }
    }
}
