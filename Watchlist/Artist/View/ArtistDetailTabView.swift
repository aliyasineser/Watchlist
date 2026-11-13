import SwiftUI

struct ArtistDetailTabView: View {
    @State private var tabIndex = 0
    let artistDetail: ArtistDetail
    let artistMovieCredits: [Cast]
    let artistTVSerieCredits: [Cast]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ArtistDetailTopTabBar(tabIndex: $tabIndex)
            if tabIndex == 0 {
                Text(biography)
                    .font(.body)
                    .lineSpacing(5)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                if artistMovieCredits.isEmpty && artistTVSerieCredits.isEmpty {
                    ContentUnavailableView("No credits available", systemImage: "film")
                }
                ForEach(artistMovieCredits, id: \.creditID) { credit in
                    NavigationLink {
                        MovieDetailView(
                            presenter: MovieDetailDefaultPresenter(
                                interactor: DefaultMovieDetailInteractor(), id: credit.id
                            )
                        )
                    } label: {
                        creditRow(credit)
                    }
                    .buttonStyle(.plain)
                }
                ForEach(artistTVSerieCredits, id: \.creditID) { credit in
                    NavigationLink {
                        TVSerieDetailView(
                            presenter: TVSerieDetailDefaultPresenter(
                                interactor: DefaultTVSerieDetailInteractor(), id: credit.id
                            )
                        )
                    } label: {
                        creditRow(credit)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var biography: AttributedString {
        let text = artistDetail.biography.flatMap { $0.isEmpty ? nil : $0 } ?? "No biography available."
        let options = AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        return (try? AttributedString(markdown: text, options: options))
            ?? AttributedString(text)
    }

    private func creditRow(_ credit: Cast) -> some View {
        HStack(spacing: 16) {
            PosterArtwork(url: credit.getPosterUrl())
                .frame(width: 72)
            VStack(alignment: .leading, spacing: 6) {
                Text(credit.getTitle())
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(credit.getRole())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }
}

struct ArtistDetailTopTabBar: View {
    @Binding var tabIndex: Int

    var body: some View {
        Picker("Artist details", selection: $tabIndex) {
            Text("About").tag(0)
            Text("Filmography").tag(1)
        }
        .pickerStyle(.segmented)
    }
}
