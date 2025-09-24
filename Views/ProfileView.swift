import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var sourceManager = SourceManager.shared

    var body: some View {
        Form {
            Section("Provider") {
                Text("Active: \(sourceManager.provider.name)")
            }
            Section("Favorites") {
                Text("Count: \(appState.favorites.count)")
            }
            Section("About") {
                Text("AnimoX • Personal build")
                Text("Streaming source modules are pluggable.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Profile")
    }
}
