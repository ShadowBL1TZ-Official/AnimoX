import SwiftUI

struct AnimeDetailView: View {
    let animeId: String
    let title: String

    @StateObject private var sourceManager = SourceManager.shared
    @State private var detail: AnimeDetail?
    @State private var episodes: [Episode] = []
    @State private var loading = false
    @State private var errorText: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(detail?.title ?? title).font(.title2).bold()

                if let d = detail {
                    Text(d.description).font(.body)
                    if let rd = d.releaseDate {
                        Text("Next episode: \(DateFormats.release.string(from: rd))").font(.subheadline).foregroundStyle(.secondary)
                    }
                    if !d.genres.isEmpty {
                        Text("Genres: \(d.genres.joined(separator: ", "))").font(.footnote)
                    }
                }

                Divider()

                Text("Episodes").font(.headline)
                if episodes.isEmpty && loading {
                    ProgressView()
                } else if let err = errorText {
                    Text(err).foregroundColor(.red)
                } else {
                    ForEach(episodes) { ep in
                        EpisodeRow(episode: ep)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .onAppear { load() }
    }

    private func load() {
        loading = true
        Task {
            do {
                detail = try await sourceManager.provider.fetchAnimeDetails(id: animeId)
                episodes = try await sourceManager.provider.fetchEpisodes(animeId: animeId)
            } catch {
                errorText = error.localizedDescription
            }
            loading = false
        }
    }
}

struct EpisodeRow: View {
    let episode: Episode
    @StateObject private var sourceManager = SourceManager.shared
    @StateObject private var downloadManager = DownloadManager.shared
    @State private var presentingPlayer = false
    @State private var streamURL: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Episode \(episode.number): \(episode.title)").font(.subheadline)
                Spacer()
                if let date = episode.releaseDate {
                    Text(DateFormats.release.string(from: date)).font(.caption).foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 12) {
                Button("Play") {
                    Task {
                        do {
                            streamURL = try await sourceManager.provider.fetchStreamURL(episodeId: episode.id)
                            presentingPlayer = true
                        } catch {
                            // Handle error
                        }
                    }
                }
                .buttonStyle(.bordered)

                Button("Download") {
                    Task {
                        do {
                            let url = try await sourceManager.provider.fetchStreamURL(episodeId: episode.id)
                            downloadManager.enqueue(episodeId: episode.id, from: url)
                        } catch {
                            // Handle error
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                if let progress = downloadManager.progressByEpisode[episode.id] {
                    ProgressView(value: progress)
                        .frame(width: 120)
                }
            }
        }
        .sheet(isPresented: $presentingPlayer) {
            if let url = streamURL {
                PlayerView(url: url)
            }
        }
    }
}
