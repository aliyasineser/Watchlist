import Foundation

enum GroupChoicePhase: Equatable { case setup, voting, handoff, results }

struct GroupChoiceResult: Identifiable {
    let title: SavedTitle
    let interested: Int
    let participants: Int
    var id: String { title.id }
    var unanimous: Bool { participants > 0 && interested == participants }
}

protocol GroupChoiceStrategy {
    func results(titles: [SavedTitle], votes: [[Bool?]]) -> [GroupChoiceResult]
}

struct GroupChoiceStrategyImpl: GroupChoiceStrategy {
    func results(titles: [SavedTitle], votes: [[Bool?]]) -> [GroupChoiceResult] {
        guard !votes.isEmpty, votes.allSatisfy({ $0.count == titles.count && !$0.contains(nil) }) else { return [] }
        var ranked: [(offset: Int, result: GroupChoiceResult)] = []
        for (index, title) in titles.enumerated() {
            let interested = votes.filter { viewer in viewer[index] == true }.count
            let result = GroupChoiceResult(title: title, interested: interested, participants: votes.count)
            ranked.append((index, result))
        }
        ranked.sort { left, right in
            if left.result.interested != right.result.interested {
                return left.result.interested > right.result.interested
            }
            return left.offset < right.offset
        }
        return ranked.map { $0.result }
    }
}

enum GroupChoiceError: LocalizedError {
    case invalidShortlist, invalidParticipants
    var errorDescription: String? {
        switch self {
        case .invalidShortlist: "Choose between 1 and 20 saved titles for this round."
        case .invalidParticipants: "Choose 2–8 viewers and use names of at most 40 characters."
        }
    }
}
