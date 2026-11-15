import SwiftUI

struct GroupChoiceResultsView: View {
    @State var presenter: GroupChoicePresenterImpl
    var body: some View {
        List {
            Section {
                if presenter.mutual.isEmpty {
                    Text("No mutual matches").font(.title2.bold())
                    Text("Try a new shortlist, or reveal the highest-ranked alternatives.")
                        .foregroundStyle(.secondary)
                    if !presenter.showClosest {
                        Button("Show closest matches") { presenter.revealClosest() }
                    }
                } else {
                    Text("Your mutual matches").font(.title2.bold())
                    Text("Everyone chose Interested for these titles.").foregroundStyle(.secondary)
                }
            }
            if let picked = presenter.picked {
                Section("Tonight’s pick") {
                    resultLink(picked)
                        .accessibilityIdentifier("together.pick")
                }
            }
            Section(presenter.mutual.isEmpty ? "Closest matches" : "Shortlist") {
                ForEach(presenter.eligible) { resultLink($0) }
                Button("Pick for us", systemImage: "shuffle") { presenter.pick() }
                    .disabled(presenter.eligible.isEmpty)
                    .accessibilityIdentifier("together.shuffle")
            }
            Section {
                Text("Only aggregate votes are shown. Removed library titles are excluded. "
                     + "Votes are cleared when you leave this round or start over.")
                    .font(.footnote).foregroundStyle(.secondary)
                Button("Start another round") { presenter.reset() }
            }
        }
    }
    private func resultLink(_ result: GroupChoiceResult) -> some View {
        NavigationLink {
            SavedTitleDetailView(title: result.title, store: presenter.store)
        } label: {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.title.title).font(.headline)
                Text("\(result.interested) of \(result.participants) interested")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
}
