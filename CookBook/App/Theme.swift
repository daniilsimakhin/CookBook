//
//  Theme.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 30.10.2022.
//

import UIKit

enum Theme {
    // MARK: - Fonts
    static let cbNavBarTitleFont: UIFont = UIFont.preferredFont(forTextStyle: .headline).withSize(23)
    
    // MARK: - Colors
    //static let appColor: UIColor = .systemTeal
    static let appColor: UIColor = UIColor(named: "cbWhite")!
    static let cbGreen50: UIColor = UIColor(named: "cbGreen50")!
    static let cbGreen80: UIColor = UIColor(named: "cbGreen80")!
    static let cbYellow20: UIColor = UIColor(named: "cbYellow20")!
    static let cbYellow50: UIColor = UIColor(named: "cbYellow50")!
    
    static let grassColor: UIColor = UIColor(named: "Grass")!
    static let peachColor: UIColor = UIColor(named: "Peach")!
    static let beigeColor: UIColor = UIColor(named: "Beige")!
    static let orangeColor: UIColor = UIColor(named: "Orange")!
    
    // MARK: - Style
    static let buttonCornerRadius: CGFloat = 15
    static let imageCornerRadius: CGFloat = 20
    
    // MARK: - Layout
    static let spacing: CGFloat = 20
    static let leftOffset: CGFloat = 20
    static let topOffset: CGFloat = 10
}
