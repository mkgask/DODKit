# DODKit

[English](../../README.md) | [日本語版](README.md)

> **アルファ版ソフトウェアです。** DODKit は開発初期段階にあります。不具合や破壊的変更が含まれる可能性があります。使用は自己責任でお願いします。

DODKit は Decision Oriented Development（DOD）を軽量に運用するためのツールキットです。
現在有効な決定事項を明示し、決定の履歴と現在の拘束条件を分離し、再利用可能な Copilot または Cursor のカスタマイズアセットをワークスペースへ導入できる実践的な構成を提供します。

## インストール

インストーラーはリポジトリルートの `install.sh` です。
GitHub Copilot と Cursor に対応しており、現在のワークスペースディレクトリへ DOD アセットを導入します。

インストール/コピーされるアセット:
- 両ターゲット共通:
	- `.dodkit/templates/discussion-record.md`
	- `DECISIONS.yml`（存在しない場合のみ導入。既存ファイルは `--force` 指定時でも保護されます）
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

# 既存の対象ファイルを強制上書き
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --force
```

## DOD とは

Decision Oriented Development（DOD）は、決定事項を持続可能に蓄積し続けることを中心に据えた軽量な開発手法です。

詳細仕様は [DOD.md](DOD.md) を参照してください。

中核となる考え方:
- `DECISIONS.yml` は、現在有効な決定事項と実装拘束条件の正本。
- `records/{discussion-id}.md` は、背景・調査・トレードオフ・代替案などの不変な議論履歴。

この分離により、必要なときは議論の全体像を参照しつつ、普段は過去履歴を広く読み直さずに次の決定を進めやすくなります。
