import SwiftUI

struct MediaDetailContent: View {
    let media: WatchableDetail
    let date: Date?
    let mediaService: MediaService

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 20) {
                    PosterArtwork(url: media.posterUrl)
                        .frame(maxWidth: 220)
                        .frame(maxWidth: .infinity)
                    HStack(alignment: .top, spacing: 16) {
                        MediaDetailsView(
                            title: media.title,
                            genres: media.genres.map(\.name).joined(separator: " · "),
                            rating: media.voteAverage,
                            language: media.originalLanguage,
                            date: date,
                            time: nil
                        )
                        Spacer(minLength: 0)
                    }
                }
                .padding(20)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24))

                WatchStatusControl(title: SavedTitle(media: media), refreshMetadata: true)
                if media is TvDetail {
                    NavigationLink("Episode progress") {
                        EpisodeProgressView(presenter: EpisodePresenterImpl(
                            title: SavedTitle(media: media), store: .shared
                        ))
                    }
                }

                if let overview = media.overview, !overview.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        CatalogSectionHeader(title: "Story")
                        Text(overview)
                            .font(.body)
                            .lineSpacing(5)
                            .textSelection(.enabled)
                    }
                }
                MediaDetailTabView(media.id, mediaService: mediaService)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}
