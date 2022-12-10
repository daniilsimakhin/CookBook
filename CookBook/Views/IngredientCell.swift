//
//  IngredientCell.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 09.12.2022.
//

import UIKit

// MARK: - Cell for recipeTableView in DetailViewController
class IngredientCell: UITableViewCell{
    static let rowHeight: CGFloat = 100
    static let reuseID = String(describing: IngredientCell.self)
    
    let networkLoader = NetworkLoader(networkClient: NetworkClient())
    
    // MARK: - UI Elements
    private let ingredientView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.cbYellow20
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageIngredient = UIImageView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        applyStyle()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style, layout and configuration
extension IngredientCell {
    private func setup() {
    }
    
    private func applyStyle(){
        imageIngredient.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        ingredientView.addSubview(mainTextLabel)
        contentView.addSubview(imageIngredient)
        contentView.addSubview(ingredientView)
        NSLayoutConstraint.activate([
            ingredientView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            ingredientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ingredientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            ingredientView.leadingAnchor.constraint(equalTo: imageIngredient.trailingAnchor, constant: 10),
            ingredientView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            mainTextLabel.centerXAnchor.constraint(equalTo: ingredientView.centerXAnchor),
            mainTextLabel.centerYAnchor.constraint(equalTo: ingredientView.centerYAnchor),
            mainTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: ingredientView.trailingAnchor, constant: -10),
            mainTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: ingredientView.leadingAnchor, constant: 10),

            
            imageIngredient.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageIngredient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageIngredient.widthAnchor.constraint(equalToConstant: 50),
            imageIngredient.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(ingredient: IngredientModel) {
        mainTextLabel.text = ingredient.original
        networkLoader.getIngredientImage(name: ingredient.image) { [weak self] image in
            self?.imageIngredient.image = image
        }
    }
}
