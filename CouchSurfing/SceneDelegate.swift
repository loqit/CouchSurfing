//
//  SceneDelegate.swift
//  CouchSurfing
//
//  Created by Андрей Бобр on 17.10.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var uniqueTag = UniqueTag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = createTabBarController()
    }
    
    private func createController(_ viewController: UIViewController,
                                  title: String = "",
                                  barItem: UITabBarItem.SystemItem) -> UINavigationController {
        viewController.title = title
        let tag = uniqueTag.getUniqueTag()
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: barItem, tag: tag)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .black
        let mainVC = createController(MainViewController(), title: "Home", barItem: .search)
        tabBar.viewControllers = [mainVC]
        
        return tabBar
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

