import Foundation

protocol SourceProvider {
    var name: String { get }

    func fetchCatalog(page: Int, query: String?) async throws -> [Anime]
    func fetchAnimeDetails(id: String) async throws -> AnimeDetail
    func fetchEpisodes(animeId: String) async throws -> [Episode]
    func fetchStreamURL(episodeId: String) async throws -> URL

    // Optional: return nil if not supported by provider
    func downloadEpisode(episodeId: String) async throws -> URL?
}

extension SourceProvider {
    func downloadEpisode(episodeId: String) async throws -> URL? { nil }
}
