//
//  CounterModel.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

enum CounterModel {
    
    // MARK: - General
    struct Counter: Codable {
        let id: String
        let title: String
        let count: Int
    }
    
    // MARK: - Specifics
    enum Create {
        struct Request {
            let title: String
        }
    }
    
    enum Increment {
        struct Request {
            let id: String
        }
    }
    
    enum Decrement {
        struct Request {
            let id: String
        }
    }
    
    enum Delete {
        struct Request {
            let id: String
        }
    }
}
