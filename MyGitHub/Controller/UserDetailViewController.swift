//
//  UserDetailViewController.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import UIKit

class DetailViewController: UIViewController {

    private var detailViewLayout: UserDetailView!
    private var serviceViewModel: ServiceViewModel!
    private var networkService: NetworkService!
    
    private var container: UIStackView!
    private var login: UILabel!
    private var avatar: UIImageView!
    
    var user: User
    
    init(user: User) {
        self.user = user
        self.detailViewLayout = UserDetailView()
        self.networkService = NetworkManager()
        self.serviceViewModel = ServiceViewModel(networkService: networkService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    private func setupView() {
        container = detailViewLayout.container
        login = detailViewLayout.login
        avatar = detailViewLayout.avatar
        populateView()
    }
    
    private func setupLayout() {
        view.addSubview(container)
        container.addArrangedSubview(login)
        container.addArrangedSubview(avatar)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }

    
    func populateView() {
        login.text = user.login
        serviceViewModel?.loadDetailImage(with: user.avatarURL, imageView: avatar)
    }
}
