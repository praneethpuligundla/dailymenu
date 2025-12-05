import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        List(viewModel.entries, id: \.id) { entry in
            if let activity = entry.activity, let completedAt = entry.completedAt {
                VStack(alignment: .leading) {
                    Text(activity.title ?? "Untitled").font(Theme.headerFont())
                    Text(completedAt, style: .date).font(Theme.captionFont())
                }
            }
        }
        .navigationTitle("History")
        .onAppear { viewModel.loadHistory() }
    }
}

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var entries: [HistoryEntryEntity] = []
    private let store = Store.shared

    func loadHistory() {
        entries = store.fetchHistoryEntries()
    }

    func logCompletion(activity: ActivityEntity) {
        let entry = HistoryEntryEntity(context: store.viewContext)
        entry.id = UUID()
        entry.activity = activity
        entry.completedAt = Date()
        store.save()
    }
}
