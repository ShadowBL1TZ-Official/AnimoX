import Foundation

// MARK: - Search
struct SearchResponseDTO: Codable { let data: SearchData }
struct SearchData: Codable { let response: [AnimeDTO] }
struct AnimeDTO: Codable {
    let id: String
    let title: String
    let poster: String
}

// MARK: - Anime Details
struct AnimeDetailResponseDTO: Codable { let data: AnimeDetailDTO }
struct AnimeDetailDTO: Codable {
    let id: String
    let title: String
    let synopsis: String
    let genres: [String]
    let aired: AiredDates?
}
struct AiredDates: Codable { let from: String?; let to: String? }

// MARK: - Episodes
struct EpisodesResponseDTO: Codable { let data: [EpisodeDTO] }
struct EpisodeDTO: Codable { let id: String; let number: Int; let title: String }

// MARK: - Stream
struct StreamResponseDTO: Codable { let data: StreamData }
struct StreamData: Codable { let streamingLink: StreamingLink }
struct StreamingLink: Codable { let file: String? }
