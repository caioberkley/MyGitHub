//
//  SceneDelegate.swift
//  MyGitHub
//
//  Created by Caio Berkley on 06/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let networkService = NetworkManager()
        let serviceViewModel = ServiceViewModel(networkService: networkService)
        let userSearchView = UserSearchView()
        window?.rootViewController = UserSearchViewController(serviceViewModel: serviceViewModel, userSearchView: userSearchView)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
