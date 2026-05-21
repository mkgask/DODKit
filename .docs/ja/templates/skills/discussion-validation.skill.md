---
name: discussion-validation
description: 'Validate the DOD discussion direction before promotion. Use for checking whether the broad scan covered the right landscape, whether the narrowed focus is justified, and whether candidate decisions fit the original objective, active constraints, invariants, non-goals, and likely drift before updating DECISIONS.yml.'
user-invocable: false
---

# 議論検証

## 目的
このスキルは Gate A の手順 2、すなわち discussion-validation のために使う。
役割は、提案された方向を有効化する価値があるかを、議論が早く絞り込みすぎていないかも含めて、決定昇格前に監査的に確認することである。

## 必須入力
- 議論 ID
- `records/{discussion-id}.md` の最新エントリ
- `DECISIONS.yml` 上の現在の対象決定と契約
- 当初の目的と要求スコープ

## 手順
1. 最新の議論結果と有効な拘束条件を読む。
   更新済み record entry を起点にし、その後で変更または依存対象となる現在の決定を確認する。
2. ランドスケープの被覆を確認する。
   議論が、今回のスコープに関係する主要ドメイン、隣接論点、想定インターフェース、考慮漏れリスクを把握できる程度には広く見ているかを確かめる。
3. 絞り込み妥当性を確認する。
   選ばれた焦点領域が、早すぎる局所化ではなく広めのスキャン結果から導かれているか、重要な除外や不確実性が明示されているかを確認する。
4. 方向適合を確認する。
   候補方向が、当初の目的と要求スコープに引き続き合致しているかを確かめる。
5. 契約適合を確認する。
   候補方向を、有効な invariants、non-goals、acceptance criteria、failure criteria に照らして検証する。
6. 隠れた拘束条件を洗い出す。
   暗黙のままにせず、新規決定またはサブ決定として昇格すべき独立したルールがないかを確認する。
7. 既定の昇格前 audit をここで行う。
   audit は別 skill に切り出さず、この検証の一部として、方向ドリフト、拘束条件の欠落、決定の過積載、早すぎるスコープ拡大、絞り込みの早さによる考慮漏れリスクを点検する。
8. 通過か差し戻しかを決める。
   方向が妥当なら、どの決定を昇格または更新すべきかを正確に列挙する。妥当でなければ、何を明確化すべきかを添えて discussion に戻す。

## ガードレール
- 方向の曖昧さが残るまま結論を昇格しない。
- 広めのスキャンが浅すぎて焦点選択を正当化できない場合は通過させない。
- 新たに見つかった拘束条件を見逃さず、妥当性が通った場合は同じ変更セットで昇格する。
- 検証を口実に広い再設計へ拡散しない。
- これを第 3 のライフサイクルフェーズにせず、軽量な昇格前チェックポイントとして保つ。

## 完了条件
- 候補方向が明示的に通過または棄却されている。
- 記録上で、広めのスキャン被覆と絞り込み妥当性の両方が確認されている。
- 通過時は昇格対象が正確に列挙されている。
- `DECISIONS.yml` 編集前に、ドリフト、隠れた拘束条件、契約ギャップが表面化している。