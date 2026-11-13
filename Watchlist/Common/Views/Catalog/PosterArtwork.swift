import SwiftUI
import Kingfisher

/// The container owns the size, so a downloaded image never expands a grid cell.
struct PosterArtwork: View {
    let url: String
    var aspectRatio: CGFloat = 2 / 3
    var symbol = "film"

    var body: some View {
        Rectangle()
            .fill(.quaternary)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay {
                GeometryReader { geometry in
                    KFImage(URL(string: url))
                        .placeholder {
                            Image(systemName: symbol)
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .accessibilityHidden(true)
    }
}
