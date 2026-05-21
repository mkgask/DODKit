---
name: implementation
description: 'Run the DOD implementation step. Use for phase-local design, narrow test selection, and short test-and-implement loops after discussion and decision promotion are complete.'
user-invocable: false
---

# 実装

## 目的
このスキルは Gate B の手順 1 と 2、すなわち design と test and implement のために使う。
役割は、有効な決定集合を、すぐに検証できる最小の有用変更へ落とし込むことである。

## 必須入力
- 議論 ID
- `DECISIONS.yml` 上の有効な決定 ID と status
- 要求された実装スコープ
- 作業の起点になる owner code path、テスト、または失敗している振る舞い

## 手順
1. Gate A 完了を確認する。
   議論記録更新、discussion-validation 通過、関連決定の `DECISIONS.yml` への昇格が済んでいることを確認する。
2. 有効な決定に照らして設計する。
   昇格済み決定を、安価に反証できる 1 つの小さな実装スライスへ変換する。
3. 可能なら fail-first を優先する。
   スライスが誤っていると証明できる最小のテストまたは実行チェックを選ぶ。
4. 短いループで実装する。
   現在の仮説を試せる最小かつ可逆な編集から入る。
5. 最初の実質編集直後に検証する。
   追加の読取りやパッチ前に、対象を絞った振る舞い確認、狭いテスト、または狭い compile/lint/typecheck を走らせる。
6. 新しい事実が重要なら記録を更新する。
   実装中に新しい拘束条件や決定上重要な事実が判明した場合は、`records/{discussion-id}.md` へ追記し、拘束条件なら同じ変更セットで `DECISIONS.yml` に昇格する。
7. クローズ前で止める。
   ここでは完了宣言せず、結果を implementation-validation へ渡す。

## ガードレール
- ローカルな実装スライスを選んだ後は、現在の仮説が反証されない限り、広い探索へ戻らない。
- 同じ focused validation を再実行する前に編集面を広げない。
- 昇格済み決定スコープから実装を逸脱させない。
- 隣接する docs や tests は、有効な決定により同じスライスに含まれる場合だけ更新する。

## 完了条件
- 実装スライスが入っている。
- 変更スライスに対して少なくとも 1 つの focused validation を実行済みである。
- 新たに拘束力を持つ事実は記録・昇格されている。
- 作業が implementation-validation に渡せる状態である。