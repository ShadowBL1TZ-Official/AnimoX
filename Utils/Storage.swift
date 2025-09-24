import Foundation

enum Storage {
    private static let favoritesKey = "animox.favorites"
    private static let listsKey = "animox.lists"

    static func saveFavorites(_ favs: Set<String>) {
        UserDefaults.standard.set(Array(favs), forKey: favoritesKey)
    }

    static func loadFavorites() -> Set<String> {
        let arr = (UserDefaults.standard.array(forKey: favoritesKey) as? [String]) ?? []
        return Set(arr)
    }

    static func saveLists(_ lists: [UserList]) {
        let enc = JSONEncoder()
        guard let data = try? enc.encode(lists) else { return }
        UserDefaults.standard.set(data, forKey: listsKey)
    }

    static func loadLists() -> [UserList] {
        guard let data = UserDefaults.standard.data(forKey: listsKey) else { return [] }
        let dec = JSONDecoder()
        return (try? dec.decode([UserList].self, from: data)) ?? []
    }
}
