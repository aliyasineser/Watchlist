import SwiftUI

struct MediaDetailsView: View {
    let title: String
    var genres: String?
    var rating: Double?
    var language: OriginalLanguage?
    var date: Date?
    var time: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
            if let genres, !genres.isEmpty {
                Text(genres)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let rating, rating > 0 {
                Label("\(rating.formatted(.number.precision(.fractionLength(1)))) / 10", systemImage: "star.fill")
                    .font(.subheadline.weight(.semibold))
            }
            if let date {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let language {
                Text(language.language)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let time {
                Text(time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
