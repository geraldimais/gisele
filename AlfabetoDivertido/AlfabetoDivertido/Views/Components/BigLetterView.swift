import SwiftUI

struct BigLetterView: View {
    let letter: Letter

    var body: some View {
        VStack(spacing: 8) {
            Text(letter.uppercase)
                .font(.system(size: 200, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            Text(letter.lowercase)
                .font(.system(size: 80, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [letter.color, letter.color.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: letter.color.opacity(0.35), radius: 14, x: 0, y: 10)
    }
}

#Preview {
    BigLetterView(letter: LiteracyData.letters[0])
        .padding()
}
