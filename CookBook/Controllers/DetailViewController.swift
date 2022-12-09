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
    
    private let recipeImageView = UIImageView()
    
    private let buttonsStackView = UIStackView()
    private let ingredientsButton = UIButton()
    private let instructionsButton = UIButton()
    
    private let counterLabel = UILabel()
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
        instructionsButton.addTarget(self, action:  #selector(ButtonClicked), for: .touchUpInside)
    }
    
    private func applyStyle() {
        applyStyleToImageView(for: recipeImageView)
                
        applyStyleToSwitchButton(for: ingredientsButton, text: "Ingredients")
        applyStyleToSwitchButton(for: instructionsButton, text: "Recipe")
        
        applyStyleToLabel(for: counterLabel)
    }
    
    private func applyLayout() {
        arrangeStackView(
            for: buttonsStackView,
            subviews: [ingredientsButton, instructionsButton],
            spacing: 24,
            axis: .horizontal,
            distribution: .fillEqually
        )
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        arrangeStackView(
            for: mainStackView,
            subviews: [recipeImageView, buttonsStackView, counterLabel, recipeTableView],
            spacing: 20
        )
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            recipeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    // MARK: - Supporting methods
    private func applyStyleToActiveButton(for button: UIButton) {
        button.isEnabled = false
        button.layer.backgroundColor = Theme.cbYellow50.cgColor
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowColor = UIColor(red: 255/255, green: 100/255, blue: 51/255, alpha: 0.29).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 3.0
        button.layer.masksToBounds = false
    }
    
    private func applyStyleToUnactiveButton(for button: UIButton) {
        button.isEnabled = true
        button.layer.backgroundColor = Theme.cbYellow20.cgColor
        button.setTitleColor(Theme.cbYellow50, for: .normal)
        button.layer.shadowOpacity = 0.0
    }
    
    private func applyStyleToImageView(for imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Theme.imageCornerRadius
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyStyleToLabel(for label: UILabel) {
        label.textColor = .black
        label.font = .systemFont(ofSize: 25, weight: .medium)
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
        axis: NSLayoutConstraint.Axis = .vertical,
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
        
        recipeTableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseID)
        recipeTableView.estimatedRowHeight = DetailCell.rowHeight
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowInstructions {
            let indexesToRedraw = [indexPath]
            dataSourceSteps.instructions[indexPath.row].isChecked.toggle()
            // TODO: - Make checkboxes work
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
        }
    }
}
