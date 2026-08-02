# 議論履歴: {discussion-id}

## メタデータ
- Created At: YYYY-MM-DD
- Scope: スコープを1行で記述

## 注意
- このファイルは追記専用の議論履歴です。
- 更新が前提の追跡項目（status、残作業、未完了アクション項目）を書かないでください。
- 未解決質問の管理台帳として使わず、確認が必要な内容はチャットで質問し、回答後に事実だけを追記してください。
- 事実が実装拘束条件になったら、DECISIONS.yml に昇格してください。
- 各エントリは、その議論で必要な最小限の長さに保ってください。
- 根拠や詳細な昇格メタデータは任意です。なくても意味が通るなら省略して構いません。

記録の境界:
- 1つの記録は1つのまとまった意思決定テーマに絞ってください。独立した質問、コンポーネント、またはフォローアップが現れたら、無関係な履歴を延長せず、新しい `discussion-id` の記録を開始してください。その議論が前の記録から続く場合は、`Evidence / references` に前の記録を記載してください。
- 実務上の一覧性シグナルとして、記録が概ね10エントリまたは1,000語に達したら、自然な区切りでいったん閉じ、新しい `discussion-id` の記録へ続けてください。これはヒューリスティックであり、パーサーが強制する上限ではありません。次のエントリが同じテーマで簡潔かつレビュー可能な場合に限り、現在の記録を続けてください。

追記ルール:
- 既存セクションは書き換えず、末尾追記のみ。
- status や残作業の追跡項目を書かないでください。

## エントリ一覧

### エントリ 0001（{timestamp}）
- Why now: このエントリを記録する理由
- Findings / trade-offs: 背景、制約、調査結果、または重要だった代替案
- Current conclusion: この時点での結論
- Promotion to DECISIONS.yml: none | promoted -> decision-id-1, decision-id-2
- Evidence / references（optional）: 根拠となるリンク、コマンド、出力、成果物

## 追記テンプレート（同一ファイル末尾にコピーして追記）

### エントリ {next-sequence}（{timestamp}）
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references（optional）:
