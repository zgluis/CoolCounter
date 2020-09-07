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
        struct Request: AppRequest {
            let title: String
            func toParameters() -> [String: Any] {
                return ["title": title]
            }
        }
    }
    
    enum Increment {
        struct Request: AppRequest {
            let id: String
            func toParameters() -> [String: Any] {
                return ["id": id]
            }
        }
    }
    
    enum Decrement {
        struct Request: AppRequest {
            let id: String
            func toParameters() -> [String: Any] {
                return ["id": id]
            }
        }
    }
    
    enum Delete {
        struct Request: AppRequest {
            let id: String
            func toParameters() -> [String: Any] {
                return ["id": id]
            }
        }
    }
}
