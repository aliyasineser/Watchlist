import SwiftUI

struct MediaPosterCard: View {
    let item: Watchable

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PosterArtwork(url: item.posterUrl)
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                if let rating = item.voteAverage, rating > 0 {
                    Label(rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(
                            "Rating \(rating.formatted(.number.precision(.fractionLength(1)))) out of 10"
                        )
                } else {
                    Text("Not yet rated")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}
