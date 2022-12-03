import UIKit

class SearchImageView: UIImageView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private func

private extension SearchImageView {
    func setup() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = Theme.imageCornerRadius / 1.25
        layer.cornerCurve = .continuous
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}

// MARK: - Public func

extension SearchImageView {
    func configure(image: UIImage) {
        self.image = image
        activityIndicator.stopAnimating()
    }
    
    func prepareForReuse() {
        image = nil
        activityIndicator.startAnimating()
    }
}
