import SwiftUI

struct ArtistItemView: View {
    let artist: Creditable

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PosterArtwork(url: artist.getPosterUrl(), aspectRatio: 4 / 5, symbol: "person.crop.rectangle")
            Text(artist.getTitle())
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
            if let department = artist.getKnownForDepartment() {
                Text(department)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
