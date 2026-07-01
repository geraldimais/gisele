import SwiftUI

struct AlphabetView: View {
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 14),
        count: 4
    )

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(LiteracyData.letters) { letter in
                    NavigationLink(value: letter) {
                        letterTile(letter)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
        }
        .background(
            Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea()
        )
        .navigationTitle("Alfabeto")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func letterTile(_ letter: Letter) -> some View {
        VStack(spacing: 4) {
            Text(letter.uppercase)
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            Text(letter.lowercase)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(
            LinearGradient(
                colors: [letter.color, letter.color.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: letter.color.opacity(0.35), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    NavigationStack {
        AlphabetView()
    }
}
