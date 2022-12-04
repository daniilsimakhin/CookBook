import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    let networkClient = NetworkClient()
    
    private lazy var backView: UIView = {
        var view = UIView()
        view.backgroundColor = Theme.cbYellow20
        view.clipsToBounds = true
        view.layer.cornerRadius = Theme.imageCornerRadius
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var searchImageView: SearchImageView = {
        return SearchImageView(frame: .zero)
    }()
    private lazy var recipeLabel: UILabel = {
        var view = UILabel()
        view.text = "Title"
        view.numberOfLines = 3
        view.font = .preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var statsStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.backgroundColor = Theme.cbGreen50
        view.layer.cornerRadius = Theme.buttonCornerRadius / 2
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var timePreparingLabel: UILabel = {
        var view = UILabel()
        view.textAlignment = .center
        view.text = "20 Minutes"
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var ingridientsLabel: UILabel = {
        var view = UILabel()
        view.textAlignment = .center
        view.text = "14 Ingridients"
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .placeholderText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var caloriesLabel: UILabel = {
        var view = UILabel()
        view.textAlignment = .center
        view.text = "550 Calories"
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var likesStackView: ImageLabelStack = {
        let view = ImageLabelStack()
        view.setImageWithConfiguration(name: "hand.thumbsup.fill", configuration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline)))
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        searchImageView.prepareForReuse()
    }
}

// MARK: - Public func

extension SearchTableViewCell {
    func configure(recipe: SearchResult?) {
        guard let recipe = recipe else { return }
        recipeLabel.text = recipe.title
        
        ingridientsLabel.attributedText = setAttributedString(String(recipe.nutrition.ingredients.count), "Ing")
        caloriesLabel.attributedText = setAttributedString(String(Int(recipe.nutrition.nutrients[0].amount)), "Kcal")
        timePreparingLabel.attributedText = setAttributedString(String(recipe.readyInMinutes), "Min")
        
        likesStackView.configure(count: recipe.aggregateLikes)
        networkClient.getImageFrom(stringUrl: recipe.image) { [weak self] image in
            self?.searchImageView.configure(image: image)
        }
    }
}

// MARK: - Private func

private extension SearchTableViewCell {
    func setAttributedString(_ numbers: String, _ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: numbers + " " + text)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .headline), range: NSMakeRange(0, numbers.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, numbers.count))
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(numbers.count + 1, text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(numbers.count + 1, text.count))
        
        return attributedString
    }
    
    private func setup() {
        contentView.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.topOffset),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.leftOffset / 2),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Theme.topOffset),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.leftOffset / 2),
        ])
        
        contentView.addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: Theme.topOffset),
            searchImageView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Theme.leftOffset / 2),
            searchImageView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Theme.leftOffset / 2),
            searchImageView.heightAnchor.constraint(equalTo: searchImageView.widthAnchor, multiplier: 0.7),
        ])
        
        contentView.addSubview(likesStackView)
        NSLayoutConstraint.activate([
            likesStackView.topAnchor.constraint(equalTo: searchImageView.topAnchor, constant: Theme.topOffset),
            likesStackView.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor, constant:  Theme.leftOffset / 2)
        ])
        
        contentView.addSubview(statsStackView)
        statsStackView.addArrangedSubview(ingridientsLabel)
        statsStackView.addArrangedSubview(caloriesLabel)
        statsStackView.addArrangedSubview(timePreparingLabel)
        NSLayoutConstraint.activate([
            statsStackView.topAnchor.constraint(equalTo: searchImageView.bottomAnchor, constant: Theme.topOffset),
            statsStackView.trailingAnchor.constraint(equalTo: searchImageView.trailingAnchor),
            statsStackView.leadingAnchor.constraint(equalTo: searchImageView.leadingAnchor)
        ])

        contentView.addSubview(recipeLabel)
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: Theme.topOffset / 2),
            recipeLabel.trailingAnchor.constraint(equalTo: statsStackView.trailingAnchor),
            recipeLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -Theme.topOffset * 1.5),
            recipeLabel.leadingAnchor.constraint(equalTo: statsStackView.leadingAnchor)
        ])
    }
}
