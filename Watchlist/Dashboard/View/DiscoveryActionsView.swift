import SwiftUI

struct DiscoveryActionsView: View {
    @State var store: WatchLibraryStoreImpl
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 14), count: dynamicTypeSize.isAccessibilitySize ? 1 : 2)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Make a plan").font(.title2.bold())
            LazyVGrid(columns: columns, spacing: 14) {
                NavigationLink {
                    WatchTonightView(presenter: WatchTonightPresenterImpl(store: store))
                } label: {
                    action("Watch tonight", subtitle: "A pick from your watchlist", symbol: "moon.stars.fill")
                }
                .accessibilityIdentifier("library.tonight")
                NavigationLink {
                    ChooseTogetherView(presenter: GroupChoicePresenterImpl(store: store))
                } label: {
                    action("Choose together", subtitle: "Pass the phone. Find a match.", symbol: "person.2.fill")
                }
                .accessibilityIdentifier("library.together")
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
    }
    private func action(_ title: String, subtitle: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: symbol).font(.title2).foregroundStyle(.tint)
                Spacer()
                Image(systemName: "chevron.right").font(.caption.weight(.semibold)).foregroundStyle(.secondary)
            }
            Text(title).font(.headline).foregroundStyle(.primary)
            Text(subtitle).font(.caption).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
    }
}
