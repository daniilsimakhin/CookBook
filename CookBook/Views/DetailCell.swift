//
//  DetailCell.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 03.12.2022.
//

import UIKit

// MARK: - Cell for recipeTableView in DetailViewController
class DetailCell: UITableViewCell{
    static let rowHeight: CGFloat = 100
    static let reuseID = String(describing: DetailCell.self)
    
    let networkLoader = NetworkLoader(networkClient: NetworkClient())
    
    // MARK: - UI Elements
    private let stackView = UIStackView()
    
    private let mainTextLabel = UILabel()
    private let timeLabel = UILabel()

    private var imageDetail = UIImageView()
    
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
extension DetailCell {
    private func setup() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.backgroundColor = Theme.cbYellow20
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
        
        mainTextLabel.numberOfLines = 0
        mainTextLabel.textAlignment = .right
        imageDetail.tintColor = Theme.cbYellow50
        imageDetail.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyStyle(){
        mainTextLabel.font = .systemFont(ofSize: 15, weight: .regular)
        timeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    
    private func layout() {
        stackView.addArrangedSubview(mainTextLabel)
        stackView.addArrangedSubview(timeLabel)
        contentView.addSubview(imageDetail)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: imageDetail.trailingAnchor, constant: 5),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            imageDetail.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageDetail.widthAnchor.constraint(equalToConstant: 50),
            imageDetail.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(ingredient: IngredientModel) {
        mainTextLabel.text = ingredient.original
        networkLoader.getIngredientImage(name: ingredient.image) { [weak self] image in
            self?.imageDetail.image = image
        }
    }
    
    func configure(recipeInstruction: InstructionModel){
        mainTextLabel.text = recipeInstruction.step
        timeLabel.text = "\(recipeInstruction.minutes) min"
        imageDetail.image = recipeInstruction.isChecked ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
    }
    
    override func prepareForReuse() {
        timeLabel.text = ""
    }
}
