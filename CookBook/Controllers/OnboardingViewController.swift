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

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Cooking")
        return imageView
    }()
    private let startButton = UIButton()
    
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
        view.backgroundColor = #colorLiteral(red: 0.9977220893, green: 0.7536674142, blue: 0.6296645999, alpha: 1)
        startButton.setTitle("  Get the recipes  ", for: [])
        startButton.layer.borderWidth = 3
        startButton.layer.cornerRadius = 10
        startButton.layer.borderColor = #colorLiteral(red: 0.1421098113, green: 0.5987231135, blue: 0.4971868992, alpha: 1)
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 35)
        startButton.setTitleColor(#colorLiteral(red: 0.9977220893, green: 0.7536674142, blue: 0.6296645999, alpha: 1), for: .normal)
    }
    
    private func applyLayout() {
        [backgroundImageView, startButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
