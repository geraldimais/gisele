import SwiftUI

struct LetterDetailView: View {
    let letter: Letter
    @State private var isBouncing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                BigLetterView(letter: letter)
                    .padding(.horizontal, 20)

                Text(letter.emoji)
                    .font(.system(size: 120))
                    .scaleEffect(isBouncing ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                        value: isBouncing
                    )

                VStack(spacing: 6) {
                    Text(letter.exampleWord.uppercased())
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .foregroundStyle(letter.color)
                    Text("\(letter.uppercase) de \(letter.exampleWord)")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Button {
                    SpeechService.shared.speakLetter(letter)
                } label: {
                    Label("Ouvir de novo", systemImage: "speaker.wave.2.fill")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 14)
                        .background(letter.color, in: Capsule())
                        .foregroundStyle(.white)
                        .shadow(color: letter.color.opacity(0.35), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 8)
                .padding(.bottom, 30)
            }
            .padding(.top, 12)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationTitle(letter.uppercase)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isBouncing = true
            SpeechService.shared.speakLetter(letter)
        }
        .onDisappear {
            SpeechService.shared.stop()
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: LiteracyData.letters[0])
    }
}
