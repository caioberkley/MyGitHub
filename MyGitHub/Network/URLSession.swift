//
//  URLSession.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import Foundation

extension URLSession {
    
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            let responseData = try? newJSONDecoder().decode(T.self, from: data)
            completionHandler(responseData, response, nil)
        }
    }

    func task(with url: URL, completionHandler: @escaping (SearchResult?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
