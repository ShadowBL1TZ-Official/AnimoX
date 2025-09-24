import SwiftUI

struct DownloadsView: View {
    @StateObject private var dl = DownloadManager.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(dl.progressByEpisode.keys.sorted(), id: \.self) { epId in
                    HStack {
                        Text(epId).font(.footnote)
                        Spacer()
                        ProgressView(value: dl.progressByEpisode[epId] ?? 0)
                            .frame(width: 120)
                    }
                }
            }
            .navigationTitle("Downloads")
        }
    }
}
