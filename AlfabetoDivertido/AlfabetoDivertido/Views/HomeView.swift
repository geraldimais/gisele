import SwiftUI

struct HomeView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    LazyVGrid(columns: columns, spacing: 16) {
                        NavigationLink(value: HomeDestination.alphabet) {
                            ActivityCard(
                                title: "Alfabeto",
                                subtitle: "Conheça as letras de A a Z",
                                systemImage: "textformat.abc",
                                colors: [Color(red: 0.99, green: 0.55, blue: 0.35), Color(red: 0.98, green: 0.35, blue: 0.42)]
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HomeDestination.syllables) {
                            ActivityCard(
                                title: "Sílabas",
                                subtitle: "Junte consoantes e vogais",
                                systemImage: "text.bubble.fill",
                                colors: [Color(red: 0.38, green: 0.72, blue: 0.99), Color(red: 0.54, green: 0.44, blue: 0.95)]
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HomeDestination.wordBuilder) {
                            ActivityCard(
                                title: "Formar Palavras",
                                subtitle: "Toque as letras na ordem certa",
                                systemImage: "square.grid.3x2.fill",
                                colors: [Color(red: 0.42, green: 0.82, blue: 0.44), Color(red: 0.16, green: 0.62, blue: 0.55)]
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(value: HomeDestination.quiz) {
                            ActivityCard(
                                title: "Quiz",
                                subtitle: "Descubra a letra inicial",
                                systemImage: "questionmark.circle.fill",
                                colors: [Color(red: 0.98, green: 0.78, blue: 0.28), Color(red: 0.98, green: 0.48, blue: 0.28)]
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.98, blue: 0.94), Color(red: 0.94, green: 0.97, blue: 1.0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Alfabeto Divertido")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .alphabet: AlphabetView()
                case .syllables: SyllablesView()
                case .wordBuilder: WordBuilderView()
                case .quiz: QuizView()
                }
            }
            .navigationDestination(for: Letter.self) { letter in
                LetterDetailView(letter: letter)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Olá! 👋")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            Text("Vamos aprender a ler?")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .foregroundStyle(.primary)
            Text("Escolha uma atividade abaixo para começar.")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

enum HomeDestination: Hashable {
    case alphabet
    case syllables
    case wordBuilder
    case quiz
}

#Preview {
    HomeView()
}
