//
//  InstructionCell.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 09.12.2022.
//

import UIKit

// MARK: - Cell for recipeTableView in DetailViewController
class InstructionCell: UITableViewCell{
    static let rowHeight: CGFloat = 100
    static let reuseID = String(describing: InstructionCell.self)
    
    let imageChecked = UIImage(systemName: "checkmark.square", withConfiguration: Theme.mediumConfiguration)
    let imageUnchecked = UIImage(systemName: "square", withConfiguration: Theme.mediumConfiguration)
    
    private var isChecked = false
    
    let networkLoader = NetworkLoader(networkClient: NetworkClient())
    
    // MARK: - UI Elements
    private let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.cbYellow20
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.cbBodyFont
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timeButton: UIButton = {
        let button = UIButton()
        var clockImage: UIImage? = {
            let config = UIImage.SymbolConfiguration(font: Theme.Fonts.cbSmallButtonFont)
            let image = UIImage(systemName: "clock", withConfiguration: config)
            return image
        }()
        button.setImage(clockImage, for: .normal)
        button.tintColor = Theme.cbWhite
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 10)
        button.setTitleColor(Theme.cbWhite, for: .normal)
        button.backgroundColor = Theme.cbGreen50
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = Theme.Fonts.cbSmallButtonFont
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        //view.addTarget(self, action: #selector(timeButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        applyStyle()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style, layout and configuration
extension InstructionCell {
    private func applyStyle(){
        timeButton.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    private func layout() {
        cellView.addSubview(mainTextLabel)
        contentView.addSubview(timeButton)
        contentView.addSubview(cellView)
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cellView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            mainTextLabel.topAnchor.constraint(greaterThanOrEqualTo: cellView.topAnchor, constant: 10),
            mainTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: cellView.bottomAnchor, constant: -10),
            mainTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellView.trailingAnchor, constant: -10),
            mainTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cellView.leadingAnchor, constant: 10),

            timeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            timeButton.topAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 12.5),
            timeButton.widthAnchor.constraint(equalToConstant: 80),
            timeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(recipeInstruction: InstructionModel){
        mainTextLabel.text = recipeInstruction.step
        self.isChecked = recipeInstruction.isChecked
        timeButton.setTitle("  \(recipeInstruction.minutes)", for: .normal)
    }
}

// MARK: - Private service functions
extension InstructionCell{
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
extension InstructionCell{
    
}
