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
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.cbWhite
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Random Meal"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = Theme.Fonts.cbRecipeTitleSmall
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Theme.cbText100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loader = NetworkLoader(networkClient: NetworkClient())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        backgroundTitleView.addSubview(titleLabel)
        
        addSubview(randomImageView)
        addSubview(backgroundTitleView)
    }
    
    func configureCell(mealLabel: String, imageName: String) {
        titleLabel.text = mealLabel
        loader.getRecipeImage(stringUrl: imageName) { image in
            self.randomImageView.image = image
        }
    }
        
        func setConstraints() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: backgroundTitleView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: backgroundTitleView.leadingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: backgroundTitleView.trailingAnchor, constant: -8),
                titleLabel.bottomAnchor.constraint(equalTo: backgroundTitleView.bottomAnchor, constant: -8),
                
                randomImageView.topAnchor.constraint(equalTo: topAnchor),
                randomImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                randomImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                randomImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
                backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        }
    }
