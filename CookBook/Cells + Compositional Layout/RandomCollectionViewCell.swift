//
//  PopularCollectionViewCell.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import UIKit

class RandomCollectionViewCell: UICollectionViewCell {
    private let randomImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    }
    
    func configureCell(imageName: String) {
        randomImageView.image = UIImage(named: "Screenshot 2022-12-01 at 13.44.23")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            randomImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            randomImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            randomImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            randomImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
