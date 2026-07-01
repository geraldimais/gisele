# Alfabeto Divertido 📚✨

App para iPhone (SwiftUI) que ajuda crianças na fase de **alfabetização** a aprender letras, sílabas e palavras em português do Brasil, com feedback de voz nativa (`AVSpeechSynthesizer` em `pt-BR`).

## ✨ Funcionalidades

- **Alfabeto A–Z** — cartões coloridos, letras maiúscula/minúscula, emoji ilustrativo e narração da letra + palavra exemplo (ex.: "A. Abelha. A de Abelha.").
- **Sílabas** — escolha uma consoante e ouça a formação das sílabas com as 5 vogais (BA, BE, BI, BO, BU…).
- **Formar Palavras** — a criança monta a palavra tocando nas letras embaralhadas na ordem certa; feedback visual e sonoro ao acertar.
- **Quiz** — mostra um emoji e a criança escolhe a letra inicial da palavra entre 4 alternativas; sistema de pontuação por rodadas.
- **UI amigável** — cores vivas, cantos arredondados, fontes `.rounded`, animações suaves e navegação por `NavigationStack`.
- **Voz em português** — todos os textos são pronunciados em `pt-BR` usando `AVSpeechSynthesizer`, sem dependências externas.

## 📱 Requisitos

- macOS com **Xcode 15 ou superior**
- iOS 17.0+ (iPhone; também roda em iPad)
- Nenhum pacote externo — 100% frameworks nativos da Apple

## 🚀 Como rodar (macOS + Xcode)

```bash
git clone <URL-do-repositorio>
cd AlfabetoDivertido
open AlfabetoDivertido.xcodeproj
```

No Xcode:
1. Selecione o esquema **AlfabetoDivertido**.
2. Escolha um simulador de iPhone (ex.: iPhone 15).
3. Pressione **⌘R** para rodar.

Ou pela linha de comando:

```bash
xcodebuild -project AlfabetoDivertido.xcodeproj \
           -scheme AlfabetoDivertido \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           build
```

Para rodar em um iPhone físico, ajuste o `PRODUCT_BUNDLE_IDENTIFIER` (em *Signing & Capabilities*) para algo único e selecione seu Team de desenvolvedor.

## ✅ Validações sem macOS (Linux/CI)

Requer apenas `swift` 5.9+ no PATH ([Swift para Linux](https://www.swift.org/download/)).

```bash
./scripts/validate.sh
```

O script:
- Roda `swiftc -parse` em cada um dos 13 arquivos `.swift` (checagem sintática completa, sem depender de SwiftUI/UIKit).
- Compila e executa `AlfabetoDivertidoTests/SmokeTest.swift`, uma suíte com **23 asserções** que exercitam de verdade os modelos (`Letter`, `LiteracyData`, `WordChallenge`) e simulam a lógica do Quiz e do Formar Palavras.

## 🗂 Estrutura do projeto

```
AlfabetoDivertido/
├── AlfabetoDivertido.xcodeproj/       # Projeto Xcode
└── AlfabetoDivertido/
    ├── AlfabetoDivertidoApp.swift     # Entry point @main
    ├── Models/
    │   ├── Letter.swift               # Modelo de letra
    │   ├── LiteracyData.swift         # Dados do alfabeto, vogais, consoantes
    │   └── WordChallenge.swift        # Desafios de formação de palavras
    ├── Services/
    │   └── SpeechService.swift        # Síntese de fala em pt-BR
    ├── Views/
    │   ├── HomeView.swift             # Tela inicial com as atividades
    │   ├── AlphabetView.swift         # Grade do alfabeto
    │   ├── LetterDetailView.swift     # Detalhe animado de uma letra
    │   ├── SyllablesView.swift        # Formação de sílabas
    │   ├── WordBuilderView.swift      # Formação de palavras
    │   ├── QuizView.swift             # Quiz de letra inicial
    │   └── Components/
    │       ├── ActivityCard.swift     # Cartão da tela inicial
    │       └── BigLetterView.swift    # Bloco grande de letra
    ├── Assets.xcassets/               # AppIcon + AccentColor
    └── Preview Content/               # Assets para SwiftUI Previews
```

## 🧩 Como estender

- **Adicionar palavras** para o desafio: edite `WordChallengeData.all` em `Models/WordChallenge.swift`.
- **Adicionar/ajustar letras**: edite `LiteracyData.letters`.
- **Trocar voz**: a `SpeechService` já usa `pt-BR`; para preferir uma voz específica (ex.: Luciana), use `AVSpeechSynthesisVoice(identifier:)`.
- **Novos jogos**: crie uma nova View em `Views/`, adicione um `HomeDestination` em `HomeView.swift` e um `ActivityCard`.

## 📝 Licença

MIT — sinta-se à vontade para reutilizar em contextos educacionais.
