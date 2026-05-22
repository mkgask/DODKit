---
name: implementation-validation
description: 'Validate DOD implementation results before closeout. Use for checking the executable validation result, artifact alignment, terminology alignment, decision-record hygiene, and remaining blockers or risks against the active decisions.'
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
2. 変更スライスの実行結果を確認する。
   実装中に選んだ focused validation が実際に通過しているか、あるいは残る blocker が明示的かつ局所化されているかを確認する。
3. active decisions に対する成果物整合を確認する。
   変更された tests、code、docs、templates、agent guidance が、変更スコープに対する昇格済み決定と一致しているかを確認する。
4. 用語と利用者向け表現の整合を確認する。
   変更スコープが影響する範囲で、命名、利用者向け文言、関連参照が active decision set からドリフトしていないことを確認する。
5. decision と record の衛生状態を確認する。
   `DECISIONS.yml` の status が最新で、link が正しい record を指し、実装上重要な新事実は `records/{discussion-id}.md` に追記され、拘束条件なら昇格済みであることを確認する。
6. 残存 blocker と risk の状態を確認する。
   closeout を妨げるものが残っていないか、残る risk が新しい decision を要する binding constraint ではなく報告対象に留まるかを明示する。
7. 同一スライス欠陥なら局所修正する。
   検証で同一スライスの欠陥が露出した場合は、その場で修正し、同じ focused validation を再実行してから先へ進む。
8. 決定契約を満たしたときだけ閉じる。
   何を検証したか、何を変更したか、そして新たな active constraint には至らない残存リスクがあるかを報告する。

## ガードレール
- より狭い実行可能検証がある場合に、`git diff` で代用しない。
- 局所的な検証失敗を直す代わりにスコープ拡大で逃げない。
- 決定と変更成果物の間に用語ドリフトを残さない。
- status や records が古いまま作業を閉じない。

## 完了条件
- 変更スコープの focused validation が通過しているか、残る blocker が明示されている。
- 変更成果物が昇格済み決定に一致している。
- 必須の closeout checks が明示的に確認されている。
- メインエージェントが closeout を報告できる情報が揃っている。