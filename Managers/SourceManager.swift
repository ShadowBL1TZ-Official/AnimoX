import Foundation

final class SourceManager: ObservableObject {
    static let shared = SourceManager()
    @Published var provider: SourceProvider

    private init() {
        // Default to HiAnime stub; you can switch at runtime
        self.provider = HiAnimeProvider()
    }

    func switchTo(_ provider: SourceProvider) {
        self.provider = provider
    }
}
