#!/bin/bash

set -euo pipefail

TARGET_REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}"
INPUT_DIR="${2:-./issue-export}"

if [ ! -f "$INPUT_DIR/issues.json" ]; then
  echo "Error: issues.json が $INPUT_DIR に見つかりません"
  echo "   先に ./scripts/export-issues.sh を実行してください"
  exit 1
fi

echo "Importing to $TARGET_REPO"

# Label 作成（既存ならスキップ）
echo "  → Creating labels..."
LABELS=(
  "phase:0|6B7280|環境構築"
  "phase:1|3B82F6|基盤・ドキュメント"
  "phase:2|10B981|コア機能"
  "phase:3|F59E0B|拡張機能"
  "phase:4|EF4444|UX・運用機能"
  "priority:high|DC2626|"
  "priority:medium|F59E0B|"
  "priority:low|6B7280|"
  "type:frontend|3B82F6|UI・コンポーネント・画面"
  "type:backend|10B981|API・DB・Server Actions"
  "type:fullstack|8B5CF6|フロントエンドとバックエンド両方"
  "type:infra|78716C|環境構築・設定"
  "type:docs|0EA5E9|ドキュメント"
  "size:XS|D1D5DB|1〜2 ACU"
  "size:S|93C5FD|3〜5 ACU"
  "size:M|6EE7B7|5〜8 ACU"
  "size:L|FCA5A5|8〜10 ACU"
)
for entry in "${LABELS[@]}"; do
  name="${entry%%|*}"
  rest="${entry#*|}"
  color="${rest%%|*}"
  desc="${rest#*|}"
  gh label create "$name" --repo "$TARGET_REPO" --color "$color" --description "$desc" 2>/dev/null \
    && echo "     ok: $name" \
    || echo "     skip: $name"
done

# Issue 作成（OPEN のみ、古いものから順に番号再採番）
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
  echo "     ok: $title"
done

echo "Import completed"
