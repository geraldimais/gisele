#!/usr/bin/env bash
# validate.sh — Roda validações que não dependem de macOS/Xcode.
#
# 1. swiftc -parse em cada arquivo .swift do app (checagem sintática completa)
# 2. Compila+executa AlfabetoDivertidoTests/SmokeTest.swift (testes de domínio)
#
# Uso:
#   ./scripts/validate.sh
#
# Requisitos:
#   - swift 5.9+ no PATH (Swift para Linux funciona; no macOS já vem)
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v swift >/dev/null 2>&1; then
  echo "❌ swift não está no PATH." >&2
  echo "   Instale de https://www.swift.org/download/ ou use Xcode no macOS." >&2
  exit 1
fi

echo "→ swift $(swift --version | head -1)"
echo ""

echo "═══ 1) swiftc -parse (13 arquivos) ═══"
fail=0
while IFS= read -r f; do
  if swiftc -parse "$f" 2>&1; then
    printf "  ✅ %s\n" "$f"
  else
    printf "  ❌ %s\n" "$f"
    fail=$((fail + 1))
  fi
done < <(find AlfabetoDivertido -name '*.swift' | sort)

if [ "$fail" -ne 0 ]; then
  echo "❌ $fail arquivo(s) com erro de sintaxe" >&2
  exit 1
fi

echo ""
echo "═══ 2) SmokeTest — dados de domínio ═══"
swift AlfabetoDivertidoTests/SmokeTest.swift

echo ""
echo "════════════════════════════════════════"
echo "✅ Validações offline OK."
echo ""
echo "Para build/execução no simulador iOS: abra AlfabetoDivertido.xcodeproj"
echo "no Xcode 15+ (macOS) e pressione ⌘R."
