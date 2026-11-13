import SwiftUI

struct MediaListItemView: View {
    let mediaListItem: Watchable

    var body: some View {
        NavigationLink {
            MediaDestinationView(item: mediaListItem)
        } label: {
            HStack(alignment: .top, spacing: 16) {
                PosterArtwork(url: mediaListItem.posterUrl)
                    .frame(width: 92)
                VStack(alignment: .leading, spacing: 8) {
                    Text(mediaListItem.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    if let rating = mediaListItem.voteAverage, rating > 0 {
                        Label(rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    if let overview = mediaListItem.overview {
                        Text(overview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}
