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
    
    private lazy var searchView: UIStackView = userSearchView.searchView
    private lazy var searchTextView: UITextField = userSearchView.searchTextView
    private lazy var searchButton: UIButton = userSearchView.searchButton
    private lazy var collectionView: UICollectionView = userSearchView.collectionView
    private lazy var introLabel: UILabel = userSearchView.mainLabel
    private lazy var currentPage: Int = Constants.page
    private lazy var userData: [User] = []
    
    private let refreshControl = UIRefreshControl()
    
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
        setupRefreshControl()
    }
    
    func updateViews(with data: [User]) {
        userData = data
        collectionView.reloadData()
        collectionView.isHidden = userData.isEmpty
        introLabel.isHidden = !userData.isEmpty
        introLabel.text = userData.isEmpty ? "Sem resultados..." : "Sucesso!"
        refreshControl.endRefreshing()
    }
    
    func clearSearch() {
            searchTextView.text = ""
            searchTextView.placeholder = "Pesquisa limpa!"
            userData = []
            collectionView.reloadData()
            collectionView.isHidden = userData.isEmpty
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
        if collectionView.panGestureRecognizer.translation(in: collectionView).y > height {
            refreshData()
        }
    }
    
    private func refreshData() {
        currentPage += 1
        Constants.page += 1
        Constants.per_page += 10
        initiateSearch()
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
}

// MARK: - Pull-to-Refresh
extension UserSearchViewController {
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .black
    }
    
    @objc private func refresh() {
        currentPage = Constants.page
        clearSearch()
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
}
