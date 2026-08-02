# Decision Record: agent-013-discussion-record-boundaries

## メタデータ
- 作成日: 2026-08-02
- スコープ: DOD の議論記録にファイル単位の境界と分割指示を定義する

## 注記
- このファイルは追記専用の議論履歴です。
- 可変の追跡項目（status、残作業、アクション項目）は追加しないでください。
- 未解決事項の一覧を残さないでください。確認が必要な場合はチャットで質問し、解決した事実を追記してください。
- 事実が実装を拘束する条件になった場合は、DECISIONS.yml に昇格してください。
- 各エントリは議論が許す範囲で短く保ってください。
- 証拠や詳細な昇格メタデータは任意です。エントリだけで明確な場合は省略してください。

追記規則:
- EOF の末尾にのみ追記し、過去のセクションは編集しないでください。
- status や残作業の追跡は追加しないでください。

## エントリ一覧

### エントリ 0001（2026-08-02）
- 議論の契機: DODKit を使うリポジトリで議論記録が少ないまま、1つの記録がレビューに適さないほど長くなった。現在のテンプレートと discussion skill はエントリを簡潔にするよう求めているが、議論を新しいファイルまたは discussion ID へ移す条件を定義していない。
- 発見事項 / トレードオフ: discussion-record template、discussion skill、agent guidance、decision-promotion skill、インストーラーマニフェストとテスト、`.dodkit` の共有コピー、日本語ミラーを境界付きで調査したが、ファイル単位の分割規則は見つからなかった。既存の decision/sub-decision の分割は DECISIONS.yml の構造に関するもので、議論記録の境界ではない。既存の軽量テンプレートに関する決定は、最小限の記録構造と任意の根拠を求めているため、新しい指示で必須の計画様式や DOD の第3フェーズを追加してはならない。インストーラーは対象のテンプレートと skill の原本をすでに配布しているため、マニフェストの変更も不要である。質的な指示だけでは見落とされる可能性があり、固定行数上限は硬直的になる。候補は、1つの記録を1つのまとまった意思決定テーマに保ち、記録が概ね10エントリまたは1,000語に達したら、自然な区切りで閉じ、前の記録を参照する新しい discussion ID の記録へ続けるという、質的な境界と実務上のシグナルの組み合わせである。
- 現時点の結論: `templates/discussion-record.md` と `templates/skills/discussion.skill.md` にファイル単位の境界指示を追加し、インストール済み共有コピーと日本語ミラーを同期する。指示では、独立した意思決定テーマと同じテーマの継続を区別し、サイズシグナルを固定的な失敗条件にせず明示し、追記専用履歴を保つ。昇格前に、discussion-validation でこの変更が軽量な記録と DOD の2フェーズ制に反しないことを確認する。
- DECISIONS.yml への昇格: なし。候補方針は discussion-validation の準備ができています
- 証拠 / 参照（任意）: `templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `templates/agent.md`; `templates/skills/decision-promotion.skill.md`; `install.sh`; `tests/install.test.sh`; `.dodkit/templates/discussion-record.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `DECISIONS.yml`; `records/agent-005-lightweight-template-roles.md`

## 追記テンプレート（コピーして EOF に追記）

### エントリ {next-sequence}（{timestamp}）
- 議論の契機:
- 発見事項 / トレードオフ:
- 現時点の結論:
- DECISIONS.yml への昇格:
- 証拠 / 参照（任意）:

### エントリ 0002（2026-08-02）
- 議論の契機: 昇格前に、候補の記録境界指示を当初の依頼と有効な軽量 DOD 制約に照らして検証する。
- 発見事項 / トレードオフ: 原本のテンプレートと discussion skill、それらのインストール済みコピーと日本語ミラー、メイン agent と隣接する promotion guidance、インストーラーの対応表、マニフェストテストを調査した。候補は欠けていたファイル単位の境界に直接対応している。同じテーマの履歴は追記専用のまま保ち、本当に独立した論点または実務上のサイズシグナルに達した場合だけ新しい discussion ID を開始し、新記録から前の記録を参照できる。サイズシグナルはパーサーが強制する上限ではないため、硬直した失敗モードを追加しない。また、必須記録フィールド、第3ライフサイクルフェーズ、インストーラーアセットを追加しない。
- 現時点の結論: discussion-validation は pass とする。テーマ境界、実務上のサイズシグナル、軽量性に関する非目標、テンプレートと skill の同期受け入れ範囲を、別々の契約詳細として `agent-013-discussion-record-boundaries` へ昇格する。その後、インストーラーマニフェストを変更せずに、原本テンプレート、discussion skill、`.dodkit` コピー、日本語ミラーを更新できる。
- DECISIONS.yml への昇格: なし。discussion-validation は通過し、昇格対象 -> agent-013-discussion-record-boundaries とその契約サブ決定
- 証拠 / 参照（任意）: `DECISIONS.yml`; `records/agent-005-lightweight-template-roles.md`; `templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `.dodkit/templates/discussion-record.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `install.sh`; `tests/install.test.sh`

### エントリ 0003（2026-08-02）
- 議論の契機: 昇格した境界指示を適用した後、その実装結果を記録する。
- 発見事項 / トレードオフ: `templates/discussion-record.md` と `.dodkit/templates/discussion-record.md` は一致している。英語の discussion skill と日本語のテンプレート／skill ミラーには、独立テーマのトリガー、新しい discussion ID の指示、実務上のサイズシグナル、追記専用の境界、軽量性に関する非目標が入っている。既存のインストーラー回帰テストはマニフェストを変更せずに通過した。YAML パーサー検証では、既存のインストーラー上書きポリシー決定にある未引用コロン（`DECISIONS.yml` 112行目）が引き続き報告される。同じエラーが `HEAD` にも存在するため、今回の限定的なドキュメント変更の範囲外として修正していない。
- 現時点の結論: 実装は昇格した決定契約に一致し、クローズアウト可能である。新しい議論では、記録がレビューしにくくなる前に分割するための明示的な指示が得られ、同じテーマの短い継続にはヒューリスティックの柔軟性も残っている。
- DECISIONS.yml への昇格: 昇格済み -> agent-013-discussion-record-boundaries、agent-013-1-one-theme-per-record、agent-013-2-practical-record-size-signal、agent-013-3-lightweight-boundary-nongoals、agent-013-4-template-skill-sync-acceptance
- 証拠 / 参照（任意）: `templates/discussion-record.md`; `.dodkit/templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `tests/install.test.sh`（`[PASS] install.sh function-level tests passed`）; `DECISIONS.yml` の基準時点パース検証
