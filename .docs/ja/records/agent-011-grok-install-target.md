# Decision Record: agent-011-grok-install-target

## Metadata
- Created At: 2026-07-15
- Scope: `.grok` 配下へワークスペースローカルアセットを配置する Grok インストーラーターゲットの追加

## Notes
- このファイルは追記専用の議論履歴です。
- 変更可能な追跡項目（status、残作業、未完了アクション）は追加しません。
- 未解決の質問一覧は保持しません。確認が必要な場合はチャットで質問し、解決した事実を追記します。
- 事実が実装拘束条件になった場合は DECISIONS.yml へ昇格します。
- 各エントリは可能な範囲で簡潔に保ちます。
- 根拠と詳細な昇格情報は、エントリだけで明確でない場合に限り記載します。

Append rules:
- 末尾への追記だけを行い、過去のセクションは編集しません。
- status や残作業の追跡情報は追加しません。

## Entry List

### Entry 0001（2026-07-15T00:00:00Z）
- Why now: `grok` を明示的なインストーラーターゲットとして追加するため。要求されたワークスペース上の convention は Grok 関連の DOD ファイルを `.grok` 配下へ配置することであり、Grok には既知のリポジトリ内ディレクトリ自動検出契約がありません。
- Findings / trade-offs: 現在の `install.sh` は `copilot` と `cursor` に対応し、ターゲット別の source/destination 対応をアセット仕様として保持し、共有ワークスペースアセットを `DECISIONS.yml` と `.dodkit/templates/discussion-record.md` に配置しています。Copilot は agent と skill を `.github` にコピーし、Cursor は共有ソースを `.cursor/rules/*.mdc` へ render します。xAI のドキュメント概要では Grok Build と Code API は案内されていますが、`.grok` を自動的に命令ファイルとして検出する仕様は定義されていません。そのため、ユーザーから提示された運用前提は公式 discovery behavior ではなく、ローカル convention として扱います。
- Current conclusion: `grok` を明示的なターゲット集合へ追加し、共有 agent source を `.grok/dod.agent.md` へ、5つの shipped skill source を `.grok/<skill-name>.skill.md` へ直接コピーする方針とします。`DECISIONS.yml` と `.dodkit/templates/discussion-record.md` は editor-specific instructions ではなくプロジェクト DOD アーティファクトのため、既存の共有ワークスペースパスに残します。Grok 向けに Cursor frontmatter を render せず、Grok が `.grok` を自動検出するとは表現しません。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): `install.sh`; `tests/install.test.sh`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0002（2026-07-15T00:10:00Z）
- Why now: 候補となる Grok 方向を、拘束条件として確定する前に、要求された動作と現在有効な installer/template 制約に照らして検証するため。
- Findings / trade-offs: この方向は、`install.sh grok` が `.grok/` で始まる専用ターゲットマニフェストを選択できるため、元の要求を満たします。ワークスペース内だけへの書き込み、idempotent な staged installation、既存ファイル保護、`source|destination|asset_name` マニフェスト契約、共有 template source の分離、正本 `DECISIONS.yml` の保護を維持します。トレードオフとして、`.grok` はユーザーが明示的に読ませるための見える convention として有用ですが、installer が Grok による自動検出や命令実行を保証することはできません。
- Current conclusion: Discussion-validation は通過しました。不変条件は、`copilot`、`cursor`、`grok` のみに対応すること、引数なしの動作を `copilot` のままにすること、Grok の agent と skill source を `.grok` へ直接コピーすること、共有 DOD アーティファクトを既存パスに残すこと、Grok に Cursor 固有の rendering を適用しないことです。非目標は native Grok integration、自動 discovery の主張、Grok 専用 source template の追加、正本の決定ファイルの移動です。受入条件は parser/target validation、すべての `.grok` output と共有 asset を確認する fake-download の Grok install test、Copilot/Cursor 動作の維持、インストール案内の同期です。`.grok` 外への Grok target-specific file の書き込み、正本の decision file の上書き、未対応ターゲットの暗黙受け入れは失敗とします。
- Promotion to DECISIONS.yml: promoted -> agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-15-initial-grok-template-manifest, agent-004-11-grok-asset-destinations
- Evidence / references (optional): `DECISIONS.yml`; `install.sh`; `tests/install.test.sh`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0003（2026-07-15T00:15:00Z）
- Why now: Grok instruction discovery の境界について、決定昇格が完了したことを記録するため。
- Findings / trade-offs: discovery boundary は独立した実装拘束条件です。documentation と validation で `.grok` を native Grok configuration path と誤解させない必要がありますが、別の installer mechanism は不要であり、既存の明示的 target manifest と direct-copy path で対応できます。
- Current conclusion: active decision set に `.grok` convention の境界を `agent-002-16-grok-discovery-boundary` として追加しました。この制限を案内に残したまま実装へ進めます。
- Promotion to DECISIONS.yml: promoted -> agent-002-16-grok-discovery-boundary
- Evidence / references (optional): `DECISIONS.yml`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0004（2026-07-15T00:30:00Z）
- Why now: 昇格済み Grok installer target decision の実装と implementation-validation が完了したため。
- Findings / trade-offs: `install.sh` は `grok` を受け付け、`GROK_ASSET_SPECS` を選択し、Grok agent と5つの skill を `.grok` 配下へ直接配置し、shared decision と discussion-record asset を既存パスへ配置するようになりました。引数なし時の既定値は `copilot` のまま維持し、未対応ターゲットには3つすべての対応ターゲットを含むエラーを返し、Cursor rendering は変更していません。README は英日で同期し、`.grok` をユーザーが明示的に利用する convention として案内しています。
- Current conclusion: Grok target は元の要求と昇格済み不変条件を満たします。focused test では parsing、validation、manifest destination、fake-download installation、shared asset、既存の Copilot/Cursor 動作を確認しています。
- Promotion to DECISIONS.yml: implementation approved -> agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-15-initial-grok-template-manifest, agent-002-16-grok-discovery-boundary, agent-004-11-grok-asset-destinations
- Evidence / references (optional): `install.sh`; `tests/install.test.sh`; `README.md`; `.docs/ja/README.md`; `bash tests/install.test.sh`; `bash install.sh --help`
