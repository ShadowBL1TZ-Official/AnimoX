import Foundation

// MARK: - Provider

final class HiAnimeProvider: SourceProvider {
    let name = "HiAnime API"
    let baseURL = URL(string: "https://watanuki.vercel.app/")!

    // Search catalog
    func fetchCatalog(page: Int, query: String?) async throws -> [Anime] {
        var comps = URLComponents(url: baseURL.appendingPathComponent("search"), resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "keyword", value: query ?? ""),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let (data, response) = try await URLSession.shared.data(from: comps.url!)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoded = try JSONDecoder().decode(SearchResponseDTO.self, from: data)
        return decoded.data.response.map {
            Anime(id: $0.id, title: $0.title, posterURL: URL(string: $0.poster))
        }
    }

    // Anime details
    func fetchAnimeDetails(id: String) async throws -> AnimeDetail {
        let url = baseURL.appendingPathComponent("anime/\(id)")
        let (data, _) = try await URLSession.shared.data(from: url)
        let dto = try JSONDecoder().decode(AnimeDetailResponseDTO.self, from: data)
        let d = dto.data
        return AnimeDetail(
            id: d.id,
            title: d.title,
            description: d.synopsis,
            releaseDate: d.aired?.from,
            genres: d.genres
        )
    }

    // Episodes list
    func fetchEpisodes(animeId: String) async throws -> [Episode] {
        let url = baseURL.appendingPathComponent("episodes/\(animeId)")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(EpisodesResponseDTO.self, from: data)
        return decoded.data.map {
            Episode(id: $0.id, number: $0.number, title: $0.title, releaseDate: nil)
        }
    }

    // Stream URL
    func fetchStreamURL(episodeId: String, server: String = "HD-1", type: String = "sub") async throws -> URL {
        var comps = URLComponents(url: baseURL.appendingPathComponent("stream"), resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            URLQueryItem(name: "id", value: episodeId),
            URLQueryItem(name: "server", value: server),
            URLQueryItem(name: "type", value: type)
        ]
        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        let dto = try JSONDecoder().decode(StreamResponseDTO.self, from: data)
        guard let link = dto.data.streamingLink.file, let u = URL(string: link) else {
            throw URLError(.badURL)
        }
        return u
    }

    // Optional: download episode (stub)
    func downloadEpisode(episodeId: String) async throws -> URL? {
        // TODO: Implement HLS/MP4 download if needed
        return nil
    }
}
