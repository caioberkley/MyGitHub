//
//  UserCollectionViewCell.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import UIKit
import Kingfisher

class UserCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "userCollectionViewCell"
    private let viewLayout: UserCollectionView = UserCollectionView()
    private let serviceViewModel = ServiceViewModel(networkService: NetworkManager())
    
    var userView: UIStackView!
    var login: UILabel!
    var avatar: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell() {
        userView = viewLayout.userView
        login = viewLayout.loginLabel
        avatar = viewLayout.avatar
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 1
        contentView.addSubview(userView)
        userView.addArrangedSubview(login)
        userView.addArrangedSubview(avatar)
        
        NSLayoutConstraint.activate([
            userView.topAnchor.constraint(equalTo: contentView.topAnchor),
            userView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            userView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func populateCell(with data: User) {
        let loginText = data.login.lowercased().prefix(10)
        login.text = String(loginText)
        serviceViewModel.loadImage(with: data.avatarURL, imageView: avatar)
    }
}
