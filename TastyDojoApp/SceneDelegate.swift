//
//  SceneDelegate.swift
//  TastyDojoApp
//
//  Created by Михаил on 28.09.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let navVc = UINavigationController(rootViewController: RecipeListViewController(collectionViewLayout: layout))
        window.rootViewController = navVc
        window.makeKeyAndVisible()
        self.window = window
    }

   

}

