import Foundation

struct Episode: Identifiable, Hashable {
    let id: String
    let number: Int
    let title: String
    let releaseDate: Date?
}
