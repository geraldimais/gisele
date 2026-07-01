import Foundation

// Este harness compila as regras de domínio (Letter, LiteracyData, WordChallenge)
// no Linux usando Foundation puro. SwiftUI (Color) é substituído por um shim
// mínimo (Views/serviços de fala não são incluídos aqui — dependem de UIKit/
// AVFoundation/iOS). Roda como executável para validar os dados do app.

struct Color { init(red: Double, green: Double, blue: Double) {} }

// ────────────────────────────────────────────────────────────────────────────
// Cópia idêntica de AlfabetoDivertido/Models/Letter.swift
// ────────────────────────────────────────────────────────────────────────────
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

    static func == (lhs: Letter, rhs: Letter) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// ────────────────────────────────────────────────────────────────────────────
// Cópia idêntica de AlfabetoDivertido/Models/LiteracyData.swift
// ────────────────────────────────────────────────────────────────────────────
enum LiteracyData {
    static let palette: [Color] = [
        Color(red: 0.98, green: 0.42, blue: 0.45),
        Color(red: 0.99, green: 0.62, blue: 0.29),
        Color(red: 0.98, green: 0.80, blue: 0.24),
        Color(red: 0.42, green: 0.78, blue: 0.42),
        Color(red: 0.29, green: 0.68, blue: 0.90),
        Color(red: 0.58, green: 0.45, blue: 0.90),
        Color(red: 0.94, green: 0.44, blue: 0.72)
    ]

    static let letters: [Letter] = {
        let source: [(String, String, String)] = [
            ("A", "Abelha", "🐝"),
            ("B", "Bola", "⚽️"),
            ("C", "Cachorro", "🐶"),
            ("D", "Dado", "🎲"),
            ("E", "Elefante", "🐘"),
            ("F", "Foca", "🦭"),
            ("G", "Gato", "🐱"),
            ("H", "Hipopótamo", "🦛"),
            ("I", "Igreja", "⛪️"),
            ("J", "Jacaré", "🐊"),
            ("K", "Kiwi", "🥝"),
            ("L", "Leão", "🦁"),
            ("M", "Macaco", "🐵"),
            ("N", "Navio", "🚢"),
            ("O", "Ovo", "🥚"),
            ("P", "Pato", "🦆"),
            ("Q", "Queijo", "🧀"),
            ("R", "Rato", "🐭"),
            ("S", "Sapo", "🐸"),
            ("T", "Tartaruga", "🐢"),
            ("U", "Urso", "🐻"),
            ("V", "Vaca", "🐮"),
            ("W", "Wafer", "🍪"),
            ("X", "Xícara", "🍵"),
            ("Y", "Yoga", "🧘"),
            ("Z", "Zebra", "🦓")
        ]
        return source.enumerated().map { index, item in
            Letter(
                character: item.0,
                exampleWord: item.1,
                emoji: item.2,
                color: palette[index % palette.count]
            )
        }
    }()

    static let vowels: [String] = ["A", "E", "I", "O", "U"]
    static let consonants: [String] = [
        "B", "C", "D", "F", "G", "J", "L", "M", "N", "P",
        "Q", "R", "S", "T", "V", "X", "Z"
    ]
}

// ────────────────────────────────────────────────────────────────────────────
// Cópia idêntica de AlfabetoDivertido/Models/WordChallenge.swift
// ────────────────────────────────────────────────────────────────────────────
struct WordChallenge: Identifiable, Hashable {
    let id = UUID()
    let word: String
    let emoji: String
    var letters: [String] { word.uppercased().map { String($0) } }
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

// ────────────────────────────────────────────────────────────────────────────
// Suite de testes
// ────────────────────────────────────────────────────────────────────────────
var failures = 0
var checks = 0

func check(_ name: String, _ condition: @autoclosure () -> Bool) {
    checks += 1
    if condition() {
        print("  ✅ \(name)")
    } else {
        failures += 1
        print("  ❌ \(name)")
    }
}

print("─── Letter model ───")
let letterA = LiteracyData.letters[0]
check("uppercase() de 'A' == 'A'", letterA.uppercase == "A")
check("lowercase() de 'A' == 'a'", letterA.lowercase == "a")
check("pronunciation('A','Abelha') contém 'A. Abelha.'",
      letterA.pronunciation.contains("A. Abelha."))
check("pronunciation('A','Abelha') termina com 'A de Abelha.'",
      letterA.pronunciation.hasSuffix("A de Abelha."))
check("Letter equality por id",
      letterA == LiteracyData.letters[0] && letterA != LiteracyData.letters[1])

print("\n─── LiteracyData ───")
check("26 letras (A–Z)", LiteracyData.letters.count == 26)
check("primeira letra é A", LiteracyData.letters.first?.character == "A")
check("última letra é Z", LiteracyData.letters.last?.character == "Z")
check("5 vogais", LiteracyData.vowels.count == 5)
check("17 consoantes", LiteracyData.consonants.count == 17)
check("nenhuma consoante ∈ vogais",
      Set(LiteracyData.consonants).intersection(LiteracyData.vowels).isEmpty)
check("emojis distintos para todas as letras",
      Set(LiteracyData.letters.map(\.emoji)).count == 26)
check("exampleWord começa com a própria letra",
      LiteracyData.letters.allSatisfy { $0.exampleWord.uppercased().hasPrefix($0.character) })
check("caracteres únicos (sem duplicatas A–Z)",
      Set(LiteracyData.letters.map(\.character)).count == 26)

print("\n─── WordChallenge ───")
let gato = WordChallengeData.all[0]
check("GATO tem 4 letras", gato.letters == ["G", "A", "T", "O"])
check("todos os desafios têm emoji não vazio",
      WordChallengeData.all.allSatisfy { !$0.emoji.isEmpty })
check("todas as palavras têm ≥ 2 letras",
      WordChallengeData.all.allSatisfy { $0.letters.count >= 2 })
check("todas as letras dos desafios existem no alfabeto",
      WordChallengeData.all.allSatisfy { wc in
          let alphabet = Set(LiteracyData.letters.map(\.character))
          return wc.letters.allSatisfy { alphabet.contains($0) }
      })

print("\n─── Fluxo do Quiz (simulado) ───")
// Simula a lógica de buildOptions do QuizView
let quizTarget = LiteracyData.letters[5] // F
let pool = LiteracyData.letters.filter { $0.id != quizTarget.id }
var picks = Array(pool.prefix(3))
picks.append(quizTarget)
check("quiz sempre gera 4 opções", picks.count == 4)
check("opção correta está incluída", picks.contains(where: { $0.id == quizTarget.id }))
check("nenhuma opção duplicada",
      Set(picks.map(\.id)).count == picks.count)

print("\n─── Fluxo do WordBuilder (simulado) ───")
// Simula a lógica tap() do WordBuilderView com a palavra "BOLA"
let word = WordChallengeData.all[1] // BOLA
var typed: [String] = []
var shuffled = word.letters.shuffled()
func tap(letter: String, atSourceIndex idx: Int) -> Bool {
    guard typed.count < word.letters.count else { return false }
    let expected = word.letters[typed.count]
    guard letter == expected else { return false }
    typed.append(letter)
    shuffled[idx] = ""
    return true
}
// Preenche na ordem correta
for expected in word.letters {
    guard let idx = shuffled.firstIndex(of: expected) else { break }
    _ = tap(letter: expected, atSourceIndex: idx)
}
check("wordbuilder aceita todas as letras corretas",
      typed == word.letters)
check("shuffled zerado em todas as posições depois de completar",
      shuffled.allSatisfy { $0.isEmpty })

print("\n════════════════════════════════════════")
print("\(checks - failures)/\(checks) checks OK")
if failures > 0 {
    print("❌ FALHOU (\(failures) erros)")
    exit(1)
} else {
    print("✅ TODOS OS TESTES PASSARAM")
    exit(0)
}
