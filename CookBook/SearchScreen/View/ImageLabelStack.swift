import UIKit

class ImageLabelStack: UIStackView {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.adjustsImageSizeForAccessibilityContentSizeCategory = true
        view.tintColor = .white
        return view
    }()
    private lazy var label: UILabel = {
        let view = UILabel()
        view.text = "0"
        view.textAlignment = .center
        view.font = .preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private func

private extension ImageLabelStack {
    func setup() {
        axis = .horizontal
        translatesAutoresizingMaskIntoConstraints = false
        alignment = .bottom
        distribution = .equalSpacing
        spacing = 5
        backgroundColor = Theme.cbGreen50
        sizeToFit()
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
    }
    
    func setupSubviews() {
        addArrangedSubview(imageView)
        addArrangedSubview(label)
    }
}

// MARK: - Public func

extension ImageLabelStack {
    func configure(count: Int) {
        label.text = String(count)
    }
    
    func setImageWithConfiguration(name: String, configuration: UIImage.Configuration) {
        imageView.image = UIImage(systemName: name, withConfiguration: configuration)
    }
}
