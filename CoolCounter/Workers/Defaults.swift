//
//  Defaults.swift
//  CoolCounter
//
//  Created by Luis Zapata on 11-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

class Defaults {
    private let def: UserDefaults
    init() {
        def = UserDefaults.standard
    }
    func set(key: DefaultsKeys, value: Any) {
        def.set(value, forKey: key.rawValue)
    }
    
    func getBool(key: DefaultsKeys) -> Bool {
        return def.bool(forKey: key.rawValue)
    }
}
