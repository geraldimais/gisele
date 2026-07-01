# Alfabeto Divertido 📚✨

[![Build iOS App](https://github.com/geraldimais/gisele/actions/workflows/build-ios.yml/badge.svg)](https://github.com/geraldimais/gisele/actions/workflows/build-ios.yml)
[![Latest release](https://img.shields.io/github/v/release/geraldimais/gisele?label=Baixar%20app&color=blue)](https://github.com/geraldimais/gisele/releases/latest)

App para iPhone (SwiftUI) que ajuda crianças na fase de **alfabetização** a aprender letras, sílabas e palavras em português do Brasil, com feedback de voz nativa (`AVSpeechSynthesizer` em `pt-BR`).

## 📥 Baixar o app

Cada tag `v*` gera automaticamente um release na aba **[Releases](https://github.com/geraldimais/gisele/releases)** com dois artefatos:

| Arquivo | Para quê | Precisa de conta Apple Developer? |
|---|---|---|
| `AlfabetoDivertido-<versao>-<sha>-simulator.zip` | Roda em qualquer **simulador iOS** no Xcode. | Não |
| `AlfabetoDivertido-<versao>-<sha>.ipa` | Instala em **iPhone físico** via TestFlight/AltStore/Xcode. | Sim (só é gerado se você configurar os secrets) |

> ⚠️ **Sobre distribuição no iOS.** Diferente do Android, a Apple **não permite** que qualquer pessoa baixe um `.ipa` e instale direto no iPhone. As rotas oficiais são:
> - **App Store** (público, precisa de conta paga + review)
> - **TestFlight** (beta, precisa de conta paga)
> - **Ad-Hoc** (até 100 dispositivos com UDIDs cadastrados)
> - **Enterprise** (uso interno, conta enterprise cara)
> - **Sideload com AltStore/Xcode** (a própria pessoa assina com a Apple ID gratuita, dura 7 dias)
>
> O workflow deste repo já gera o `.ipa` pronto para as rotas acima — basta você adicionar suas credenciais uma vez (ver [Distribuição em dispositivos reais](#distribuição-em-dispositivos-reais)).

### Instalar a build de simulador (macOS)

```bash
# 1. Baixe AlfabetoDivertido-*-simulator.zip do Releases
unzip AlfabetoDivertido-*-simulator.zip
xcrun simctl boot "iPhone 15"
xcrun simctl install booted AlfabetoDivertido.app
xcrun simctl launch booted com.example.AlfabetoDivertido
```

### Instalar o `.ipa` em um iPhone físico

- **TestFlight** — envie o `.ipa` no App Store Connect e distribua o convite.
- **AltStore / SideStore** — arraste o `.ipa` no app, ele reassina com sua Apple ID (renovação a cada 7 dias na conta gratuita, 1 ano na paga).
- **Xcode → Window → Devices and Simulators** — arraste o `.ipa` no dispositivo pareado.

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

## Distribuição em dispositivos reais

Para o job **`device`** do workflow gerar um `.ipa` assinado, configure os seguintes secrets do repositório em **Settings → Secrets and variables → Actions**:

| Secret | Como obter |
|---|---|
| `BUILD_CERTIFICATE_BASE64` | Exporte seu certificado iOS Distribution como `.p12` no Keychain Access e converta: `base64 -i cert.p12 -o cert.b64` |
| `P12_PASSWORD` | Senha usada ao exportar o `.p12` |
| `BUILD_PROVISION_PROFILE_BASE64` | `.mobileprovision` baixado em [developer.apple.com](https://developer.apple.com/account/resources/profiles/list), convertido: `base64 -i profile.mobileprovision -o profile.b64` |
| `KEYCHAIN_PASSWORD` | Qualquer string aleatória (usada só dentro do runner) |
| `APPLE_TEAM_ID` | 10 caracteres, em [developer.apple.com](https://developer.apple.com/account) → *Membership* |
| `EXPORT_METHOD` *(opcional)* | `app-store`, `ad-hoc`, `development` ou `enterprise` (padrão: `ad-hoc`) |

Depois disso, basta rodar:

```bash
git tag v1.0.0
git push origin v1.0.0
```

O GitHub Actions vai buildar (macOS runner), assinar, empacotar e criar automaticamente um GitHub Release com o `.ipa` e o `.app.zip` prontos para download.

### Build local (macOS)

```bash
cd AlfabetoDivertido
./scripts/build-ipa.sh simulator                # gera artifacts/*-simulator.zip
./scripts/build-ipa.sh device ABC123DEF4        # gera artifacts/*.ipa (Team ID)
```

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
