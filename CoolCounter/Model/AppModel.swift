//
//  AppModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 06-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

/// Global structs to be used across the entire app

import Foundation

protocol AppRequest {
    func toParameters() -> [String: Any]
}

enum AppErrorId {
    case standard
    case noData
    case network
    case coreData
}

struct AppError: Error {
    
    let id: AppErrorId
    /// User frendly message
    private let message: String
    var localizedDescription: String {
        return message
    }

    init(id: AppErrorId = .standard, message: String = UIText.errorStandard) {
        self.id = id
        self.message = message
    }
}
