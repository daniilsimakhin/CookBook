//
//  UIViewController+Utils.swift
//  Bankey
//
//  Created by SERGEY SHLYAKHIN on 21.03.2022.
//

import UIKit

extension UIViewController {
    func setStatusBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = Theme.appColor
        navBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: Theme.cbNavBarTitleFont,
            NSAttributedString.Key.foregroundColor: Theme.cbGreen80
        ]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
