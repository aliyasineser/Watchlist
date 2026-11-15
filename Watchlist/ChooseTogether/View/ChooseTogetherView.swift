import SwiftUI

struct ChooseTogetherView: View {
    @State var presenter: GroupChoicePresenterImpl
    @State private var ending = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if scenePhase != .active && presenter.phase != .setup {
                ContentUnavailableView("Round paused", systemImage: "hand.raised")
            } else {
                switch presenter.phase {
                case .setup: GroupChoiceSetupView(presenter: presenter)
                case .voting: voting
                case .handoff: handoff
                case .results: GroupChoiceResultsView(presenter: presenter)
                }
            }
        }
        .navigationTitle("Choose together")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if presenter.phase != .setup {
                ToolbarItem(placement: .topBarTrailing) { Button("End round") { ending = true } }
            }
        }
        .confirmationDialog("Clear all votes and return to setup?", isPresented: $ending, titleVisibility: .visible) {
            Button("End round", role: .destructive) { presenter.reset() }
        }
        .task { await presenter.store.load() }
        .onChange(of: presenter.store.revision) { _, _ in presenter.reconcileSetup() }
        .errorAlert(error: $presenter.error)
    }

    private var voting: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(presenter.currentParticipant).font(.title2.bold())
                Text("Title \(presenter.titleIndex + 1) of \(presenter.titleCount)")
                    .font(.subheadline).foregroundStyle(.secondary)
                if let title = presenter.currentTitle {
                    PosterArtwork(url: presenter.store.artworkURL(for: title))
                        .frame(maxWidth: 180)
                    Text(title.title).font(.title2.bold()).multilineTextAlignment(.center)
                    Button("Interested", systemImage: "hand.thumbsup") { presenter.vote(interested: true) }
                        .buttonStyle(.borderedProminent)
                        .accessibilityIdentifier("together.interested")
                    Button("Skip", systemImage: "forward") { presenter.vote(interested: false) }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier("together.skip")
                    if presenter.canUndo { Button("Undo my last vote") { presenter.undoVote() } }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(20)
        }
    }
    private var handoff: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.2").font(.largeTitle)
            Text("Pass the phone to \(presenter.currentParticipant)")
                .font(.title2.bold()).multilineTextAlignment(.center)
            Text("Previous votes stay hidden. Continue when the next viewer is ready.")
                .foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button("I’m ready") { presenter.beginNextViewer() }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("together.nextViewer")
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
