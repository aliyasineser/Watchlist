import SwiftUI

struct LoadStateView: View {
    let isLoading: Bool
    let hasContent: Bool
    var hasMore = false
    let error: Error?
    var emptyMessage = "Nothing here yet"
    let retry: () async -> Void

    var body: some View {
        VStack(spacing: 12) {
            if isLoading {
                ProgressView("Loading…")
            } else if let error {
                Label("Couldn’t load this content", systemImage: "wifi.exclamationmark")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Try again") { Task { await retry() } }
                    .buttonStyle(.borderedProminent)
            } else if !hasContent {
                Label(emptyMessage, systemImage: "tray")
                    .foregroundStyle(.secondary)
            } else if hasMore {
                Button("Load more") { Task { await retry() } }
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.vertical, 16)
    }
}
