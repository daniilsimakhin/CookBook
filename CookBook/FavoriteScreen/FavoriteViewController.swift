//
//  FavoriteViewController.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 06.12.2022.
//

import UIKit

final class FavoriteViewController: UIViewController {
    private let tableView = UITableView()
    private let dataSource: FavoriteRecipesDataSource = .init(favoriteRecipes: FavoriteRecipesStorage.shared.getFavoriteRecipes())
    
    private let loader = NetworkLoader(networkClient: NetworkClient())
    
    // Qewhouse >>>>>>
    private let initialImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Text_Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    //<<<<<< Qewhouse
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.favoriteRecipes = FavoriteRecipesStorage.shared.getFavoriteRecipes()
        if dataSource.favoriteRecipes.isEmpty {
            tableView.backgroundColor = .clear
        } else {
            tableView.backgroundColor = Theme.appColor
            tableView.reloadData()
        }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

private extension FavoriteViewController {
    
    func setup() {
        setupTableView()
    }
    
    func applyStyle() {
        navigationItem.title = "Favorite"
    }
    
    func applyLayout() {
        // Qewhouse >>>>>>
        view.addSubview(initialImageView)
        //<<<<<< Qewhouse
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Qewhouse >>>>>>
            initialImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Theme.leftOffset),
            initialImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Theme.leftOffset),
            initialImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //<<<<<< Qewhouse
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(SearchTableViewMiniCell.self, forCellReuseIdentifier: SearchTableViewMiniCell.reuseID)
        tableView.reloadData()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeID = dataSource.favoriteRecipes[indexPath.row].id
        loader.fetchRecipeBy(id: recipeID) { [weak self] (result: Result<RecipesData.Recipe, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                guard let preModel = RecipesModelFromDataConverter().convert(data: success) else {
                    print("Error: converter failed")
                    return
                }
                let recipe = convert(preModel)
                DispatchQueue.main.async {
                    let vc = DetailViewController(with: recipe)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        func convert(_ recipe: RecipesModel.Recipe) -> DetailRecipeModel {
            .init(
                id: recipe.id,
                title: recipe.title,
                aggregateLikes: recipe.aggregateLikes,
                readyInMinutes: recipe.readyInMinutes,
                servings: recipe.servings,
                image: recipe.image,
                calories: recipe.calories,
                ingredients: recipe.ingredients.map { res in
                        .init(image: res.image, original: res.original)
                },
                steps: recipe.instructions.map { res in
                        .init(step: res.step, minutes: res.minutes)
                }
            )
        }
    }
}
