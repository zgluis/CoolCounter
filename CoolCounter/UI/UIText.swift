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
    
    static let homeNavTitle = "Counters"
    static let shareMultipleTitle = "Hey! Take a look at these counts:\n"
    static let createCounterNavTitle = "Create a counter"
    static let createCounterCaption = "Give it a name. Creative block? See examples."
    
    static let counterExamplesNavTitle = "Examples"
    
    static let errorCreateCounterFailedTitle = "Couln't create the counter"
    static let errorNetwork = "The Internet connection appears to be offline."
    static let btnDismiss = "Dismiss"
    static let btnCancel = "Cancel"
    static let btnSave = "Save"
    static let btnRetry = "Retry"
    static let btnSelectAll = "Select All"
    static let btnUnselectAll = "Unselect All"
    static let btnDelete = "Delete"

    static let messageEmptyCountersTitle = "No counters yet"
    static let messageEmptyCountersSubtitle = "\"When I started counting my blessings, my whole life turned around.\" —Willie Nelson"
    static let messageEmptyCountersButton = "Create a counter"
    
    static let messageErrorCountersTitle = "Couldn't load the counters"
    static let messageErrorCountersSubtitle = "The internet connection appears to be offline"
    static let messageErrorCountersButton = "Retry"
    
    static let errorStandard = "¡Ups! Something went wrong"
}
