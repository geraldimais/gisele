import SwiftUI

struct WordBuilderView: View {
    @State private var currentIndex: Int = Int.random(in: 0..<WordChallengeData.all.count)
    @State private var typed: [String] = []
    @State private var shuffled: [String] = []
    @State private var showSuccess: Bool = false

    private var challenge: WordChallenge {
        WordChallengeData.all[currentIndex]
    }

    private let slotColumns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 6
    )
    private let letterColumns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 5
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(challenge.emoji)
                    .font(.system(size: 120))
                    .padding(.top, 12)

                Text("Forme a palavra")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                slotsRow

                if showSuccess {
                    successBanner
                }

                Divider().padding(.horizontal, 40)

                Text("Toque nas letras")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: letterColumns, spacing: 12) {
                    ForEach(shuffled.indices, id: \.self) { idx in
                        let letter = shuffled[idx]
                        Button {
                            tap(letter: letter, atSourceIndex: idx)
                        } label: {
                            Text(letter)
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(
                                    LinearGradient(
                                        colors: [Color(red: 0.38, green: 0.72, blue: 0.99), Color(red: 0.54, green: 0.44, blue: 0.95)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: .blue.opacity(0.25), radius: 5, x: 0, y: 3)
                        }
                        .buttonStyle(.plain)
                        .opacity(letter.isEmpty ? 0.25 : 1.0)
                        .disabled(letter.isEmpty)
                    }
                }

                HStack(spacing: 12) {
                    Button {
                        reset()
                    } label: {
                        Label("Limpar", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(Color(.secondarySystemBackground), in: Capsule())
                            .foregroundStyle(.primary)
                    }

                    Button {
                        nextChallenge()
                    } label: {
                        Label("Próxima", systemImage: "arrow.right.circle.fill")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            .background(Color.accentColor, in: Capsule())
                            .foregroundStyle(.white)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationTitle("Formar Palavras")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupShuffled()
        }
    }

    private var slotsRow: some View {
        LazyVGrid(columns: slotColumns, spacing: 8) {
            ForEach(challenge.letters.indices, id: \.self) { idx in
                let filled = idx < typed.count ? typed[idx] : ""
                Text(filled)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.accentColor.opacity(0.6), style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.accentColor.opacity(filled.isEmpty ? 0.05 : 0.18))
                            )
                    )
            }
        }
    }

    private var successBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 22, weight: .bold))
            Text("Muito bem! 🎉")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.green, in: Capsule())
        .shadow(color: .green.opacity(0.35), radius: 6, x: 0, y: 4)
    }

    private func setupShuffled() {
        typed = []
        showSuccess = false
        shuffled = challenge.letters.shuffled()
    }

    private func tap(letter: String, atSourceIndex idx: Int) {
        guard typed.count < challenge.letters.count else { return }
        let expected = challenge.letters[typed.count]
        guard letter == expected else {
            SpeechService.shared.speak("Tente de novo")
            return
        }
        typed.append(letter)
        shuffled[idx] = ""
        SpeechService.shared.speak(letter)

        if typed.count == challenge.letters.count {
            showSuccess = true
            SpeechService.shared.speak(challenge.word)
        }
    }

    private func reset() {
        setupShuffled()
    }

    private func nextChallenge() {
        var next = Int.random(in: 0..<WordChallengeData.all.count)
        if WordChallengeData.all.count > 1 {
            while next == currentIndex {
                next = Int.random(in: 0..<WordChallengeData.all.count)
            }
        }
        currentIndex = next
        setupShuffled()
    }
}

#Preview {
    NavigationStack {
        WordBuilderView()
    }
}
