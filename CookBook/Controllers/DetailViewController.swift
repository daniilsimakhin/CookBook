//
//  DetailViewController.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 30.11.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - UI elements
    private let mainStackView = UIStackView()
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Theme.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 400, height: 350)
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        imageView.layer.insertSublayer(gradient, at: 0)

        return imageView
    }()

    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27, weight: .semibold)
        label.textColor = Theme.cbWhite
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailStackView = UIStackView()
    private let caloriesLabel = UILabel()
    private let servingsLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let buttonsStackView = UIStackView()
    private let ingredientsButton = UIButton()
    private let instructionsButton = UIButton()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.blackColor
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }()
    
    private let recipeTableView = UITableView(frame: .zero, style: .plain)
        
    // MARK: - Properties
    let recipe: DetailRecipeModel
    let dataSourceIngredients: IngredientsDataSource
    let dataSourceSteps: InstructionsDataSource

    let networkLoader = NetworkLoader(networkClient: NetworkClient())
    
    private var isShowInstructions = false {
        didSet {
            recipeTableView.dataSource = isShowInstructions ? dataSourceSteps : dataSourceIngredients
            recipeTableView.reloadData()
            
            let count = recipeTableView.numberOfRows(inSection: 0)
            var text = ""
            switch count {
            case 0:
                text = isShowInstructions ? "No instructions" : "No ingredients"
            case 1:
                text = isShowInstructions ? "1 step" : "1 item"
            default:
                text = "\(count) \(isShowInstructions ? "steps" : "items")"
            }
            counterLabel.text = text
            
            let activeButton = isShowInstructions ? instructionsButton : ingredientsButton
            let noActiveButton = !isShowInstructions ? instructionsButton : ingredientsButton
            applyStyleToActiveButton(for: activeButton)
            applyStyleToUnactiveButton(for: noActiveButton)
        }
    }
    
    init(with recipe: DetailRecipeModel) {
        self.recipe = recipe
        dataSourceIngredients = .init(ingredients: recipe.ingredients)
        dataSourceSteps = .init(instructions: recipe.steps)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setup()
        applyStyle()
        applyLayout()
        
        isShowInstructions = true
    }
}

// MARK: - Style, layout and setup
extension DetailViewController{
    private func setup() {
        networkLoader.getRecipeImage(stringUrl: recipe.image) { [weak self] image in
            self?.recipeImageView.image = image
        }
        setupTableView()
        ingredientsButton.addTarget(self, action:  #selector(ButtonClicked), for: .touchUpInside)
        ingredientsButton.addTarget(self, action:  #selector(ButtonClicked), for: .touchUpInside)
        instructionsButton.addTarget(self, action:  #selector(ButtonClicked), for: .touchUpInside)
    }
    
    private func applyStyle() {
        applyStyleToSwitchButton(for: ingredientsButton, text: "Ingredients")
        applyStyleToSwitchButton(for: instructionsButton, text: "Recipe")
        recipeTitle.text = recipe.title
        adjustDetailLabel(for: caloriesLabel, mainText: String(recipe.calories), secondaryText: " kcal")
        adjustDetailLabel(for: servingsLabel, mainText: String(recipe.servings), secondaryText: " serv")
        adjustDetailLabel(for: timeLabel, mainText: String(recipe.readyInMinutes), secondaryText: " min")
    }
    
    private func applyLayout() {
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        arrangeStackView(for: detailStackView,
                         subviews: [timeLabel, caloriesLabel, servingsLabel],
                         distribution: .equalSpacing)
        
        arrangeStackView(
            for: buttonsStackView,
            subviews: [ingredientsButton, instructionsButton],
            spacing: 24,
            distribution: .fillEqually
        )
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        arrangeStackView(
            for: mainStackView,
            subviews: [recipeImageView, buttonsStackView, counterLabel, recipeTableView],
            spacing: 20,
            axis: .vertical
        )
        view.addSubview(mainStackView)
        view.addSubview(recipeTitle)
        view.addSubview(detailStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            recipeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            recipeTitle.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 8),
            recipeTitle.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -40),
            recipeTitle.widthAnchor.constraint(equalTo: recipeImageView.widthAnchor, constant: -16),
            
            detailStackView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -10),
            detailStackView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 20),
            detailStackView.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -20),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Supporting methods
    private func applyStyleToActiveButton(for button: UIButton) {
        button.isEnabled = false
        button.layer.backgroundColor = Theme.cbYellow50.cgColor
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowColor = Theme.shadowColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 3.0
        button.layer.masksToBounds = false
    }
    
    private func adjustDetailLabel(for label: UILabel,
                                   mainText: String,
                                   secondaryText: String){
        label.textColor = Theme.cbWhite
        
        let attributesForMain = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributesForSecondary = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .thin)]

        let boldString = NSMutableAttributedString(string: mainText, attributes: attributesForMain)
        let thinString = NSMutableAttributedString(string: secondaryText, attributes: attributesForSecondary)
        thinString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: thinString.length))
        let attributedString = NSMutableAttributedString(attributedString: boldString)
        attributedString.append(thinString)
        
        label.attributedText = attributedString
    }
    
    private func applyStyleToUnactiveButton(for button: UIButton) {
        button.isEnabled = true
        button.layer.backgroundColor = Theme.cbYellow20.cgColor
        button.setTitleColor(Theme.cbYellow50, for: .normal)
        button.layer.shadowOpacity = 0.0
    }
    
    private func applyStyleToSwitchButton(
        for button: UIButton,
        text: String = "",
        isEnabled: Bool = true,
        alpha: Float = 1
    ) {
        button.setTitleColor(.black, for: .normal)
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
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

// MARK: - TableView
extension DetailViewController{
    func setupTableView(){
        recipeTableView.delegate = self
        
        recipeTableView.register(InstructionCell.self, forCellReuseIdentifier: InstructionCell.reuseID)
        recipeTableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseID)
        recipeTableView.estimatedRowHeight = InstructionCell.rowHeight
        recipeTableView.rowHeight = UITableView.automaticDimension
        recipeTableView.separatorStyle = .none
        
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Actions
extension DetailViewController{
    @objc private func ButtonClicked() {
        isShowInstructions.toggle()
    }
}

// MARK: - UITableView Delegate
extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
