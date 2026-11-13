import SwiftUI

struct DiscoverSliceItem: View {
    let item: Watchable

    var body: some View {
        NavigationLink {
            MediaDestinationView(item: item)
        } label: {
            MediaPosterCard(item: item)
        }
        .buttonStyle(.plain)
    }
}
