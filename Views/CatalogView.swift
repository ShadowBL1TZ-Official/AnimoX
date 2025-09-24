import SwiftUI

struct CatalogView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var sourceManager = SourceManager.shared

    @State private var query: String = ""
    @State private var page: Int = 1
    @State private var loading = false
    @State private var items: [Anime] = []
    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            Group {
                if loading {
                    ProgressView("Loading...")
                } else if let err = errorText {
                    Text(err).foregroundColor(.red)
                } else {
                    List(items) { anime in
                        NavigationLink {
                            AnimeDetailView(animeId: anime.id, title: anime.title)
                        } label {
                            AnimeRow(anime: anime, isFavorite: appState.isFavorite(anime.id)) {
                                appState.toggleFavorite(anime.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("AnimoX")
            .searchable(text: $query)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Source") {
                        Button("HiAnime") { sourceManager.switchTo(HiAnimeProvider()); refresh() }
                        Button("AniList") { sourceManager.switchTo(AniListProvider()); refresh() }
                    }
                }
            }
            .onSubmit(of: .search) { refresh(resetPage: true) }
            .onAppear { refresh(resetPage: true) }
        }
    }

    private func refresh(resetPage: Bool = false) {
        if resetPage { page = 1 }
        loading = true
        errorText = nil
        Task {
            do {
                items = try await sourceManager.provider.fetchCatalog(page: page, query: query.isEmpty ? nil : query)
            } catch {
                errorText = error.localizedDescription
            }
            loading = false
        }
    }
}
