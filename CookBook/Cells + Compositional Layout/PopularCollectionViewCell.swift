//
//  RandomCollectionViewCell.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
   
    private let popularImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Cookbook_logo_trans")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundTitleView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(popularImageView)
        addSubview(backgroundTitleView)
    }
    
    func configureCell(imageName: String) {
        popularImageView.image = UIImage(named: imageName)
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            popularImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            popularImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            popularImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            popularImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            backgroundTitleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            backgroundTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            backgroundTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundTitleView.heightAnchor.constraint(equalTo: heightAnchor, constant: 0.1),
        ])
    }
}
