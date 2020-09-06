//
//  AppModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

/// Global structs to be used across the entire app

import Foundation

struct AppError: Error {
    /// User frendly message
    private let message: String
    var localizedDescription: String {
        return message
    }

    init(message: String) {
        self.message = message
    }
}
