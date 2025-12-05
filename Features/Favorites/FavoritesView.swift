import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()

    var body: some View {
        List {
            ForEach(viewModel.favorites, id: \.id) { favorite in
                if let activity = favorite.activity {
                    Text(activity.title ?? "Untitled")
                }
            }
        }
        .navigationTitle("Favorites")
        .onAppear { viewModel.loadFavorites() }
    }
}

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteEntity] = []
    private let store = Store.shared

    func loadFavorites() {
        favorites = store.fetchFavorites()
    }

    func toggleFavorite(activity: ActivityEntity) {
        if let existing = favorites.first(where: { $0.activity?.id == activity.id }) {
            store.viewContext.delete(existing)
        } else {
            let fav = FavoriteEntity(context: store.viewContext)
            fav.id = UUID()
            fav.activity = activity
            fav.createdAt = Date()
        }
        store.save()
        loadFavorites()
    }
}
