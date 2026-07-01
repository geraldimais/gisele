import SwiftUI

struct QuizView: View {
    @State private var currentLetter: Letter = LiteracyData.letters.randomElement()!
    @State private var options: [Letter] = []
    @State private var feedback: Feedback?
    @State private var score: Int = 0
    @State private var round: Int = 1

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 14),
        count: 2
    )

    enum Feedback: Equatable {
        case correct
        case wrong(String)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                scoreBar

                Text(currentLetter.emoji)
                    .font(.system(size: 140))
                    .padding(.top, 8)

                Text("Qual a primeira letra de\n\(currentLetter.exampleWord.uppercased())?")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 24)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(options) { option in
                        Button {
                            select(option)
                        } label: {
                            Text(option.uppercase)
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 90)
                                .background(
                                    LinearGradient(
                                        colors: [option.color, option.color.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: option.color.opacity(0.3), radius: 6, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)

                if let feedback {
                    feedbackBanner(feedback)
                }

                Button {
                    nextRound()
                } label: {
                    Label("Próxima", systemImage: "arrow.right.circle.fill")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 14)
                        .background(Color.accentColor, in: Capsule())
                        .foregroundStyle(.white)
                }
                .padding(.top, 6)
                .padding(.bottom, 30)
            }
            .padding(.top, 12)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            buildOptions()
        }
    }

    private var scoreBar: some View {
        HStack {
            Label("Rodada \(round)", systemImage: "flag.checkered")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground), in: Capsule())
            Spacer()
            Label("\(score) acertos", systemImage: "star.fill")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground), in: Capsule())
        }
        .padding(.horizontal, 20)
    }

    private func feedbackBanner(_ feedback: Feedback) -> some View {
        Group {
            switch feedback {
            case .correct:
                Label("Acertou! 🎉", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color.green, in: Capsule())
            case .wrong(let correct):
                Label("A resposta era \(correct)", systemImage: "xmark.seal.fill")
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(Color.red, in: Capsule())
            }
        }
        .font(.system(size: 16, weight: .heavy, design: .rounded))
    }

    private func buildOptions() {
        let pool = LiteracyData.letters.filter { $0.id != currentLetter.id }.shuffled()
        var picks = Array(pool.prefix(3))
        picks.append(currentLetter)
        options = picks.shuffled()
    }

    private func select(_ option: Letter) {
        guard feedback == nil else { return }
        if option.id == currentLetter.id {
            feedback = .correct
            score += 1
            SpeechService.shared.speak("Acertou! \(currentLetter.uppercase) de \(currentLetter.exampleWord).")
        } else {
            feedback = .wrong(currentLetter.uppercase)
            SpeechService.shared.speak("A resposta certa era \(currentLetter.uppercase).")
        }
    }

    private func nextRound() {
        var candidate = LiteracyData.letters.randomElement()!
        while candidate.id == currentLetter.id {
            candidate = LiteracyData.letters.randomElement()!
        }
        currentLetter = candidate
        feedback = nil
        round += 1
        buildOptions()
    }
}

#Preview {
    NavigationStack {
        QuizView()
    }
}
