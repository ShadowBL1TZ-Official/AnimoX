import SwiftUI

struct ListsView: View {
    @EnvironmentObject var appState: AppState
    @State private var newListName: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("New list name", text: $newListName)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        guard !newListName.isEmpty else { return }
                        appState.addToList(listName: newListName, animeId: "demo-1") // Example hookup
                        newListName = ""
                    }
                }
                List {
                    ForEach(appState.lists) { list in
                        VStack(alignment: .leading) {
                            Text(list.name).font(.headline)
                            Text("Items: \(list.animeIds.count)").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                Spacer()
            }
            .padding()
            .navigationTitle("Lists")
        }
    }
}
