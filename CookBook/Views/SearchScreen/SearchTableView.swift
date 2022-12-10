import UIKit

protocol SearchTableViewDelegate: AnyObject {
    func scrollViewDidScroll(scrollView: UIScrollView!)
    func didPressedCell(_ searchTableView: UITableView, by indexPath: IndexPath)
}

final class SearchTableView: UITableView {
    
    enum Section: Hashable {
        case main
    }
    
    weak var output: SearchTableViewDelegate?
    var searchModels: [SearchModel]?
    var searchCompleteModels: [SearchCompleteModel]?
    var searchModelsDataSource: UITableViewDiffableDataSource<Section, SearchModel>?
    var searchCompleteModelsDataSource: UITableViewDiffableDataSource<Section, SearchCompleteModel>?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private func

private extension SearchTableView {
    func setup() {
        backgroundColor = .clear
        estimatedRowHeight = 120
        rowHeight = UITableView.automaticDimension
        keyboardDismissMode = .onDrag
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        register(type: SearchTableViewMiniCell.self)
        register(type: UITableViewCell.self)
    }
}

// MARK: - Public func

extension SearchTableView {
    func createSearchSnapshot(items: [SearchModel], toSection: Section) {
        searchModels = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchModel>()

        snapshot.appendSections([toSection])
        snapshot.appendItems(items, toSection: toSection)

        searchModelsDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func createSearchAutoCompleteSnapshot(items: [SearchCompleteModel], toSection: Section) {
        searchCompleteModels = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchCompleteModel>()

        snapshot.appendSections([toSection])
        snapshot.appendItems(items, toSection: toSection)

        searchCompleteModelsDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func configureSearchDataSource() {
        searchModelsDataSource = UITableViewDiffableDataSource<Section, SearchModel>(tableView: self, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = tableView.dequeueCell(type: SearchTableViewMiniCell.self, with: indexPath)
            cell.configure(recipe: self.searchModels?[indexPath.row])
            return cell
        })
    }
    
    func configureSearchAutoCompleteDataSource() {
        searchCompleteModelsDataSource = UITableViewDiffableDataSource<Section, SearchCompleteModel>(tableView: self, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = tableView.dequeueCell(type: UITableViewCell.self, with: indexPath)
            cell.textLabel?.text = self.searchCompleteModels?[indexPath.row].title
            return cell
        })
    }
}

// MARK: - UITableViewDelegate

extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didPressedCell(self, by: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        output?.scrollViewDidScroll(scrollView: scrollView)
    }
}
