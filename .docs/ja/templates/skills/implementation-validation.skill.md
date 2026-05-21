---
name: implementation-validation
description: 'Validate DOD implementation results before closeout. Use for checking tests, code, docs, templates, and related artifacts against the active decisions, while absorbing the default post-implementation audit.'
user-invocable: false
---

# 実装検証

## 目的
このスキルは Gate B の手順 3 と、Gate C の closeout checks のために使う。
役割は、実装結果とその周辺成果物が、本当に昇格済み決定へ一致しているかを確認することである。

## 必須入力
- 議論 ID
- `DECISIONS.yml` 上の有効な決定と status
- 変更された code、tests、docs、templates、関連成果物
- 実装中に実行した狭い validation checks の結果

## 手順
1. 決定的なチェックから始める。
   変更スライスを反証できる最小の振る舞いテスト、対象限定テストファイル、compile、lint、typecheck を優先する。
2. 既定の実装後 audit をここで行う。
   独立した既定 audit skill を使う代わりに、この検証の中で有効決定と変更成果物の整合性を監査する。
3. 成果物の整合を確認する。
   テスト、コード、テンプレート、エージェントガイダンス、利用者向け用語が、変更スコープに対する有効決定と揃っているかを確認する。
4. 決定衛生を確認する。
   `DECISIONS.yml` の status が最新であり、実装上重要な新事実は `records/{discussion-id}.md` に追記され、拘束条件なら昇格済みであることを確認する。
5. 同一スライス欠陥なら局所修正する。
   検証で同一スライスの欠陥が露出した場合は、その場で修正し、同じ focused validation を再実行してから先へ進む。
6. 決定契約を満たしたときだけ閉じる。
   何を検証したか、何を変更したか、そして新たな active constraint には至らない残存リスクがあるかを報告する。

## ガードレール
- より狭い実行可能検証がある場合に、`git diff` で代用しない。
- 局所的な検証失敗を直す代わりにスコープ拡大で逃げない。
- 決定と変更成果物の間に用語ドリフトを残さない。
- status や records が古いまま作業を閉じない。

## 完了条件
- 変更スコープの focused validation が通過しているか、残る blocker が明示されている。
- 変更成果物が昇格済み決定に一致している。
- 既定 audit の確認項目がこの検証手順に吸収されている。
- メインエージェントが closeout を報告できる情報が揃っている。