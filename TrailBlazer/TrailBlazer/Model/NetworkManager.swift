//
//  NetworkManager.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-20.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func postData(url: URL, body: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}

