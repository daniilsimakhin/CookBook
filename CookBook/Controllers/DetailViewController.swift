//
//  DetailViewController.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 30.11.2022.
//

import UIKit

struct RecipeViewModel{
    let recipeInstruction: RecipesModel.Instruction
    var isChecked: Bool
}

final class DetailViewController: UIViewController {
    // MARK: - Properties
    private var ingredients = [IngredientModel]()
    private var recipeInstructions = [RecipeViewModel]()
    var addedToFavourites = false
    private var isShowInstructions = false
    var selectedIndex = IndexPath(row: -1, section: 0)
    
    // MARK: - UI elements
    private let mainStackView = UIStackView()
    private let previewImageView = UIView()
    
    private let recipeImageView = UIImageView(image: UIImage(named: "test_recipe_image"))
    private let shadowImageView = UIImageView(image: UIImage(named: "shadow"))
    
    private let recipeTableView = UITableView(frame: .zero, style: .plain)
    private let recipeNameLabel = UILabel()
    
    private let detailStackView = UIStackView()
    
    private let buttonsStackView = UIStackView()
    private let ingredientsButton = UIButton()
    private let instructionsButton = UIButton()

    private lazy var addToFavouritesButton = UIButton()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setup()
        applyStyle()
        applyLayout()
        
        loadIngredients()
        loadInstructions()
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
    }
}
// MARK: - Actions
extension DetailViewController{
    @objc private func addToFavourites() {
        addedToFavourites = !addedToFavourites
        let imageName = (addedToFavourites) ? "heart.fill" : "heart"
        addToFavouritesButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)), for: .normal)
    }
    
    @objc private func ingredientsButtonClicked() {
        isShowInstructions = false
        instructionsButton.alpha = 0.5
        ingredientsButton.alpha = 1
        recipeTableView.reloadData()
    }
    
    @objc private func instructionsButtonClicked() {
        isShowInstructions = true
        instructionsButton.alpha = 1
        ingredientsButton.alpha = 0.5
        recipeTableView.reloadData()
    }
}

// MARK: - Style, layout and setup
extension DetailViewController{
    private func setup(){
        recipeTableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.reuseID)

        addToFavouritesButton.addTarget(self, action: #selector(addToFavourites), for: .touchUpInside)
        
        ingredientsButton.addTarget(self, action:  #selector(ingredientsButtonClicked), for: .touchUpInside)
        instructionsButton.addTarget(self, action:  #selector(instructionsButtonClicked), for: .touchUpInside)
    }
    
    private func applyStyle(){
        applyStyleToImageView(for: recipeImageView)
        applyStyleToImageView(for: shadowImageView)
        
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
        
        recipeNameLabel.text = "Simple salad"
        recipeNameLabel.textColor = .white
        recipeNameLabel.numberOfLines = 1
        recipeNameLabel.minimumScaleFactor = 0.5
        recipeNameLabel.font = UIFont.systemFont(ofSize: 27, weight: .semibold)
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailStackView.axis = .horizontal
        detailStackView.alignment = .center
        detailStackView.distribution = .equalSpacing
        
        addToFavouritesButton.setImage(UIImage(systemName: (addedToFavourites) ? "heart.fill" : "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium)), for: .normal)
        addToFavouritesButton.tintColor = .white
        addToFavouritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        applyStyleToSwitchButton(for: ingredientsButton, text: "Ingredients")
        applyStyleToSwitchButton(for: instructionsButton, text: "Recipe", alpha: 0.5)

        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyLayout(){
        previewImageView.addSubview(recipeImageView)
        previewImageView.addSubview(shadowImageView)
        previewImageView.addSubview(recipeNameLabel)
        constructStackView()
        previewImageView.addSubview(detailStackView)
        previewImageView.addSubview(addToFavouritesButton)
        
        arrangeStackView(
            for: buttonsStackView,
            subviews: [ingredientsButton, instructionsButton],
            axis: .horizontal,
            distribution: .fillEqually
        )
        
        arrangeStackView(
            for: mainStackView,
            subviews: [previewImageView, buttonsStackView, recipeTableView],
            spacing: 0
        )
        
        
        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            previewImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            previewImageView.heightAnchor.constraint(equalToConstant: 350),
            
            recipeImageView.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: previewImageView.bottomAnchor),
            recipeImageView.topAnchor.constraint(equalTo: previewImageView.topAnchor),

            shadowImageView.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            shadowImageView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            
            recipeNameLabel.widthAnchor.constraint(equalTo: previewImageView.widthAnchor, constant: -40),
            recipeNameLabel.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: 220),
            recipeNameLabel.leadingAnchor.constraint(equalTo: previewImageView.leadingAnchor, constant: 25),
            
            detailStackView.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor),
            detailStackView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            detailStackView.widthAnchor.constraint(equalTo: recipeNameLabel.widthAnchor),
            detailStackView.heightAnchor.constraint(equalToConstant: 80),
            
            buttonsStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1),
            
            addToFavouritesButton.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: -20),
            addToFavouritesButton.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: 20),
        ])
    }
    
    // MARK: - Supporting methods
    private func applyStyleToImageView(for imageView: UIImageView){
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyStyleToSwitchButton(
        for button: UIButton,
        text: String = "",
        isEnabled: Bool = true,
        alpha: Float = 1){
            button.setTitleColor(.black, for: .normal)
            button.setTitle(text, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = CGColor(gray: 0.1, alpha: 1)
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
    
    private func constructStackView(){
        // MARK: - Properties for stack view
        
        typealias Item = (name: String, value: Int)
        let items: [Item] = [
          Item(name: "ing", value: 3),
          Item(name: "kcal", value: 350),
          Item(name: "min", value: 10),
        ]
        
        let valueFormatter = NumberFormatter()
        valueFormatter.numberStyle = .decimal
        
        // MARK: - Custom styles for stack view
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let valueStyle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23), NSAttributedString.Key.foregroundColor: UIColor.white]
        let nameStyle: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .thin), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: 4]
        
        // MARK: - StackView build
        
        func buildSeparatorForStackView(){
            let separator = UIView()
            separator.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
            separator.backgroundColor = .white
            detailStackView.addArrangedSubview(separator)
            separator.heightAnchor.constraint(equalTo: detailStackView.heightAnchor, multiplier: 0.4).isActive = true
        }
        
        func buildLabelForStackView(for item: Item){
            let totalText = NSMutableAttributedString()
            let valueString = valueFormatter.string(for: item.value)!
            totalText.append(NSAttributedString(string: valueString + " ", attributes: valueStyle))
            totalText.append(NSAttributedString(string: item.name, attributes: nameStyle))
            let label = UILabel()
            label.attributedText = totalText
            label.textAlignment = .center
            label.numberOfLines = 0
            detailStackView.addArrangedSubview(label)

            if let firstLabel = detailStackView.arrangedSubviews.first as? UILabel {
                label.widthAnchor.constraint(equalTo: firstLabel.widthAnchor).isActive = true
            }
        }
        
        for item in items {
            if detailStackView.arrangedSubviews.count > 0 {
                buildSeparatorForStackView()
            }
            buildLabelForStackView(for: item)
        }
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableView Data Source/Delegate
extension DetailViewController: UITableViewDataSource{
    // MARK: - Data loading
    private func loadIngredients() {
        ingredients.append(
            IngredientModel(title: "1 cucumber", picture: UIImage(systemName: "applelogo")!))
        ingredients.append(
            IngredientModel(title: "1 tomato", picture: UIImage(systemName: "applelogo")!))
        ingredients.append(
            IngredientModel(title: "1 tablespoon oil", picture: UIImage(systemName: "applelogo")!))
        ingredients.sort{ $0.title < $1.title }
    }
    
    private func loadInstructions(){
        recipeInstructions.append(RecipeViewModel(recipeInstruction: RecipesModel.Instruction(step: "Clean and chop the vegatables", seconds: 120), isChecked: false))
        recipeInstructions.append(RecipeViewModel(recipeInstruction: RecipesModel.Instruction(step: "Add oil and seasonings", seconds: 60), isChecked: false))
    }
        
    // MARK: - Table properties
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowInstructions{
            let indexesToRedraw = [indexPath]
            selectedIndex = indexPath
            recipeInstructions[indexPath.row].isChecked = !recipeInstructions[indexPath.row].isChecked
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowInstructions ? recipeInstructions.count : ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.reuseID, for: indexPath) as! DetailCell
        if isShowInstructions{
            let recipeInstruction = recipeInstructions[indexPath.row]
            cell.configure(recipeInstruction: recipeInstruction)
        }
        else {
            let ingredient = ingredients[indexPath.row]
            cell.configure(ingredient: ingredient)
        }
        return cell
    }
}

extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
