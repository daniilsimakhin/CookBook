//
//  PopularViewController.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

class PopularViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var sections = CompMockData.shared.pageData
    private var vegan: [ListItem]?
    private var random: [ListItem]?
    
    private let loader = NetworkLoader(networkClient: NetworkClient())
    
    private var danseRandom = "D"
    private var danseVegan = "E"
    private var hasRefreshed: Bool = false {
        didSet{
            let danse = ["D", "A", "N", "S", "E"]
                .filter { $0 != danseRandom && $0 != danseVegan }
                .shuffled()
            danseRandom = danse[0]
            danseVegan = danse[1]
        }
    }
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshContent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.setupViews()
            self.setConstraints()
            self.setDelegates()
            self.setupRefreshControl()
        }
    }
    
    private func setupViews() {
        navigationItem.title = "Popular"
        view.addSubview(collectionView)
        collectionView.register(
            RandomCollectionViewCell.self,
            forCellWithReuseIdentifier: "RandomCollectionViewCell"
        )
        collectionView.register(
            VeganCollectionViewCell.self,
            forCellWithReuseIdentifier: "VeganCollectionViewCell"
        )
        collectionView.register(
            HeaderSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderSupplementaryView"
        )
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = Theme.cbYellow50 // цвет индикатора загрузки
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshContent() {
        hasRefreshed.toggle()
        fetchData()
    }
    
    private func fetchData() {
        
        let group = DispatchGroup()
        
        fetchRandom(group: group)
        fetchVegan(group: group)
        
        group.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    private func fetchRandom(group: DispatchGroup) {
        group.enter()
        
        loader.fetchSearchRecipes(router: .searchRequest(text: danseRandom, number: 10, offset: 0)) { [weak self] (result: Result<SearchResults, Error>) in
            switch result {
            case .success(let success):
                let searchModels = success.results.map { result in
                    SearchModel(searchResult: result)
                }
                self?.random = searchModels.map { res in
                        .init(title: res.title, image: res.image, id: res.id)
                }
                guard let random = self?.random else { return }
                self?.sections[0] = .random(random)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            group.leave()
        }
    }
    
    private func fetchVegan(group: DispatchGroup) {
        group.enter()
        let tags = ["vegetarian", "vegan", "glutenFree", "Paleo", "Seafood"].randomElement()
        
        loader.fetchVegetarianRecipes(router: .randomVegetarianRequest(text: danseVegan, number: 10, offset: 0, tags: tags!)) { [weak self] (result: Result<SearchResults, Error>) in
            switch result {
            case .success(let success):
                let searchModels = success.results.map { result in
                    SearchModel(searchResult: result)
                }
                self?.vegan = searchModels.map { res in
                        .init(title: res.title, image: res.image, id: res.id)
                }
                guard let vegan = self?.vegan else { return }
                self?.sections[1] = .vegan(vegan)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
            group.leave()
        }
    }
    
    private func reloadView() {
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - Create Layout

extension PopularViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            let section = self.sections[sectionIndex]
            switch section {
            case .random(_):
                return self.createRandomSection()
            case .vegan(_):
                return self.createVeganSection()
            }
        }
    }
    
    private func createLayoutSection(
        group: NSCollectionLayoutGroup,
        behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
        intergrouupSpacing: CGFloat,
        supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
        contentInsets: Bool
    ) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = intergrouupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        section.supplementariesFollowContentInsets = contentInsets
        return section
    }
    
    private func createRandomSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [item]
        )
        
        let section = createLayoutSection(
            group: group,
            behavior: .groupPaging,
            intergrouupSpacing: 15,
            supplementaryItems: [],
            contentInsets: false
        )
        section.contentInsets = .init(top: 30, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    private func createVeganSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.47),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [item]
        )
        
        let section = createLayoutSection(
            group: group,
            behavior: .groupPaging,
            intergrouupSpacing: 5,
            supplementaryItems: [supplementaryHeaderItem()],
            contentInsets: false
        )
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(40)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

//MARK: - UICollectionViewDelegate
extension PopularViewController: UICollectionViewDelegate { }

//MARK: - UICollectionViewDataSource
extension PopularViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .random(let random):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RandomCollectionViewCell", for: indexPath) as? RandomCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(mealLabel: random[indexPath.row].title, imageName: random[indexPath.row].image)
            return cell
            
            
        case .vegan(let vegan):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VeganCollectionViewCell", for: indexPath) as? VeganCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(mealLabel: vegan[indexPath.row].title, imageName: vegan[indexPath.row].image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeID = sections[indexPath.section].items[indexPath.row].id
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderSupplementaryView",
                for: indexPath
            ) as! HeaderSupplementaryView
            header.configureHeader(categoryName: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Set Constraints
extension PopularViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
