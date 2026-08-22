# 決定記録: agent-015-overwrite-default-all

## メタデータ
- 作成日: 2026-08-22
- 対象: 対話型インストーラーの上書き既定値

## 注記
- このファイルは追記専用の議論履歴です。
- 可変な追跡項目（ステータス、残作業、未完了アクション）は追加しません。
- 未解決の質問一覧は保持しません。確認が必要な場合はチャットで質問し、解決した事実を追記します。
- 事実が実装を拘束する制約になった場合は、DECISIONS.yml に昇格します。
- 各エントリーは議論に必要な範囲で短く保ちます。
- エビデンスと詳細な昇格メタデータは、エントリーが明確な場合は省略できます。

記録の境界に関する指針:
- 1つの記録は1つのまとまった決定テーマに集中させます。独立した質問、コンポーネント、フォローアップが現れた場合は、無関係な履歴を延長せず、新しいdiscussion-idで新しい記録を開始します。新しい議論が以前の記録を引き継ぐ場合は、Evidence / references で以前の記録に言及します。
- 記録が約10エントリーまたは1,000語に達したら、自然な境界で閉じ、新しいdiscussion-idの記録へ続けることをレビュー可能性の目安とします。これはヒューリスティックであり、パーサーが強制する上限ではありません。次の同一テーマのエントリーが簡潔でレビュー可能な場合だけ現在の記録を継続します。

追記ルール:
- EOFへの追記だけを行い、過去のセクションは編集しません。
- ステータス追跡や残作業を追加しません。

## エントリー一覧

### エントリー 0001 (2026-08-22)
- Why now: 現在のインストーラープロンプトでは `a` が残り全部の選択肢として表示されますが、未入力は現在のファイルだけを許可します。今回の要求は、未入力を残り全部の既定値にし、プロンプトを `Overwrite this file? [y/n/A] (A = all remaining files):` と表示することです。
- Findings / trade-offs: `confirm_overwrite` は既に `a|A` でセッションのポリシーを `yes` に変更しますが、フォールバックは現在のファイルだけを許可します。この切り替えを未入力にも再利用すれば、変更を局所化し、既存の `should_overwrite` の流れを維持できます。保護対象の `DECISIONS.yml` の確認はプロンプトより前に実行され、明示的な `--overwrite yes|no` ポリシーではプロンプトを呼びません。現在の `agent-002-8-existing-file-overwrite-policy` と英日READMEおよびテストは、まだ以前のEnter動作を説明しています。
- Current conclusion: 候補方針は、未入力、`A`、`a` を残り全部の上書き選択肢として扱うことです。現在のファイルを許可し、現在のインストール中の以降の変更済み管理対象に対して `OVERWRITE_POLICY=yes` を設定します。`y` と既存のその他の肯定応答は現在のファイルだけを許可し、`n` は現在のファイルだけを保持します。all-no の短縮入力は設けず、非対話時の `ask` は自動更新のままにします。
- Promotion to DECISIONS.yml: none
- Evidence / references: `install.sh`（`confirm_overwrite` と `install_staged_asset`）、`tests/install.test.sh` の対話確認テスト、`DECISIONS.yml` の `agent-002-8-existing-file-overwrite-policy`、`README.md`、`.docs/ja/README.md`。

## 追記テンプレート（末尾にコピーして追記）

### エントリー {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### エントリー 0002 (2026-08-22)
- Why now: 昇格前に候補の既定値を再インストールの目的と有効なインストーラー制約に照らして検証します。
- Findings / trade-offs: 未入力で残り全部を選ぶと、一般的な全更新のケースで確認の繰り返しを減らしつつ、`n` による明示的なファイル単位の拒否を維持できます。切り替えは現在のインストール中に `OVERWRITE_POLICY` を変更するだけなので、セッション限定です。明示的な `--overwrite yes|no`、非対話時のフォールバック、同一内容ファイルの冪等性、シンボリックリンク保護、ワークスペース範囲、確認前に行われる `DECISIONS.yml` 保護は影響を受けません。
- Current conclusion: 候補方針は目的と有効な制約に適合します。焦点を絞った受入確認では、疑似端末で未入力を渡し、正確な `[y/n/A]` プロンプト、`policy=yes`、後続の変更ファイルに対する2回目のプロンプトがないことを確認します。
- Promotion to DECISIONS.yml: promoted -> agent-002-8-existing-file-overwrite-policy
- Evidence / references: `tests/install.test.sh` で未入力による切り替えを確認し、明示的な `n`、`a`、明示ポリシー、非対話実行、保護対象の決定データ、冪等性のテストも維持します。

### エントリー 0003 (2026-08-22)
- Why now: 昇格した上書き既定値の決定を適用した後の実装結果を記録します。
- Findings / trade-offs: `confirm_overwrite` は両方の端末出力経路で `[y/n/A]` プロンプトを表示し、未入力を既存の残り全部への切り替えと同じように扱うようになりました。focused tests では、未入力により現在と後続のファイルを追加確認なしで更新することを確認し、明示的な `n`、小文字の `a`、明示ポリシー、非対話実行、保護対象の決定データ、冪等性、シンボリックリンク保護、ターゲットマニフェストの検証も維持しています。READMEも英日で同期しました。
- Current conclusion: 実装と関連成果物は昇格した決定に一致します。インストーラーは確認前に保護対象ファイルを検査するため、新しい既定値によって `DECISIONS.yml` の上書きが許可されることはありません。
- Promotion to DECISIONS.yml: none
- Evidence / references: 実装とドキュメント更新後に `bash tests/install.test.sh` が成功しました。
