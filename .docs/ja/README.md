# DODKit

[English](../../README.md) | [日本語版](README.md)

DODKit は Decision Oriented Development（DOD）を軽量に運用するためのツールキットです。
現在有効な決定事項を明示し、決定の履歴と現在の拘束条件を分離し、再利用可能な Copilot カスタマイズアセットをワークスペースへ導入できる実践的な構成を提供します。

## インストール

インストーラーはリポジトリルートの `install.sh` です。
現在は GitHub Copilot のみに対応しており、現在のワークスペースディレクトリへ DOD アセットを導入します。

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
# 既存の対象ファイルを強制上書き
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- --force
```

## DOD とは

Decision Oriented Development（DOD）は、決定事項を持続可能に蓄積し続けることを中心に据えた軽量な開発手法です。

詳細仕様は [DOD.md](DOD.md) を参照してください。

中核となる考え方:
- `DECISIONS.yml` は、現在有効な決定事項と実装拘束条件の正本。
- `records/{discussion-id}.md` は、背景・調査・トレードオフ・代替案などの不変な議論履歴。

この分離により、必要なときは議論の全体像を参照しつつ、普段は過去履歴を広く読み直さずに次の決定を進めやすくなります。
