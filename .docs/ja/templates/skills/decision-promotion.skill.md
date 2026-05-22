---
name: decision-promotion
description: 'Run the DOD decision-promotion step after discussion-validation passes. Use for converting approved discussion results into active decision objects by updating DECISIONS.yml, decision contracts, statuses, links, and any newly required decision or sub-decision structure.'
user-invocable: false
---

# 決定昇格

## 目的
このスキルは Gate A の手順 3、すなわち decision promotion のために使う。
役割は、検証済みの議論結果を `DECISIONS.yml` 上の明示的な active decisions へ変換し、実装に効くルールが record にだけ残らないようにすることである。

## 必須入力
- 議論 ID
- `records/{discussion-id}.md` にある最新の検証済み結論
- `DECISIONS.yml` 上の現在の対象決定と status
- discussion-validation が列挙した promotion targets

## 手順
1. validation 通過を確認する。
   discussion-validation が方向を明示的に受理し、何を昇格または更新すべきかを示した後にのみ開始する。
2. 正しい decision shape を選ぶ。
   その結果を既存 decision に入れるべきか、新規 decision object にするべきか、あるいは 1 つ以上の sub-decision に分けるべきかを決める。複数の active rules を 1 ノードに隠さず、過積載なら分割する。
3. 新たに binding になったルールをすべて昇格する。
   検証済み結果から、実装に効く拘束条件をすべて `DECISIONS.yml` へ移す。active rules を `records/{discussion-id}.md` にだけ残さない。
4. decision contract を充足させる。
   次の実装判断を正しく保つのに必要な程度まで、invariants、non-goals、acceptance criteria、failure criteria を明示する。
5. status と linkage を更新する。
   影響対象の決定 status を適切な議論状態または実装状態へ進め、正しい `link` が `records/{discussion-id}.md` を指していることを確認する。
6. promotion coverage を確認する。
   広い履歴を読み直さなくても、別の実装者が次の変更を正しく進められるだけの決定集合になっているかを確かめる。
7. 昇格結果を報告する。
   何を昇格したか、何を更新したか、そして拘束条件ではないため record に残す不確実性が何かを明示する。

## ガードレール
- discussion-validation が曖昧または不通過なら昇格を始めない。
- 新しい active constraints を叙述だけに隠さない。
- 分離すべきルールを 1 つの decision に過積載しない。
- `DECISIONS.yml` は簡潔に保つが、実装ドリフトを防ぐために必要なルールは省略しない。

## 完了条件
- `DECISIONS.yml` が、検証済み議論の binding outcomes をすべて反映している。
- decision contracts が次の実装ステップに十分な粒度で明示されている。
- statuses と links が最新である。
- 実装に効くルールが record にだけ残っていない。