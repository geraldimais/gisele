#!/usr/bin/env bash
# build-ipa.sh — Build local do Alfabeto Divertido para iOS.
#
# Uso:
#   ./scripts/build-ipa.sh simulator            # gera .app.zip para simulador
#   ./scripts/build-ipa.sh device <TEAM_ID>     # gera .ipa assinado (ad-hoc)
#
# Requer macOS + Xcode 15+.
set -euo pipefail

cd "$(dirname "$0")/.."

MODE="${1:-simulator}"
BUILD_DIR="build"
ARTIFACTS_DIR="artifacts"
PROJECT="AlfabetoDivertido.xcodeproj"
SCHEME="AlfabetoDivertido"
SHORT_SHA="$(git rev-parse --short HEAD 2>/dev/null || echo local)"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "❌ xcodebuild não encontrado. Este script precisa de macOS + Xcode." >&2
  echo "   Estamos em: $(uname -srmo)" >&2
  exit 1
fi

mkdir -p "$ARTIFACTS_DIR"
rm -rf "$BUILD_DIR"

case "$MODE" in
  simulator)
    echo "═══ Build para iOS Simulator (não-assinado) ═══"
    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration Release \
      -destination 'generic/platform=iOS Simulator' \
      -derivedDataPath "$BUILD_DIR" \
      CODE_SIGNING_ALLOWED=NO \
      CODE_SIGNING_REQUIRED=NO \
      CODE_SIGN_IDENTITY="" \
      build

    APP="$BUILD_DIR/Build/Products/Release-iphonesimulator/${SCHEME}.app"
    if [ ! -d "$APP" ]; then
      echo "❌ .app não encontrado em $APP" >&2
      exit 1
    fi
    OUT="$ARTIFACTS_DIR/${SCHEME}-${SHORT_SHA}-simulator.zip"
    ditto -c -k --sequesterRsrc --keepParent "$APP" "$OUT"
    echo ""
    echo "✅ $OUT"
    ls -lh "$OUT"
    echo ""
    echo "Para instalar em um simulador:"
    echo "  unzip -o '$OUT' -d /tmp/adz"
    echo "  xcrun simctl boot 'iPhone 15'"
    echo "  xcrun simctl install booted /tmp/adz/${SCHEME}.app"
    echo "  xcrun simctl launch booted com.example.AlfabetoDivertido"
    ;;

  device)
    TEAM_ID="${2:-}"
    if [ -z "$TEAM_ID" ]; then
      echo "❌ Uso: ./scripts/build-ipa.sh device <APPLE_TEAM_ID>" >&2
      echo "   Obtenha seu Team ID em https://developer.apple.com/account (canto superior direito)" >&2
      exit 1
    fi

    METHOD="${EXPORT_METHOD:-ad-hoc}"
    echo "═══ Archive + export .ipa (method=$METHOD, team=$TEAM_ID) ═══"

    xcodebuild \
      -project "$PROJECT" \
      -scheme "$SCHEME" \
      -configuration Release \
      -destination 'generic/platform=iOS' \
      -archivePath "$BUILD_DIR/${SCHEME}.xcarchive" \
      DEVELOPMENT_TEAM="$TEAM_ID" \
      CODE_SIGN_STYLE=Automatic \
      archive

    cat > "$BUILD_DIR/ExportOptions.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>${METHOD}</string>
  <key>teamID</key>
  <string>${TEAM_ID}</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>stripSwiftSymbols</key>
  <true/>
  <key>compileBitcode</key>
  <false/>
</dict>
</plist>
EOF

    xcodebuild \
      -exportArchive \
      -archivePath "$BUILD_DIR/${SCHEME}.xcarchive" \
      -exportPath "$BUILD_DIR/export" \
      -exportOptionsPlist "$BUILD_DIR/ExportOptions.plist"

    IPA=$(find "$BUILD_DIR/export" -name '*.ipa' | head -1)
    if [ -z "$IPA" ]; then
      echo "❌ .ipa não gerado. Veja logs acima." >&2
      exit 1
    fi
    OUT="$ARTIFACTS_DIR/${SCHEME}-${SHORT_SHA}.ipa"
    cp "$IPA" "$OUT"
    echo ""
    echo "✅ $OUT"
    ls -lh "$OUT"
    ;;

  *)
    echo "❌ Modo desconhecido: '$MODE'. Use 'simulator' ou 'device'." >&2
    exit 1
    ;;
esac
