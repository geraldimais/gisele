import SwiftUI

struct Letter: Identifiable, Hashable {
    let id = UUID()
    let character: String
    let exampleWord: String
    let emoji: String
    let color: Color

    var uppercase: String { character.uppercased() }
    var lowercase: String { character.lowercased() }

    var pronunciation: String {
        "\(uppercase). \(exampleWord). \(exampleWord.first.map(String.init) ?? "") de \(exampleWord)."
    }

    static func == (lhs: Letter, rhs: Letter) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
