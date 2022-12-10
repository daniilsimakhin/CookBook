//
//  Theme.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 30.10.2022.
//

import UIKit

enum Theme {
    // MARK: - Fonts
    enum Fonts {
        static let cbNavBarTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .title2).bold().withSize(23)
        static let cbOnboardingTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle).bold().withSize(32)
        static let cbOnboardingLableFont: UIFont = UIFont.preferredFont(forTextStyle: .title3).withSize(16)
        static let cbOnboardingButtonTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .title1).bold().withSize(16)
        static let cbRecipeTitleSmall: UIFont = .preferredFont(forTextStyle: .headline)
        static let cbRecipeTitle: UIFont = .preferredFont(forTextStyle: .title3)
    }
    // MARK: - Symbol Configuration
    static let mediumConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .medium)
    
    // MARK: - Colors

    static let appColor: UIColor = UIColor(named: "cbApp")!
    static let cbWhite: UIColor = UIColor(named: "cbWhite")!
    static let cbGreen50: UIColor = UIColor(named: "cbGreen50")!
    static let cbGreen80: UIColor = UIColor(named: "cbGreen80")!
    static let cbYellow20: UIColor = UIColor(named: "cbYellow20")!
    static let cbYellow50: UIColor = UIColor(named: "cbYellow50")!
    static let cbText100: UIColor = UIColor(named: "cbMono100")!
    
    static let grassColor: UIColor = UIColor(named: "Grass")!
    static let peachColor: UIColor = UIColor(named: "Peach")!
    static let beigeColor: UIColor = UIColor(named: "Beige")!
    static let orangeColor: UIColor = UIColor(named: "Orange")!
    static let blackColor: UIColor = .black
    
    static let shadowColor: UIColor = UIColor(red: 255/255, green: 100/255, blue: 51/255, alpha: 0.29)
    // MARK: - Style
    static let buttonCornerRadius: CGFloat = 15
    static let imageCornerRadius: CGFloat = 20
    
    // MARK: - Layout
    static let spacing: CGFloat = 20
    static let leftOffset: CGFloat = 20
    static let topOffset: CGFloat = 10
}
