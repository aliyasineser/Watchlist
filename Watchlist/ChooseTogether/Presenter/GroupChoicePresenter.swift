import Foundation
import Observation

@MainActor
@Observable
final class GroupChoicePresenterImpl {
    let store: WatchLibraryStoreImpl
    var sourceID: String? { didSet { selectedIDs = [] } }
    var query = ""
    var error: Error?
    private(set) var phase = GroupChoicePhase.setup
    private(set) var participantNames = ["Viewer 1", "Viewer 2"]
    private(set) var selectedIDs: Set<String> = []
    private(set) var participantIndex = 0
    private(set) var titleIndex = 0
    private(set) var showClosest = false
    private(set) var pickedID: String?
    private var shortlist: [SavedTitle] = []
    private var votes: [[Bool?]] = []
    private let strategy: GroupChoiceStrategy
    private let choose: ([SavedTitle]) -> SavedTitle?

    init(store: WatchLibraryStoreImpl, strategy: GroupChoiceStrategy = GroupChoiceStrategyImpl(),
         choose: @escaping ([SavedTitle]) -> SavedTitle? = { $0.randomElement() }) {
        self.store = store
        self.strategy = strategy
        self.choose = choose
    }
    var candidates: [WatchEntry] {
        if let sourceID {
            guard let list = store.customList(sourceID) else { return [] }
            let entries = Dictionary(uniqueKeysWithValues: store.entries.map { ($0.id, $0) })
            return list.items.compactMap { entries[$0.titleID] }
        }
        return store.filtered(status: nil, type: nil, sort: .dateAdded).filter { $0.status != .watched }
    }
    var visibleCandidates: [WatchEntry] {
        candidates.filter { query.isEmpty || $0.title.title.localizedCaseInsensitiveContains(query) }
    }
    var currentTitle: SavedTitle? {
        guard phase == .voting, shortlist.indices.contains(titleIndex) else { return nil }
        return shortlist[titleIndex]
    }
    var currentParticipant: String {
        participantNames.indices.contains(participantIndex) ? participantNames[participantIndex] : "Viewer"
    }
    var titleCount: Int { shortlist.count }
    var canUndo: Bool { phase == .voting && titleIndex > 0 }
    var ranked: [GroupChoiceResult] {
        guard phase == .results else { return [] }
        let existing = Set(store.entries.map(\.id))
        return strategy.results(titles: shortlist, votes: votes).filter { existing.contains($0.id) }
    }
    var mutual: [GroupChoiceResult] { ranked.filter(\.unanimous) }
    var eligible: [GroupChoiceResult] {
        let results = ranked
        let unanimous = results.filter(\.unanimous)
        if !unanimous.isEmpty { return unanimous }
        guard showClosest, let highest = results.first?.interested, highest > 0 else { return [] }
        return results.filter { $0.interested == highest }
    }
    var picked: GroupChoiceResult? { eligible.first { $0.id == pickedID } }

    func setParticipantCount(_ count: Int) {
        guard phase == .setup, (2...8).contains(count) else { return }
        participantNames = (0..<count).map {
            participantNames.indices.contains($0) ? participantNames[$0] : "Viewer \($0 + 1)"
        }
    }
    func setName(_ value: String, at index: Int) {
        guard phase == .setup, participantNames.indices.contains(index) else { return }
        participantNames[index] = value
    }
    func toggleSelection(_ id: String) {
        guard phase == .setup else { return }
        if selectedIDs.contains(id) { selectedIDs.remove(id); return }
        guard selectedIDs.count < 20 else { error = GroupChoiceError.invalidShortlist; return }
        if candidates.contains(where: { $0.id == id }) { selectedIDs.insert(id) }
    }
    func start() {
        guard phase == .setup else { return }
        let selected = candidates.filter { selectedIDs.contains($0.id) }.map(\.title)
        guard (1...20).contains(selected.count) else { error = GroupChoiceError.invalidShortlist; return }
        guard (2...8).contains(participantNames.count), participantNames.allSatisfy({ $0.count <= 40 }) else {
            error = GroupChoiceError.invalidParticipants
            return
        }
        participantNames = participantNames.enumerated().map { index, name in
            let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? "Viewer \(index + 1)" : trimmed
        }
        shortlist = selected
        votes = Array(repeating: Array(repeating: nil, count: selected.count), count: participantNames.count)
        participantIndex = 0
        titleIndex = 0
        pickedID = nil
        showClosest = false
        error = nil
        phase = .voting
    }
    func vote(interested: Bool) {
        guard phase == .voting, votes.indices.contains(participantIndex), shortlist.indices.contains(titleIndex) else {
            return
        }
        votes[participantIndex][titleIndex] = interested
        if titleIndex + 1 < shortlist.count { titleIndex += 1 } else if participantIndex + 1 < participantNames.count {
            participantIndex += 1
            titleIndex = 0
            phase = .handoff
        } else { phase = .results }
    }
    func undoVote() {
        guard canUndo else { return }
        titleIndex -= 1
        votes[participantIndex][titleIndex] = nil
    }
    func beginNextViewer() { if phase == .handoff { phase = .voting } }
    func revealClosest() {
        guard phase == .results else { return }
        showClosest = true
        pickedID = nil
    }
    func pick() {
        guard phase == .results else { return }
        let pool = eligible.map(\.title)
        pickedID = choose(pool).flatMap { result in pool.contains { $0.id == result.id } ? result.id : nil }
    }
    func reset() {
        votes = []
        shortlist = []
        pickedID = nil
        showClosest = false
        participantIndex = 0
        titleIndex = 0
        error = nil
        query = ""
        phase = .setup
        reconcileSetup()
    }
    func reconcileSetup() {
        guard phase == .setup else { return }
        if let sourceID, store.customList(sourceID) == nil { self.sourceID = nil }
        selectedIDs.formIntersection(Set(candidates.map(\.id)))
    }
}
