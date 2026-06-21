# Decision Record: agent-009-cursor-install-target

## メタデータ
- Created At: 2026-06-22
- Scope: 現行のDODアセットフローを保ったまま Cursor をインストーラーターゲットに追加する

## 注意事項
- このファイルは追記専用の議論履歴です。
- 可変の追跡項目（status、remaining work、open action items）は追加しないでください。
- 未解決事項の一覧をここに持ち込まないでください。確認が必要ならチャットで解決し、確定した事実だけ追記してください。
- 事実が拘束力のある実装条件になった場合は、DECISIONS.yml に昇格してください。
- 各エントリは、議論が許す限り短く保ってください。
- 根拠や詳細な昇格メタデータは任意です。なくても明確なら省略してください。

追記ルール:
- 末尾にのみ追記し、過去の節は編集しないでください。
- status や残作業の追跡項目は追加しないでください。

## Entry List

### Entry 0001 (2026-06-22T00:00:00Z)
- Why now: インストーラーは現在 `copilot` のみ対応であり、今回の要求は現在のDODワークフロー形状を崩さずに選択可能な `cursor` ターゲットを追加することです。
- Findings / trade-offs: 境界を保った broad scan では、インストーラーのCLI解析と検証、マニフェスト決定、実行時カスタマイズアセット形式、既存の関数レベルシェルテスト、利用者向けインストール文書を確認しました。user-level Cursor rules、team rules、bash 以外のインストーラー、ワークスペース外インストールは今回の対象外としました。Cursor の公式 docs では、project rules は version-controlled な `.mdc` files として `.cursor/rules` に保存され、同ディレクトリの plain `.md` files は rule frontmatter を欠くため無視されます。同 docs には `AGENTS.md` という簡易代替もありますが、project rules の方がファイル単位の配置先を決定的に扱え、既存の agent-plus-phase-assets フローにもより近く適合します。`alwaysApply: false` の Cursor manual rules は、常時適用 instructions よりも現在の明示的な entry workflow に近く、既定で全チャットに作用しない点でも適切です。
- Current conclusion: 共有DODアセットはターゲット中立のまま維持し、`cursor` を第2の明示インストーラーターゲットとして追加し、Cursor 向けの main guidance と phase guidance は `.cursor/rules/*.mdc` 配下の manual project rules として導入し、引数なし時の既定ターゲットは後方互換のため `copilot` を維持します。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): https://cursor.com/docs/rules

### Entry 0002 (2026-06-22T00:10:00Z)
- Why now: Cursor 方向を active installer/template constraints に昇格する前に discussion-validation が必要です。
- Findings / trade-offs: broad scan は今回の範囲を支配する面を十分に覆っています。install target parsing、supported-target validation、target-specific manifests、DOD template destinations、tests、install documentation が対象であり、Cursor 対応は workspace-scoped runtime asset mapping の変更に留まるため、新しい配布機構や新しい record template location、新しい decision phase は不要です。この方向は、workspace path に書き込みを限定し、`DECISIONS.yml` を保護し、冪等な再実行を維持し、explicit target validation を保つという既存拘束条件にも適合します。暗黙のままにできない新しい binding rules は、supported target set、Cursor manifest contents、Cursor source-template layout、Cursor destination paths、そして Cursor rules を always-apply ではなく opt-in にする選択です。
- Current conclusion: discussion-validation は通過です。影響する `agent-002` と `agent-004` の decision family を更新して Cursor target support を昇格し、その後 minimal な installer/test/template/documentation change として実装します。
- Promotion to DECISIONS.yml: promoted -> agent-002-installer-delivery, agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-14-initial-cursor-template-manifest, agent-004-installer-template-details, agent-004-8-cursor-rule-template-source-layout, agent-004-9-cursor-rule-template-destinations, agent-004-10-cursor-manual-rule-frontmatter
- Evidence / references (optional): https://cursor.com/docs/rules; install.sh; tests/install.test.sh; README.md; records/agent-002-installer-delivery.md; records/agent-004-installer-template-details.md

### Entry 0003 (2026-06-22T01:00:00Z)
- Why now: 昇格済みの Cursor インストーラーターゲット範囲について、implementation と implementation-validation が完了しました。
- Findings / trade-offs: `install.sh` は `cursor` を対応ターゲットとして受け付けるようになり、引数なし時の既定値は後方互換のため `copilot` のまま維持されています。実行時はターゲットごとの manifest で分岐し、Cursor 向け runtime assets は `.cursor/rules/*.mdc` 配下の manual project rules として導入され、共有 assets は `DECISIONS.yml` と `.dodkit/templates/discussion-record.md` のままです。focused validation は `bash tests/install.test.sh` で、Cursor の引数解析、manifest membership、fake downloads を使った一時ワークスペースでの end-to-end `cursor` install 実行まで拡張して確認しました。既存の symlink 保護テストは、この Windows bash 環境では `ln -s` が実 symlink を作らないため環境依存であり、ランタイムが実 symlink を表現できない場合は self-skip するようにしました。
- Current conclusion: 要求された Cursor ターゲット対応は、対応ターゲット集合を `copilot` と `cursor` に限定したまま実装・検証済みです。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): bash tests/install.test.sh

### Entry 0004 (2026-06-22T01:20:00Z)
- Why now: 新しく作成された Cursor rule templates が Copilot テンプレートとほぼ同一であり、この分離を放置すると保守コストが増えるため、現行方針の妥当性を再評価する必要があります。
- Findings / trade-offs: この follow-up の bounded broad scan では、Copilot 側の template sources、インストール後の Cursor rule outputs、installer manifest arrays、focused shell tests、そして現在有効な template-layout decisions を確認しました。実行時に本当に異なる要件は、Cursor project rules が `description` と `alwaysApply` を含む Cursor frontmatter を持つ `.mdc` 出力であることだけで、本文内容は Copilot テンプレートと共有可能です。つまり、`templates/cursor/rules` 配下に Cursor 専用 source files を持つという従来の決定は、実際の拘束条件ではなく当座の実装形状に引っ張られており、真に必要なのは installer が Cursor frontmatter を付与して `.cursor/rules` に決定的に配置することです。
- Current conclusion: active template rule は、専用の Cursor source files を持つ形から、共有する Copilot markdown sources を install 時に Cursor `.mdc` outputs へ render する形へ切り替えるべきです。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): templates/agent.md; templates/skills/discussion.skill.md; templates/cursor/rules/dod-implementation-agent.mdc; templates/cursor/rules/discussion.mdc; install.sh; tests/install.test.sh

### Entry 0005 (2026-06-22T01:25:00Z)
- Why now: 現在の dedicated Cursor source-file layout を rendered shared-source layout に置き換える前に discussion-validation が必要です。
- Findings / trade-offs: この絞り込みは、要求が具体的に template-source duplication を対象としており、supported target set、runtime destinations、manual-rule behavior の変更を求めていないため妥当です。提案方向は、installer の書き込み先が workspace-scoped のままであること、target validation が明示的であること、Cursor outputs が引き続き `.cursor/rules/*.mdc` であること、Cursor rules が opt-in の manual project rules のままであること、という重要な active constraints を引き続き満たします。変更すべき binding rule は source-layout decision だけであり、destination-layout と manual-frontmatter の decision は維持されます。ただし frontmatter は今後 duplicated source files ではなく installer が生成します。
- Current conclusion: discussion-validation は通過です。影響する template decisions を共有ソースの rendering model に更新し、その後 duplicated Cursor source templates を削除して installer 側 render を実装します。
- Promotion to DECISIONS.yml: promoted -> agent-004-installer-template-details, agent-004-8-cursor-rule-template-source-layout, agent-004-9-cursor-rule-template-destinations, agent-004-10-cursor-manual-rule-frontmatter, agent-002-14-initial-cursor-template-manifest
- Evidence / references (optional): install.sh; tests/install.test.sh; DECISIONS.yml

### Entry 0006 (2026-06-22T01:40:00Z)
- Why now: 共有ソース化した Cursor rendering change について、implementation と implementation-validation が完了しました。
- Findings / trade-offs: `install.sh` は、共有する Copilot template sources から Cursor `.mdc` outputs を render するようになり、source frontmatter を落としてから Cursor 用 manual-rule frontmatter を合成し、`.cursor/rules` に書き出します。English / Japanese の両 template tree から dedicated Cursor source templates は削除しました。focused validation は引き続き `bash tests/install.test.sh` で、Cursor manifest が共有ソースを参照していることと、render 後の `.mdc` outputs に Cursor frontmatter と共有 markdown body が含まれることまで確認するよう更新しました。
- Current conclusion: 共有ソースモデルは、従来の分離モデルと同じ runtime constraints を満たしたまま、重複していた Cursor template bodies を除去できています。
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): bash tests/install.test.sh