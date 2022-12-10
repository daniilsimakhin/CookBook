import UIKit

final class SearchViewController: UIViewController {
    
    private let networkClient = NetworkClient()
    
    private var offset = 0
    private var totalResults = 0
    private var searchText = ""
    private var searchModels: [SearchModel]?
    
    private var isSearchTextType = false
    
    private lazy var tableView: SearchTableView = {
        let view = SearchTableView(frame: view.frame, style: .plain)
        view.tableHeaderView = searchBar
        view.output = self
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        var view = UISearchBar(frame: .zero)
        view.delegate = self
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
    
    func searchAutoComplete(with text: String) {
        let loader = NetworkLoader(networkClient: networkClient)
        loader.fetchSearchAutoComplete(router: .searchAutoComplete(text: text)) { (result: Result<[SearchCompleteModel], Error>) in
            switch result {
            case .success(let success):
                self.tableView.createSearchAutoCompleteSnapshot(items: success, toSection: .main)
            case .failure(let failure):
                print(ServiceError.general(reason: "Error with search auto complete: \(failure.localizedDescription)"))
            }
        }
    }
    
    func searchQuerry(with text: String) {
        let loader = NetworkLoader(networkClient: networkClient)
        loader.fetchSearchRecipes(router: .searchRequest(text: text, number: 10, offset: offset)) { [weak self] (result: Result<SearchResults, Error>) in
            switch result {
            case .success(let success):
                self?.totalResults = success.totalResults
                self?.searchModels = success.results.map { result in
                    SearchModel(searchResult: result)
                }
                guard let searchModels = self?.searchModels else { return }
                self?.tableView.createSearchSnapshot(items: searchModels, toSection: .main)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        isSearchTextType = true
        tableView.configureSearchAutoCompleteDataSource()
        searchAutoComplete(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
        tableView.configureSearchDataSource()
        isSearchTextType = false
        self.searchText = searchText
        offset = 0
        searchQuerry(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchTextType = false
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        isSearchTextType = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        isSearchTextType = false
    }
}

// MARK: - SearchTableViewDelegate
extension SearchViewController: SearchTableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        guard !isSearchTextType && !networkClient.pagination && totalResults > offset && !searchText.isEmpty else { return }
        let currentPosition = scrollView.contentOffset.y + scrollView.frame.size.height
        let height = scrollView.contentSize.height
        if currentPosition > height - 50 {
            offset += 10
            guard !searchText.isEmpty else { return }
            searchQuerry(with: searchText)
        }
    }
    
    func didPressedCell(_ searchTableView: UITableView, by indexPath: IndexPath) {
        if isSearchTextType {
            guard let text = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
            searchBar.searchTextField.text = text
            searchAutoComplete(with: text)
        } else {
            let dataProvider = RecipesProviderImpl()
            dataProvider.loadRecipes { [weak self] result in
                switch result {
                case let .success(model):
                    let recipe = convert(model.recipes[0])
                    let vc = DetailViewController(with: recipe)
                    vc.title = recipe.title
                    self?.navigationController?.pushViewController(vc, animated: true)
                case let .failure(error):
                    print(error)
                }
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
