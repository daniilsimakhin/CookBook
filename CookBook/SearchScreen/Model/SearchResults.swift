import Foundation

struct SearchResults: Decodable {
    let results: [SearchResult]
    let offset: Int
    let number: Int
    let totalResults: Int
}
