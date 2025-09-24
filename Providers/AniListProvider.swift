import Foundation

/// Metadata-only provider sample. Useful to augment titles, descriptions, and airing schedules.
final class AniListProvider: SourceProvider {
    let name = "AniList"
    private let client = GraphQLClient(endpoint: URL(string: "https://graphql.anilist.co")!)

    func fetchCatalog(page: Int, query: String?) async throws -> [Anime] {
        // Minimal example using AniList search
        let q = """
        query ($page: Int, $search: String) {
          Page(page: $page, perPage: 20) {
            media(search: $search, type: ANIME) {
              id
              title { romaji english native }
              coverImage { large }
            }
          }
        }
        """
        let data = try await client.query(q, variables: [
            "page": AnyEncodable(page),
            "search": AnyEncodable(query ?? "")
        ])
        // Parse JSON to Anime list
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let pageDict = ((json?["data"] as? [String: Any])?["Page"] as? [String: Any]) ?? [:]
        let media = (pageDict["media"] as? [[String: Any]]) ?? []

        var result: [Anime] = []
        for m in media {
            let id = String(m["id"] as? Int ?? 0)
            let titleDict = m["title"] as? [String: Any]
            let title = (titleDict?["english"] as? String) ?? (titleDict?["romaji"] as? String) ?? "Unknown"
            let coverDict = m["coverImage"] as? [String: Any]
            let urlStr = coverDict?["large"] as? String
            let posterURL = urlStr.flatMap(URL.init(string:))
            result.append(Anime(id: id, title: title, posterURL: posterURL))
        }
        return result
    }

    func fetchAnimeDetails(id: String) async throws -> AnimeDetail {
        let q = """
        query ($id: Int) {
          Media(id: $id, type: ANIME) {
            id
            title { romaji english native }
            description
            genres
            nextAiringEpisode { airingAt }
          }
        }
        """
        let data = try await client.query(q, variables: ["id": AnyEncodable(Int(id) ?? 0)])
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        let media = ((json?["data"] as? [String: Any])?["Media"] as? [String: Any]) ?? [:]

        let titleDict = media["title"] as? [String: Any]
        let title = (titleDict?["english"] as? String) ?? (titleDict?["romaji"] as? String) ?? "Unknown"
        let description = (media["description"] as? String) ?? ""
        let genres = (media["genres"] as? [String]) ?? []
        let nextAiring = (media["nextAiringEpisode"] as? [String: Any])?["airingAt"] as? Int
        let releaseDate = nextAiring.map { Date(timeIntervalSince1970: TimeInterval($0)) }

        return AnimeDetail(id: id, title: title, description: description, releaseDate: releaseDate, genres: genres)
    }

    func fetchEpisodes(animeId: String) async throws -> [Episode] {
        // AniList doesn't give full episode list universally; this is a placeholder using airing schedule if needed.
        return []
    }

    func fetchStreamURL(episodeId: String) async throws -> URL {
        throw NSError(domain: "AniList", code: -1, userInfo: [NSLocalizedDescriptionKey: "AniList does not provide streams"])
    }
}
