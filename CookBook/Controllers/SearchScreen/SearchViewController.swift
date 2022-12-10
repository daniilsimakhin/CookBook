import UIKit

final class SearchViewController: UIViewController {
    
    private let networkClient = NetworkClient()
    private var offset = 0
    private var count = 10
    private var totalResults = 0
    private var searchText = ""
    private var searchModels: [SearchModel]?
    
    private lazy var tableView: SearchTableView = {
        let view = SearchTableView(frame: view.frame, style: .plain)
        view.tableHeaderView = searchBar
        view.output = self
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        var view = UISearchBar(frame: .zero)
        view.delegate = self
        view.showsCancelButton = false
        view.searchBarStyle = .minimal
        view.backgroundColor = .clear
        view.sizeToFit()
        view.placeholder = "Search fun recipes"
        view.searchTextField.leftView?.tintColor = Theme.cbYellow50
        view.searchTextField.backgroundColor = Theme.appColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Private functions

private extension SearchViewController {
    func setup() {
        title = "Discover"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchText = searchText
        count = 10
        offset = 0
        let loader = NetworkLoader(networkClient: networkClient)
        loader.fetchSearchRecipes(router: .searchRequest(text: searchText, number: count, offset: offset)) { [weak self] (result: Result<SearchResults, Error>) in
            switch result {
            case .success(let success):
                self?.totalResults = success.totalResults
                self?.searchModels = success.results.map { result in
                    SearchModel(searchResult: result)
                }
                guard let searchModels = self?.searchModels else { return }
                self?.tableView.createSnapshot(items: searchModels, toSection: .main)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - SearchTableViewDelegate
extension SearchViewController: SearchTableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        guard !networkClient.pagination && totalResults > offset && !searchText.isEmpty else { return }
        let currentPosition = scrollView.contentOffset.y + scrollView.frame.size.height
        let height = scrollView.contentSize.height
        if currentPosition > height - 50 {
            count = 10
            offset += count
            guard !searchText.isEmpty else { return }
            let loader = NetworkLoader(networkClient: networkClient)
            loader.fetchSearchRecipes(router: .searchRequest(text: searchText, number: count, offset: offset)) { [weak self] (result: Result<SearchResults, Error>) in
                switch result {
                case .success(let success):
                    self?.totalResults = success.totalResults
                    self?.searchModels! += success.results.map { result in
                        SearchModel(searchResult: result)
                    }
                    guard let searchModels = self?.searchModels else { return }
                    self?.tableView.createSnapshot(items: searchModels, toSection: .main)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func didPressedCell(_ searchTableView: UITableView, by indexPath: IndexPath) {
        let dataProvider = RecipesProviderImpl()
        dataProvider.loadRecipes { [weak self] result in
            switch result {
            case let .success(model):
                let recipe = convert(model.recipes[0])
                let vc = DetailViewController(with: recipe)
                self?.navigationController?.pushViewController(vc, animated: true)
            case let .failure(error):
                print(error)
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
                calories: 100,
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
