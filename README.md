# Devin Task Board

リッチなタスク管理アプリ（Jira ミニ版）。

## 技術スタック

- **フレームワーク**: Next.js 16 (App Router) + React 19 + TypeScript
- **DB**: PostgreSQL 16 + Prisma ORM
- **スタイル**: Tailwind CSS v4 (OKLCH)
- **インフラ**: Docker Compose

## セットアップ

### 前提条件

- Node.js 22+
- Docker / Docker Compose

### 1. リポジトリのクローン

```bash
git clone https://github.com/micci184/devin-handson.git
cd devin-handson
```

### 2. 環境変数の設定

```bash
cp .env.example .env
```

### 3. Docker Compose で起動

```bash
docker compose up -d
```

`app`（Next.js: http://localhost:3000）と `db`（PostgreSQL: localhost:5432）が起動します。

### 4. ローカル開発（Docker を使わない場合）

```bash
npm install
```

PostgreSQL を別途起動し、`.env` の `DATABASE_URL` を接続先に合わせてください。

### 5. マイグレーション

```bash
npx prisma migrate dev
```

### 6. Seed データ投入

```bash
npx prisma db seed
```

### 7. 開発サーバー起動（ローカル）

```bash
npm run dev
```

http://localhost:3000 でアクセスできます。

## スクリプト一覧

| コマンド              | 説明                          |
| --------------------- | ----------------------------- |
| `npm run dev`         | 開発サーバー起動（Turbopack） |
| `npm run build`       | プロダクションビルド          |
| `npm run start`       | プロダクションサーバー起動    |
| `npm run lint`        | ESLint 実行                   |
| `npm run db:migrate`  | Prisma マイグレーション       |
| `npm run db:seed`     | Seed データ投入               |
| `npm run db:studio`   | Prisma Studio 起動            |
| `npm run db:generate` | Prisma Client 生成            |
