//
//  DetailCell.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 03.12.2022.
//

import UIKit

// MARK: - Cell for recipeTableView in DetailViewController
class DetailCell: UITableViewCell{
    // MARK: - UI Elements
    static let reuseID = String(describing: DetailCell.self)
    
    private let stackView = UIStackView()
    
    private let mainTextLabel = UILabel()
    private let timeLabel = UILabel()

    private var imageDetail = UIImageView()
    
    // MARK: - Setters
    var textInCell: String? {
        didSet { mainTextLabel.text = textInCell ?? "" }
    }
    
    var timeInCell: String? {
        didSet { timeLabel.text = timeInCell ?? "" }
    }
    
    var imageInCell: UIImage? {
        didSet { imageDetail.image = imageInCell ?? UIImage()}
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style, layout and configuration
extension DetailCell {
    
    private func setup() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        mainTextLabel.numberOfLines = 0
        imageDetail.tintColor = .black
        stackView.alignment = .center
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout() {
        stackView.addArrangedSubview(imageDetail)
        stackView.addArrangedSubview(mainTextLabel)
        stackView.addArrangedSubview(timeLabel)
        NSLayoutConstraint.activate([
            imageDetail.widthAnchor.constraint(equalToConstant: 40),
            imageDetail.heightAnchor.constraint(equalToConstant: 40)

        ])
        contentView.addSubview(stackView)
    }
    
    func configure(ingredient: IngredientModel) {
        mainTextLabel.text = ingredient.title
        imageDetail.image = ingredient.picture
        timeLabel.text = ""
    }
    
    func configure(recipeInstruction: RecipeViewModel){
        mainTextLabel.text = recipeInstruction.recipeInstruction.step
        timeLabel.text = String(recipeInstruction.recipeInstruction.minutes) + " min"
        imageDetail.image = recipeInstruction.isChecked ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
    }
}
