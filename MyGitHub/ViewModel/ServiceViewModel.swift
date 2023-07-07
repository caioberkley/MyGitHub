//
//  ServiceViewModel.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import Kingfisher
import UIKit

protocol ServiceViewModelOutput: AnyObject {
    func updateViews(with data: [User])
}

class ServiceViewModel {
    
    weak var output: ServiceViewModelOutput?
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func fetchData(searchQuery: String?, page: Int) {
        let query = searchQuery ?? "user"
        guard validateQuery(query: query) else {
            return
        }
        
        Constants.search_query = query
        Constants.page = page
        
        networkService.networkRequest { [weak self] result in
            switch result {
            case .success(let userData):
                let data = userData
                    .filter { $0.login.contains(query) }
                    .sorted { $0.login.lowercased() < $1.login.lowercased() }
                
                self?.output?.updateViews(with: data)
                
                Constants.total_page = data.count / Constants.per_page
                if data.count % Constants.per_page != 0 {
                    Constants.total_page += 1
                }
                
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }
    
    public func loadImage(with url: String, imageView: UIImageView?) {
        guard let imageView = imageView, let imageLink = URL(string: url) else {
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 50)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageLink,
            placeholder: UIImage(systemName: "person"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    public func loadDetailImage(with url: String, imageView: UIImageView?) {
        guard let imageView = imageView, let imageLink = URL(string: url) else {
            return
        }
        
        imageView.kf.setImage(with: imageLink)
    }
    
    private func validateQuery(query: String) -> Bool {
        return !query.isEmpty
    }
}
