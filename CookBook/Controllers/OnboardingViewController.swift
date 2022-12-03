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
        imageView.image = UIImage(named: "Onboarding")
        return imageView
    }()
    private let startButton = UIButton()
    
    private let screenLabel1: UILabel = {
        let label = UILabel()
        label.text = "Happy cooking!"
        label.textColor = Theme.grassColor
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
    
    private let screenLabel2: UILabel = {
        let label = UILabel()
        label.text = """
Discover millions of recipes
ecxlusive in Cooksy Dance.
"""
        label.numberOfLines = 2
        label.textColor = Theme.grassColor
        label.font = .boldSystemFont(ofSize: 20)
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
        view.backgroundColor = Theme.beigeColor
        startButton.setTitle("  Get the recipes  ", for: [])
        startButton.layer.borderWidth = 3
        startButton.layer.cornerRadius = 10
        startButton.layer.borderColor = Theme.orangeColor.cgColor
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        startButton.layer.backgroundColor = Theme.orangeColor.cgColor
        startButton.setTitleColor(.white, for: .normal)
    }
    
    private func applyLayout() {
        [backgroundImageView, startButton, screenLabel1, screenLabel2].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            
            screenLabel2.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -40),
            screenLabel2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            screenLabel1.bottomAnchor.constraint(equalTo: screenLabel2.topAnchor, constant: -15),
            screenLabel1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
            
            
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
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        let listVC = OnboardingViewController()
        func makeUIViewController(context:
                                  UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> OnboardingViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController:
                                    ListProvider.ContainterView.UIViewControllerType, context:
                                    UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
        }
    }
}
