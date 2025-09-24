import SwiftUI

struct AnimeRow: View {
    let anime: Anime
    let isFavorite: Bool
    let toggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: anime.posterURL) { phase in
                switch phase {
                case .empty: Color.gray.opacity(0.2)
                case .success(let image): image.resizable().scaledToFill()
                case .failure: Color.red.opacity(0.2)
                @unknown default: Color.gray
                }
            }
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading) {
                Text(anime.title).font(.headline)
                Text("Tap for details").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .primary)
            }
            .buttonStyle(.plain)
        }
    }
}
