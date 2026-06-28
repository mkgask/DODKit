---
name: implementation
description: 'Run the DOD implementation step. Use for deriving the target shape implied by the promoted decisions, choosing a validation-friendly integration order, and implementing that design after discussion and decision promotion are complete.'
user-invocable: false
---

# 実装

## 目的
このスキルは Gate B の手順 1 と 2、すなわち design と test and implement のために使う。
役割は、有効な決定集合から意図する target shape を導出し、その設計を検証しやすい順序で組み込むことである。

## 必須入力
- 議論 ID
- `DECISIONS.yml` 上の有効な決定 ID と status
- 昇格済み決定によって影響を受ける code paths、tests、interfaces、docs、templates
- 昇格済み決定が満たすべき failing behavior または verification target

## 手順
1. Gate A 完了を確認する。
   議論記録更新、discussion-validation 通過、関連決定の `DECISIONS.yml` への昇格が済んでいることを確認する。
2. 有効な決定から target shape を導出する。
   昇格済み決定が満たされた状態で、実装結果がどうあるべきかを明示し、その結果に含まれる code、tests、interfaces、docs、templates を整理する。
3. integration order を決める。
   何を先に入れるべきか、何が後続要素に依存するか、どこで focused validation を走らせるべきかを決め、target shape を安全に組み込める順序にする。
4. 可能なら fail-first を優先する。
   意味のある integration point で実装を反証できる振る舞い確認、対象限定テスト、実行チェックを選ぶ。
5. target shape に向かって、検証しやすい短いループで実装する。
   必要な設計を妥当な順序で組み込む。ループの粒度は検証しやすさと安全性のために選び、promoted decisions がすでに定めた実装スコープを再定義するためには使わない。
6. 意味のあるチェックポイントで検証する。
   それぞれの意味のある integration step、特に最初の実質編集後には、focused behavior check、対象限定テスト、または狭い compile/lint/typecheck を走らせる。
7. 新しい事実が重要なら記録を更新する。
   実装中に新しい拘束条件や決定上重要な事実が判明した場合は、`records/{discussion-id}.md` へ追記し、拘束条件なら同じ変更セットで `DECISIONS.yml` に昇格する。決定エントリを新規作成または更新する際は `decision` 単一フィールドを使う。
8. クローズ前で止める。
   ここでは完了宣言せず、結果を implementation-validation へ渡す。

## ガードレール
- このスキル自身が実装 scope を縮めたり再定義したりしない。何を作るべきかは promoted decision set が定める。
- 局所最小編集の追求を、意図する target shape より優先しない。
- target shape が見えていても focused validation を省略しない。
- 昇格済み決定スコープから実装を逸脱させない。
- 隣接する tests、docs、interfaces、templates は、promoted decisions により intended result の一部である場合は更新する。

## 完了条件
- 対応対象の decisions に対して、意図した target shape が closeout validation に渡せるところまで組み込まれている。
- 意味のある integration checkpoints で focused validation を実行済みである。
- 新たに拘束力を持つ事実は記録・昇格されている。
- 作業が implementation-validation に渡せる状態である。