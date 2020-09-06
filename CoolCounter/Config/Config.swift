//
//  Config.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

#if DEV_BUILD
let devBuild = true
#else
let devBuild = false
#endif

struct Config {
    
    private struct Domains {
        static let production = "http://192.168.0.0:3000"
        static let dev = "http://192.168.0.8:3000"
    }
    
    struct Routes {
        static let api = "/api/v1/"
    }
    
    static var baseURL = devBuild ? Domains.dev + Routes.api : Domains.production + Routes.api
}
