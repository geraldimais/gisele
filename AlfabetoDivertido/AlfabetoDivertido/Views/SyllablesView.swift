import SwiftUI

struct SyllablesView: View {
    @State private var selectedConsonant: String = "B"

    private let consonantColumns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 6
    )
    private let syllableColumns = Array(
        repeating: GridItem(.flexible(), spacing: 14),
        count: 5
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                sectionTitle("Escolha uma consoante")

                LazyVGrid(columns: consonantColumns, spacing: 10) {
                    ForEach(LiteracyData.consonants, id: \.self) { consonant in
                        Button {
                            selectedConsonant = consonant
                        } label: {
                            Text(consonant)
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundStyle(consonant == selectedConsonant ? .white : Color.primary)
                                .frame(maxWidth: .infinity, minHeight: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(consonant == selectedConsonant
                                              ? Color.accentColor
                                              : Color(.secondarySystemBackground))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }

                sectionTitle("Sílabas com \(selectedConsonant)")

                LazyVGrid(columns: syllableColumns, spacing: 14) {
                    ForEach(LiteracyData.vowels, id: \.self) { vowel in
                        let syllable = selectedConsonant + vowel
                        Button {
                            SpeechService.shared.speakSyllable(syllable)
                        } label: {
                            Text(syllable)
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 76)
                                .background(
                                    LinearGradient(
                                        colors: gradientFor(vowel: vowel),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .shadow(color: gradientFor(vowel: vowel).first?.opacity(0.4) ?? .black.opacity(0.2), radius: 6, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Text("Toque em uma sílaba para ouvir 🔊")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Sílabas")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            SpeechService.shared.stop()
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.primary)
    }

    private func gradientFor(vowel: String) -> [Color] {
        switch vowel {
        case "A": return [Color(red: 0.98, green: 0.42, blue: 0.45), Color(red: 0.98, green: 0.29, blue: 0.55)]
        case "E": return [Color(red: 0.99, green: 0.62, blue: 0.29), Color(red: 0.98, green: 0.42, blue: 0.24)]
        case "I": return [Color(red: 0.98, green: 0.80, blue: 0.24), Color(red: 0.99, green: 0.62, blue: 0.20)]
        case "O": return [Color(red: 0.42, green: 0.78, blue: 0.42), Color(red: 0.20, green: 0.62, blue: 0.42)]
        case "U": return [Color(red: 0.29, green: 0.68, blue: 0.90), Color(red: 0.35, green: 0.44, blue: 0.90)]
        default:  return [Color.gray, Color.gray.opacity(0.7)]
        }
    }
}

#Preview {
    NavigationStack {
        SyllablesView()
    }
}
