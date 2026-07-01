import SwiftUI

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
