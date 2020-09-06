//
//  UIText.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

/// Struct to centralize UI texts, this makes easier to implement localization

struct UIText {
    
    // Lorem texts for testing
    static let loremShort = "Lorem ipsum"
    static let loremMedium = "Vestibulum varius tristique sagittis"
    static let loremLong = """
                            Nunc mattis diam vitae dui maximus bibendum sit amet tincidunt orci. \
                            Vivamus vitae consequat diam, et efficitur metus
                           """
    static let loremXLong = """
                            Quisque porta porttitor augue elementum consectetur. Aliquam erat volutpat. \
                            Sed faucibus porttitor placerat. Mauris nec mauris ullamcorper, sodales mauris \
                            non, ultricies augue. Maecenas eu diam quis velit efficitur eleifend.
                            """
}
