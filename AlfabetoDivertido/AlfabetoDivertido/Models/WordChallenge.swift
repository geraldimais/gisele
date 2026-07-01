import Foundation

struct WordChallenge: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let emoji: String

    var letters: [String] {
        word.uppercased().map { String($0) }
    }
}

enum WordChallengeData {
    static let all: [WordChallenge] = [
        WordChallenge(word: "GATO", emoji: "🐱"),
        WordChallenge(word: "BOLA", emoji: "⚽️"),
        WordChallenge(word: "PATO", emoji: "🦆"),
        WordChallenge(word: "SOL", emoji: "☀️"),
        WordChallenge(word: "LUA", emoji: "🌙"),
        WordChallenge(word: "CASA", emoji: "🏠"),
        WordChallenge(word: "MAO", emoji: "✋"),
        WordChallenge(word: "PE", emoji: "🦶"),
        WordChallenge(word: "OLHO", emoji: "👁️"),
        WordChallenge(word: "FLOR", emoji: "🌸"),
        WordChallenge(word: "PEIXE", emoji: "🐟"),
        WordChallenge(word: "URSO", emoji: "🐻")
    ]
}
