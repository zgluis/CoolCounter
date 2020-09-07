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
        session.dataTask(with: URL(string: Config.baseURL + resource)!) { data, _, error in
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
    
    func post<T: Decodable>(resource: String,
                            parameters: [String: Any],
                            method: String = "POST",
                            completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: URL(string: Config.baseURL + resource)!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        #if DEBUG
        print("[Request] [\(method)]: \(parameters)")
        #endif
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else {
            #if DEBUG
            print("[Error] [\(method)]: Unserializable parameters")
            #endif
            completion(.failure(AppError(message: UIText.loremShort)))
            return
        }
        request.httpMethod = method
        request.httpBody = jsonData
        session.dataTask(with: request) { data, _, error in
            do {
                #if DEBUG
                if let data = data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("[Response] [\(method)]: \(utf8Text)")
                }
                #endif
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(AppError(message: UIText.loremShort)))
                    #if DEBUG
                    print("[Response] [\(method)]: nil")
                    #endif
                    return
                }
                
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedObject))
            } catch {
                #if DEBUG
                print("[Error] [\(method)]: \(error)")
                #endif
                completion(.failure(error))
            }
        }.resume()
    }
    
    func delete<T: Decodable>(resource: String, parameters: [String: Any], completion: @escaping (Result<T, Error>) -> Void) {
        self.post(resource: resource, parameters: parameters, method: "DELETE", completion: completion)
    }
    
}
