import Foundation

final class AppState: ObservableObject {
    @Published var favorites: Set<String> = [] // Anime.id
    @Published var lists: [UserList] = []
    @Published var downloads: [String: URL] = [:] // Episode.id : local file URL

    func toggleFavorite(_ animeId: String) {
        if favorites.contains(animeId) { favorites.remove(animeId) } else { favorites.insert(animeId) }
        Storage.saveFavorites(favorites)
    }

    func isFavorite(_ animeId: String) -> Bool {
        favorites.contains(animeId)
    }

    func addToList(listName: String, animeId: String) {
        if let idx = lists.firstIndex(where: { $0.name == listName }) {
            lists[idx].animeIds.insert(animeId)
        } else {
            lists.append(UserList(name: listName, animeIds: [animeId]))
        }
        Storage.saveLists(lists)
    }

    func loadPersisted() {
        favorites = Storage.loadFavorites()
        lists = Storage.loadLists()
    }
}
