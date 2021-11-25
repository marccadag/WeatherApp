//
//  NetworkManager.swift
//  Clima
//
//  Created by Marc Cadag on 10/18/21.
//

import Foundation

enum NetworkError: Error {
    case failedToDecode
    case invalidURL
    case invalidData
}

class NetworkManager {
    func fetchData<T: Decodable>(urlString: String, _ type: T.Type, onCompletion: @escaping (T) -> Void, onError: @escaping (NetworkError) -> Void) {
        guard let url = URL(string: urlString) else {
            onError(.invalidURL)
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let safeData = data else {
                onError(.invalidData)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(type.self, from: safeData)
                onCompletion(result)
            } catch {
                onError(.failedToDecode)
            }
        }
        
        task.resume()
    }
}

