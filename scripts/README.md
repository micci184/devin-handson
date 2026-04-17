# scripts/

運用補助スクリプト集。

## `export-issues.sh`

現在の GitHub Issue + ラベルを JSON にエクスポート。`phase:0` ラベルは除外。

```bash
./scripts/export-issues.sh <owner/repo> [output-dir]

# 例
./scripts/export-issues.sh micci184/devin-handson ./export
```

出力:
- `export/issues.json`: Issue 一覧（`phase:0` 除外、OPEN + CLOSED 両方含む）
- `export/labels.json`: 全ラベル

## `import-issues.sh`

エクスポートした JSON を別リポジトリにインポート。

```bash
./scripts/import-issues.sh <target-owner/repo> [input-dir]

# 例
./scripts/import-issues.sh micci184/new-repo ./export
```

動作:
1. ラベルを作成（既存ならスキップ）
2. **OPEN** の Issue のみを古い順に作成

## 注意点

- Issue 番号は維持されません（新規採番）
- コメント / Assignee / Milestone は含まれません
- 実行者が Issue の作成者になります
- `gh auth login` で両方のリポジトリに権限があることが前提
- `jq` が必要（\`brew install jq\`）
