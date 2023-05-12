//
//  HTTPClient.swift
//  PadLock
//
//  Created by Alex Albu on 12.05.2023.
//

import Foundation

final class HTTPClient {
    static func get(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }

    static func post<T: Codable>(url: URL, body: T, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let jsonData = try? JSONEncoder().encode(body) else {
            completion(
                nil,
                nil,
                EncodingError.invalidValue(body, EncodingError.Context(codingPath: [], debugDescription: "The value was not found in the data."))
            )
            return
        }
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          completion(data, response, error)
        }
        task.resume()
    }
}

