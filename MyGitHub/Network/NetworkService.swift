//
//  NetworkService.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import Foundation

protocol NetworkService {
    func networkRequest(completionHandler: @escaping (Result<[User], Error>) -> Void)
}

final class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    
    func networkRequest(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: Constants.getURL()) else { return }
        let task = URLSession.shared.task(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    completionHandler(.success(data.items))
                }
            }
            if let error = error {
                completionHandler(.failure(NSError()))
                print("Error is : ", error)
            }
        }
        task.resume()
    }
}
