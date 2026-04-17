#!/bin/bash
# GitHub Issue + ラベルをエクスポート（phase:0 は除外）
#
# 使い方:
#   ./scripts/export-issues.sh <owner/repo> [output-dir]
#
# 例:
#   ./scripts/export-issues.sh micci184/devin-handson ./export

set -euo pipefail

SOURCE_REPO="${1:-}"
OUTPUT_DIR="${2:-./issue-export}"

if [ -z "$SOURCE_REPO" ]; then
  echo "Usage: $0 <owner/repo> [output-dir]"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Exporting from $SOURCE_REPO (phase:0 は除外)"

# Issue を取得 → phase:0 ラベルを持つものを除外
gh issue list \
  --repo "$SOURCE_REPO" \
  --state all \
  --limit 1000 \
  --json number,title,body,labels,state \
  | jq '[.[] | select(.labels | map(.name) | contains(["phase:0"]) | not)]' \
  > "$OUTPUT_DIR/issues.json"

ISSUE_COUNT=$(jq 'length' "$OUTPUT_DIR/issues.json")
echo "  Issues: $ISSUE_COUNT"

# ラベル（インポート先で再作成するため全部エクスポート）
gh label list \
  --repo "$SOURCE_REPO" \
  --limit 200 \
  --json name,description,color \
  > "$OUTPUT_DIR/labels.json"

LABEL_COUNT=$(jq 'length' "$OUTPUT_DIR/labels.json")
echo "  Labels: $LABEL_COUNT"

echo "Exported to $OUTPUT_DIR/"
