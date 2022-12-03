import UIKit

final class SearchTableView: UITableView {
    
    enum Section: Hashable {
        case main
    }
    
    var data: [SearchResult]?
    var source: UITableViewDiffableDataSource<Section, SearchResult>?
    
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
    func configureDataSource() {
        source = UITableViewDiffableDataSource<Section, SearchResult>(tableView: self, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = tableView.dequeueCell(type: SearchTableViewCell.self, with: indexPath)
            cell.configure(recipe: self.data?[indexPath.row])
            return cell
        })
        guard let data = data else { return }
        createSnapshot(items: data, toSection: .main)
    }
    
    func setup() {
        backgroundColor = .clear
        separatorStyle = .none
        keyboardDismissMode = .onDrag
        translatesAutoresizingMaskIntoConstraints = false
        register(type: SearchTableViewCell.self)
        configureDataSource()
    }
}

// MARK: - Public func

extension SearchTableView {
    func createSnapshot(items: [SearchResult], toSection: Section) {
        data = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>()

        snapshot.appendSections([toSection])
        snapshot.appendItems(items, toSection: toSection)

        source?.apply(snapshot, animatingDifferences: true)
    }
}
