//
//  RequestHandler.swift
//  CoolCounter
//
//  Created by Luis Zapata on 05-09-20.
//  Copyright © 2020 Luis Zapata. All rights reserved.
//

import Foundation

let requestHandler = RequestHandler()

final class RequestHandler {
    
    private var session: URLSession
    
    required public init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func get<T: Decodable>(resource: String, completion: @escaping (Result<T, Error>) -> Void) {
        #if DEBUG
        print("[Request] [get]: \(Config.baseURL + resource)")
        #endif
        URLSession.shared.dataTask(with: URL(string: Config.baseURL + resource)!) { data, _, error in
            do {
                #if DEBUG
                if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("[Response] [get]: \(utf8Text)")
                }
                #endif
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(AppError(message: UIText.loremShort)))
                    #if DEBUG
                    print("[Response] [get]: nil")
                    #endif
                    return
                }
                
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedObject))
            } catch {
                #if DEBUG
                    print("[Error] [get]: \(error)")
                #endif
                completion(.failure(error))
            }
        }.resume()
    }
    
}
