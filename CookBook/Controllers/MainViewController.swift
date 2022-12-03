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
        searchVC.setTabBarImage(imageName: "magnifyingglass", title: "search")

        let popularNC = UINavigationController(rootViewController: popularVC)
        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        let searchNC = UINavigationController(rootViewController: searchVC)
        
        let tabBarList = [popularNC, favoriteNC, searchNC]

        viewControllers = tabBarList
    }

    private func setupTabBar() {
        tabBar.tintColor = Theme.appColor
        tabBar.isTranslucent = false
    }
}

// TODO: - далее разделить на файлы

final class FavoriteViewController: UIViewController {
    private let startButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        view.backgroundColor = .systemOrange
        startButton.setTitle("Recipe", for: [])
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .primaryActionTriggered)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func startButtonTapped(_ sender: UIButton) {
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

final class DetailViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemGreen
    }
}
