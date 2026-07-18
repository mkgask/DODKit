# DODKit

[English](../../README.md) | [日本語版](README.md)

> **アルファ版ソフトウェアです。** DODKit は開発初期段階にあります。不具合や破壊的変更が含まれる可能性があります。使用は自己責任でお願いします。

DODKit は Decision Oriented Development（DOD）を軽量に運用するためのツールキットです。
現在有効な決定事項を明示し、決定の履歴と現在の拘束条件を分離し、再利用可能な Copilot、Cursor、またはユーザーが明示的に Grok へ提供するためのカスタマイズアセットをワークスペースへ導入できる実践的な構成を提供します。

## インストール

インストーラーはリポジトリルートの `install.sh` です。
GitHub Copilot、Cursor、およびユーザーが明示的に利用する Grok のワークスペース convention に対応しており、現在のワークスペースディレクトリへ DOD アセットを導入します。

インストール/コピーされるアセット:
- 両ターゲット共通:
	- `.dodkit/templates/discussion-record.md`
	- `DECISIONS.yml`（存在しない場合のみ導入。既存ファイルは `--overwrite yes` 指定時でも保護されます）
- `copilot` 向け:
	- `.github/agents/dod.agent.md`
	- `.github/skills/discussion/SKILL.md`
	- `.github/skills/discussion-validation/SKILL.md`
	- `.github/skills/decision-promotion/SKILL.md`
	- `.github/skills/implementation/SKILL.md`
	- `.github/skills/implementation-validation/SKILL.md`
- `cursor` 向け:
	- `.cursor/rules/dod-implementation-agent.mdc`
	- `.cursor/rules/discussion.mdc`
	- `.cursor/rules/discussion-validation.mdc`
	- `.cursor/rules/decision-promotion.mdc`
	- `.cursor/rules/implementation.mdc`
	- `.cursor/rules/implementation-validation.mdc`
- `grok` 向け:
	- `.grok/dod.agent.md`
	- `.grok/discussion.skill.md`
	- `.grok/discussion-validation.skill.md`
	- `.grok/decision-promotion.skill.md`
	- `.grok/implementation.skill.md`
	- `.grok/implementation-validation.skill.md`

`.grok` ディレクトリは、ユーザーが Grok に明示的に提供するファイルのためのワークスペース convention です。公式の Grok 自動 discovery path ではありません。

再インストール時は、選択したターゲットのマニフェストに宣言されたファイルを管理対象として扱い、同一内容のファイルは変更しません。`--overwrite` を省略した場合、対話端末では `Overwrite this file? [Y/n]:` と確認し、Enter で既定の上書きを受け入れ、`n` でそのファイルを保持します。`--overwrite yes` は確認なしで変更済み管理対象を上書きし、`--overwrite no` は確認なしで保持します。既定の ask ポリシーで利用可能な端末がない場合は、変更済み管理対象を自動更新します。agent と skill files も管理対象のため、それらへのローカル編集は現在のテンプレートで置き換えられる可能性があります。`DECISIONS.yml` だけは例外で、プロジェクトデータとして扱い、`--overwrite yes` 指定時も上書きしません。

### curl でインストール

```bash
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash
```

### wget でインストール

```bash
wget -qO- https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash
```

### インストーラーの任意引数

```bash
# 既定の Copilot ではなく Cursor 向けアセットを導入
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor

# ユーザーが Grok に明示的に提供するアセットを導入
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- grok

# 確認を省略して変更済み管理対象ファイルを上書き
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --overwrite yes

# 確認を省略して変更済み管理対象ファイルを保持
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --overwrite no
```

## DOD とは

Decision Oriented Development（DOD）は、決定事項を持続可能に蓄積し続けることを中心に据えた軽量な開発手法です。

詳細仕様は [DOD.md](DOD.md) を参照してください。

中核となる考え方:
- `DECISIONS.yml` は、現在有効な決定事項と実装拘束条件の正本。
- `records/{discussion-id}.md` は、背景・調査・トレードオフ・代替案などの不変な議論履歴。

この分離により、必要なときは議論の全体像を参照しつつ、普段は過去履歴を広く読み直さずに次の決定を進めやすくなります。
