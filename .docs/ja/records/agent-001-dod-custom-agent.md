# Decision Record: agent-001-dod-custom-agent

## メタデータ
- Status: Accepted
- Date: 2026-04-03
- Scope: VS CodeワークスペースレベルのCopilotカスタマイズ

## 背景とリサーチ
DODを文章として定義するだけでなく、実行ワークフローとして再現可能にする必要があります。

リサーチ結果:
- VS Codeは `.agent.md` によるカスタムエージェント定義をサポートし、ワークスペースでは `.github/agents` 配下を検出します。
- カスタムエージェントは専用指示、ツール制約、モデル設定、ハンドオフを定義できます。
- 永続的なロールと能力制限が必要な場合、単発プロンプトよりカスタムエージェントが適しています。

参照:
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions

## 決定
DOD実装タスクの主実行基盤として、DOD専用のカスタムエージェントを作成します。

このエージェントでは以下を実施します:
- 指示内でDODのフェーズ挙動を強制する
- ワークフローステージごとに必要最小限のツールのみ公開する
- 参加者間で一貫した挙動を提供する

## 決定契約
### 不変条件
- DODカスタムエージェントは `.github/agents` 配下のワークスペースファイルとして定義する。
- エージェント指示にはDODフェーズと必要成果物を明示する。
- 複数メンバーがローカル手修正なしで再利用できること。

### 非目標
- 既存エージェントやユーザーレベル設定の全面置換は行わない。
- 専用の外部インフラを必須化しない。
- マシン固有パスをハードコードしない。

### 受け入れ基準
- `.agent.md` 定義が存在し、VS Codeで検出される。
- エージェントを選択してDOD専用ペルソナとして利用できる。
- 決定履歴とDECISIONS更新を明示する挙動が記載されている。

### 失敗条件
- エージェントファイルがサポート外ディレクトリに置かれている。
- VS Codeチャットで選択できない。
- 指示からDOD成果物要件が欠落し、決定ドリフトを誘発する。

## 影響
Positive:
- 一貫性が向上し、プロンプト揺れが減少します。
- 新規参加者でもDOD運用を実行しやすくなります。

Trade-offs:
- エージェント定義と関連ファイルの保守コストが発生します。
- ツール制約は不足権限/過剰権限を避ける調整が必要です。

## 実装更新（2026-04-04）
- ワークスペースカスタムエージェントを `.github/agents/dod.agent.md` に実装。
- 同期用の日本語ドキュメントを `.docs/ja/.github/agents/dod.agent.md` に追加。
- エージェント指示に、DODフェーズ順序と `DECISIONS.yml` / `records/{decision-id}.md` 更新要件を明示。

## エージェント定義拡張（DOD詳細準拠）（2026-04-04）
- フェーズゲート（Gate A/B/C）を明示し、議論成果物と決定契約が揃うまで実装開始できない制御を追加。
- ステータス運用方針を追加し、4基本ステータス（`Discussion In Progress` / `Discussion Approved` / `Implementing` / `Implementation Approved`）を優先、例外ステータスは必要時のみに制限。
- 検証意図をDODフックに対応付け（`pre-commit`: テスト/コード品質、`pre-push`: 決定整合性）。
- バージョン管理ルールと報告契約を追加し、決定IDブランチ運用と「変更・理由・検証・残存リスク」の報告を必須化。
- 本拡張は、決定ドリフトを減らし、実行時挙動を `DOD.md` により厳密に一致させる目的で実施。
