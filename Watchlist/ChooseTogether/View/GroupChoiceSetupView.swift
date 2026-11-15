import SwiftUI

struct GroupChoiceSetupView: View {
    @State var presenter: GroupChoicePresenterImpl
    var body: some View {
        List {
            Section("Who’s watching?") {
                Picker("Viewers", selection: Binding(
                    get: { presenter.participantNames.count }, set: { presenter.setParticipantCount($0) }
                )) {
                    ForEach(2...8, id: \.self) { Text("\($0)").tag($0) }
                }
                ForEach(presenter.participantNames.indices, id: \.self) { index in
                    TextField("Viewer \(index + 1)", text: Binding(
                        get: {
                            presenter.participantNames.indices.contains(index) ? presenter.participantNames[index] : ""
                        },
                        set: { presenter.setName($0, at: index) }
                    ))
                    .textInputAutocapitalization(.words)
                }
                Text("Names are optional, up to 40 characters. Votes are kept only in this round on this device.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            Section("Build your shortlist") {
                Picker("Source", selection: $presenter.sourceID) {
                    Text("Unwatched library").tag(String?.none)
                    ForEach(presenter.store.customLists) { Text($0.name).tag(String?.some($0.id)) }
                }
                Text("Choose 1–20 titles. Custom lists also allow rewatching titles marked Watched.")
                    .font(.footnote).foregroundStyle(.secondary)
                Text("\(presenter.selectedIDs.count) selected").font(.headline)
                ForEach(presenter.visibleCandidates) { entry in
                    Button { presenter.toggleSelection(entry.id) } label: {
                        HStack {
                            Text(entry.title.title).foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: presenter.selectedIDs.contains(entry.id)
                                  ? "checkmark.circle.fill" : "circle")
                        }
                    }
                    .accessibilityValue(presenter.selectedIDs.contains(entry.id) ? "Selected" : "Not selected")
                    .accessibilityIdentifier("together.select.\(entry.id)")
                }
                if presenter.candidates.isEmpty { Text("Save titles or choose a different list to start a round.") }
            }
            Section {
                Button("Start voting") { presenter.start() }
                    .disabled(presenter.selectedIDs.isEmpty)
                    .accessibilityIdentifier("together.start")
            }
        }
        .searchable(text: $presenter.query, prompt: "Search saved titles")
    }
}
