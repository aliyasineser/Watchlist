import SwiftUI

struct DiscoverSlice: View {
    let sliceTitle: String
    let sliceItems: [Watchable]
    let section: MediaSection

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                CatalogSectionHeader(title: sliceTitle)
                NavigationLink {
                    MediaListView(
                        mediaListPresenter: MediaListDefaultPresenter(DefaultMediaInteractor(), section: section)
                    )
                    .navigationTitle(sliceTitle)
                } label: {
                    Label("See all", systemImage: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .fixedSize()
                        .frame(minHeight: 44)
                }
                .accessibilityLabel("See all \(sliceTitle.lowercased())")
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(sliceItems, id: \.id) { item in
                        DiscoverSliceItem(item: item)
                            .frame(width: 144)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 20, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}
