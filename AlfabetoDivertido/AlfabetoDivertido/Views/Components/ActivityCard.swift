import SwiftUI

struct ActivityCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)
                .padding(14)
                .background(
                    Circle().fill(.white.opacity(0.22))
                )

            Spacer(minLength: 8)

            Text(title)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 170, alignment: .leading)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: colors.first?.opacity(0.35) ?? .black.opacity(0.15), radius: 12, x: 0, y: 8)
    }
}

#Preview {
    ActivityCard(
        title: "Alfabeto",
        subtitle: "Aprenda as letras de A a Z",
        systemImage: "textformat.abc",
        colors: [Color.orange, Color.pink]
    )
    .padding()
}
