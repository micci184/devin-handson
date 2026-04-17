#!/bin/bash
# エクスポートした Issue + ラベルを別リポジトリへインポート
#
# 使い方:
#   ./scripts/import-issues.sh <target-owner/repo> [input-dir]
#
# 例:
#   ./scripts/import-issues.sh micci184/new-repo ./export

set -euo pipefail

TARGET_REPO="${1:-}"
INPUT_DIR="${2:-./export}"

if [ -z "$TARGET_REPO" ]; then
  echo "Usage: $0 <target-owner/repo> [input-dir]"
  exit 1
fi

if [ ! -f "$INPUT_DIR/issues.json" ] || [ ! -f "$INPUT_DIR/labels.json" ]; then
  echo "❌ issues.json / labels.json が $INPUT_DIR に見つかりません"
  echo "   先に ./scripts/export-issues.sh を実行してください"
  exit 1
fi

echo "📥 Importing to $TARGET_REPO"

# 1. ラベル作成（既存ならスキップ）
echo "  → Creating labels..."
jq -c '.[]' "$INPUT_DIR/labels.json" | while read -r label; do
  name=$(echo "$label" | jq -r '.name')
  desc=$(echo "$label" | jq -r '.description // ""')
  color=$(echo "$label" | jq -r '.color')

  if gh label create "$name" \
    --repo "$TARGET_REPO" \
    --description "$desc" \
    --color "$color" \
    2>/dev/null; then
    echo "     ✓ $name"
  else
    echo "     (skip: $name 既存)"
  fi
done

# 2. Issue 作成（OPEN のみ、古いものから順に番号再採番）
echo "  → Creating issues..."
jq -c '[.[] | select(.state == "OPEN")] | reverse | .[]' "$INPUT_DIR/issues.json" \
  | while read -r issue; do
  title=$(echo "$issue" | jq -r '.title')
  body=$(echo "$issue" | jq -r '.body // ""')
  labels=$(echo "$issue" | jq -r '.labels | map(.name) | join(",")')

  if [ -n "$labels" ]; then
    gh issue create \
      --repo "$TARGET_REPO" \
      --title "$title" \
      --body "$body" \
      --label "$labels" \
      > /dev/null
  else
    gh issue create \
      --repo "$TARGET_REPO" \
      --title "$title" \
      --body "$body" \
      > /dev/null
  fi
  echo "     ✓ $title"
done

echo "✅ Import completed"
