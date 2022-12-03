import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(type: T.Type, with indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError("Don't dequeue cell with - \(T.reuseIdentifier)") }
        return cell
    }
    
    func register<T: UITableViewCell>(type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
