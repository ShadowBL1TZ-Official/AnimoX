import Foundation

struct UserList: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var animeIds: Set<String>

    init(name: String, animeIds: Set<String>) {
        self.id = UUID()
        self.name = name
        self.animeIds = animeIds
    }
}
