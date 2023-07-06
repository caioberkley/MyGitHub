//
//  UserSearchViewController.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import UIKit
import Kingfisher

class UserSearchViewController: UIViewController, ServiceViewModelOutput {
    
    let serviceViewModel: ServiceViewModel
    private let userSearchView: UserSearchView
    private let cache = KingfisherManager.shared.cache
    
    var searchView: UIStackView!
    var searchTextView: UITextField!
    var searchButton: UIButton!
    var collectionView: UICollectionView!
    var introLabel: UILabel!
    var userData = [User]()
    var currentPage: Int!
    
    init(serviceViewModel: ServiceViewModel, userSearchView: UserSearchView) {
        self.serviceViewModel = serviceViewModel
        self.userSearchView = userSearchView
        super.init(nibName: nil, bundle: nil)
        self.serviceViewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.cleanExpiredDiskCache()
    }
    
    fileprivate func viewSetup() {
        searchView = userSearchView.searchView
        searchTextView = userSearchView.searchTextView
        searchButton = userSearchView.searchButton
        collectionView = userSearchView.collectionView
        introLabel = userSearchView.mainLabel
        currentPage = Constants.page
        userData = []
        
        view.backgroundColor = UIColor(white: 1, alpha: 0.95)
        view.addSubview(searchView)
        view.addSubview(collectionView)
        view.addSubview(introLabel)
        
        searchView.addArrangedSubview(searchTextView)
        searchView.addArrangedSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(initiateSearch), for: .touchUpInside)
        searchTextView.addTarget(self, action: #selector(initiateSearch), for: .editingChanged)
        
        layOutConstraint()
        collectionViewSetup()
    }
    
    func updateViews(with data: [User]) {
        self.userData = data
        self.collectionView.reloadData()
        if self.userData.count < 1 {
            self.collectionView.isHidden = true
            self.introLabel.isHidden = false
            self.introLabel.text = "Sem resultados..."
        } else {
            self.introLabel.isHidden = true
            self.collectionView.isHidden = false
            self.introLabel.text = "Sucesso!"
            self.collectionView.reloadData()
        }
    }
    
    @objc func initiateSearch() {
        let searchQuery = searchTextView.text
        fetchUsers(searchQuery: searchQuery ?? "", page: currentPage)
    }
    
    func fetchUsers(searchQuery: String, page: Int) {
        serviceViewModel.fetchData(searchQuery: searchQuery, page: page)
    }
}

extension UserSearchViewController: UICollectionViewDataSource {
    
    func collectionViewSetup() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as? UserCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.populateCell(with: userData[indexPath.row])
        return cell
    }

}

extension UserSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController(user: userData[indexPath.row])
        present(vc, animated: true)
    }
    
}

extension UserSearchViewController {
    func layOutConstraint() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            searchView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            searchView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchTextView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 10),
            searchTextView.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            
            searchButton.leadingAnchor.constraint(equalTo: searchTextView.trailingAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 30),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            introLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
}

extension UserSearchViewController: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = view.frame.height
        if self.collectionView.panGestureRecognizer.translation(in: self.collectionView).y > height {
            refreshData()
        }
    }
    
    private func refreshData() {
        currentPage += 1
        Constants.page += 1
        Constants.per_page += 10
        initiateSearch()
        collectionView.reloadData()
        self.view.layoutIfNeeded()
    }

}
