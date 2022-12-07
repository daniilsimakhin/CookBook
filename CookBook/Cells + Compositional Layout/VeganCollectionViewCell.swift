//
//  PopularCollectionViewCell.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import UIKit

class VeganCollectionViewCell: UICollectionViewCell {
    private let randomImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundTitleView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Random Meal"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = Theme.beigeColor
        layer.cornerRadius = 10
        addSubview(randomImageView)
        addSubview(backgroundTitleView)
        addSubview(nameLabel)
    }
    
    func configureCell(mealLabel: String, imageName: String) {
        nameLabel.text = mealLabel
        randomImageView.image = UIImage(named: imageName)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            randomImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            randomImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            randomImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            randomImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundTitleView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            
            nameLabel.centerYAnchor.constraint(equalTo: backgroundTitleView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: backgroundTitleView.centerXAnchor)
        ])
    }
}
