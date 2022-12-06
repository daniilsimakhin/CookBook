import UIKit

final class SearchTableViewMiniCell: UITableViewCell {
    
    static let reuseID = String(describing: SearchTableViewMiniCell.self)
    
    let networkClient = NetworkClient()
    var recipe: SearchModel?
    
    private lazy var heartImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))
        let image = UIImage(systemName: "heart", withConfiguration: config)
        return image
    }()
    
    private lazy var heartFillImage: UIImage? = {
        let config = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline))
        let image = UIImage(systemName: "heart.fill", withConfiguration: config)
        return image
    }()
    
    private var isChoosed: Bool = false
    
    private lazy var searchImageView: SearchImageView = {
        return SearchImageView(frame: .zero)
    }()
    private lazy var recipeLabel: UILabel = {
        var view = UILabel()
        view.text = "Title"
        view.numberOfLines = 4
        view.font = .preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(heartImage, for: .normal)
        view.tintColor = Theme.cbYellow50
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        view.sizeToFit()
        view.setTitleColor(.label, for: .normal)
        view.backgroundColor = Theme.cbGreen50
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
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
        likeButton.setImage(heartImage, for: .normal)
    }
}

// MARK: - Public func

extension SearchTableViewMiniCell {
    func configure(recipe: SearchModel?) {
        guard let recipe = recipe else { return }
        self.recipe = recipe
        if FavoriteRecipesStorage.shared.checkIsFavoriteRecipe(recipe.id) {
            likeButton.setImage(heartFillImage, for: .normal)
            isChoosed = true
        }
        
        recipeLabel.attributedText = recipe.recipeString
        likeButton.setTitle(" \(recipe.aggregateLikes)", for: .normal)
        networkClient.getImageFrom(stringUrl: recipe.image) { [weak self] image in
            self?.searchImageView.configure(image: image)
        }
    }
}

// MARK: - Private func

private extension SearchTableViewMiniCell {
    @objc func favoriteButtonPressed(_ sender: UIButton) {
        isChoosed.toggle()
        let image = isChoosed ? heartFillImage : heartImage
        likeButton.setImage(image, for: .normal)
        FavoriteRecipesStorage.shared.addToFavorite(recipe, with: isChoosed)
    }
    
    private func setup() {
        contentView.addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.heightAnchor.constraint(equalToConstant: 100),
            searchImageView.widthAnchor.constraint(equalToConstant: 100),
            searchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Theme.topOffset),
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Theme.leftOffset / 2),
            searchImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Theme.topOffset),
        ])
        
        contentView.addSubview(recipeLabel)
        NSLayoutConstraint.activate([
            recipeLabel.topAnchor.constraint(equalTo: searchImageView.topAnchor),
            recipeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.leftOffset / 2),
            recipeLabel.bottomAnchor.constraint(equalTo: searchImageView.bottomAnchor),
            recipeLabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant:  Theme.leftOffset / 2)
        ])

        contentView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.bottomAnchor.constraint(equalTo: recipeLabel.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Theme.leftOffset / 2),
        ])
    }
}
