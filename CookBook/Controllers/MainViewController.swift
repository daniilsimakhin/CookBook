//
//  MainViewController.swift
//  Bankey
//
//  Created by SERGEY SHLYAKHIN on 28.11.2022.
//

import UIKit

final class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }
}

extension MainViewController {
    private func setupViews() {
        let popularVC = PopularViewController()
        let favoriteVC = FavoriteViewController()
        let searchVC = SearchViewController()

        popularVC.setTabBarImage(imageName: "star.fill", title: "popular")
        favoriteVC.setTabBarImage(imageName: "heart.fill", title: "favorite")
        searchVC.setTabBarImage(imageName: "magnifyingglass", title: "discover")

        let popularNC = UINavigationController(rootViewController: popularVC)
        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        let searchNC = UINavigationController(rootViewController: searchVC)
        
        let tabBarList = [popularNC, favoriteNC, searchNC]

        viewControllers = tabBarList
    }

    private func setupTabBar() {
        tabBar.clipsToBounds = true
        tabBar.tintColor = Theme.cbGreen50
        tabBar.unselectedItemTintColor = Theme.cbYellow50
        tabBar.isTranslucent = false
    }
}
