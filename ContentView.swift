import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var sourceManager = SourceManager.shared

    var body: some View {
        TabView {
            CatalogView()
                .tabItem {
                    Label("Catalog", systemImage: "film")
                }

            ListsView()
                .tabItem {
                    Label("Lists", systemImage: "text.badge.plus")
                }

            DownloadsView()
                .tabItem {
                    Label("Downloads", systemImage: "arrow.down.circle")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .onAppear { appState.loadPersisted() }
    }
}
