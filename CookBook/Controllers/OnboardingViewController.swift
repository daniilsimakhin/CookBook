//
//  OnboardingViewController.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 28.11.2022.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingViewController: UIViewController {
    private let mainStackView = UIStackView()
    private let labelsStackView = UIStackView()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Onboarding")
        return imageView
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Theme.cbYellow50
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 0, right: 5)
        button.setTitle("Get the recipes", for: [])
        button.titleLabel?.font = Theme.Fonts.cbOnboardingButtonTitleFont
        button.setTitleColor(Theme.appColor, for: .normal)
        button.layer.cornerRadius = 8
        
        button.layer.shadowColor = Theme.shadowColor.cgColor
        button.layer.shadowOffset = Theme.shadowOffset
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = Theme.shadowRadius
        
        button.layer.masksToBounds = false
        return button
    }()
    
    private let screenLabel1: UILabel = {
        let label = UILabel()
        label.text = "Happy cooking!"
        label.textColor = Theme.cbGreen80
        label.font = Theme.Fonts.cbOnboardingTitleFont
        return label
    }()
    
    private let screenLabel2: UILabel = {
        let label = UILabel()
        label.text =
        """
        Discover millions of fun recipes
        exclusive in Cooksy Dance.
        """
        label.numberOfLines = 2
        label.textColor = Theme.cbGreen80
        label.font = Theme.Fonts.cbOnboardingLableFont
        return label
    }()
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
    }
}

extension OnboardingViewController {
    private func setup() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .primaryActionTriggered)
    }
    
    private func applyStyle() {
        view.backgroundColor = Theme.appColor
    }
    
    private func applyLayout() {
        arrangeStackView(
            for: labelsStackView,
               subviews: [screenLabel1, screenLabel2],
               spacing: 10,
               axis: .vertical,
               aligment: .leading
        )
        
        arrangeStackView(
            for: mainStackView,
               subviews: [labelsStackView, startButton],
               spacing: 30,
               axis: .vertical,
               aligment: .leading
        )
        
        [backgroundImageView, mainStackView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -44),

            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.widthAnchor.constraint(equalToConstant: 141),
        ])
    }
    
    private func arrangeStackView(
        for stackView: UIStackView,
        subviews: [UIView],
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        aligment: UIStackView.Alignment = .fill
    ) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = aligment
        
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(item)
        }
    }
}

// MARK: - Actions
extension OnboardingViewController {
    @objc func startButtonTapped(_ sender: UIButton) {
        
        let dataProvider = RecipesProviderImpl()
        dataProvider.loadRecipes { result in
            switch result {
            case let .success(model):
                print(model.recipes[0].title)
                print(model.recipes[0].readyInMinutes)
                print(model.recipes[0].image)
                print(model.recipes[0].instructions)
            case let .failure(error):
                print(error)
            }
        }
        delegate?.didFinishOnboarding()
    }
}
