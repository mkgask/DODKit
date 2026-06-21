# DODKit

[English](README.md) | [日本語版](.docs/ja/README.md)

> **Alpha software.** DODKit is in early development. It may contain bugs or breaking changes. Use at your own risk.

DODKit is a lightweight toolkit for Decision Oriented Development (DOD).
It provides a practical structure for keeping active decisions explicit, separating decision history from current constraints, and installing reusable Copilot or Cursor customization assets into a workspace.

## Install

The installer is a single shell script at the repository root (`install.sh`).
It supports GitHub Copilot and Cursor, and installs the current DOD assets into your current workspace directory.

Installed/copied assets:
- Shared for both targets:
	- `.dodkit/templates/discussion-record.md`
	- `DECISIONS.yml` (installed only when missing; existing file is preserved even with `--force`)
- For `copilot`:
	- `.github/agents/dod.agent.md`
	- `.github/skills/discussion/SKILL.md`
	- `.github/skills/discussion-validation/SKILL.md`
	- `.github/skills/decision-promotion/SKILL.md`
	- `.github/skills/implementation/SKILL.md`
	- `.github/skills/implementation-validation/SKILL.md`
- For `cursor`:
	- `.cursor/rules/dod-implementation-agent.mdc`
	- `.cursor/rules/discussion.mdc`
	- `.cursor/rules/discussion-validation.mdc`
	- `.cursor/rules/decision-promotion.mdc`
	- `.cursor/rules/implementation.mdc`
	- `.cursor/rules/implementation-validation.mdc`

### Install with curl

```bash
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash
```

### Install with wget

```bash
wget -qO- https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash
```

### Optional installer arguments

```bash
# Install Cursor assets instead of the default Copilot target
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor

# Force overwrite existing target files
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --force
```

## What is DOD?

Decision Oriented Development (DOD) is a lightweight development method centered on the sustainable accumulation of decisions.

For the full specification, see [DOD.md](DOD.md).

Core idea:
- `DECISIONS.yml` is the canonical list of active decisions and current implementation constraints.
- `records/{discussion-id}.md` keeps immutable discussion history such as context, research, trade-offs, and alternatives.

This separation helps teams make the next decision quickly without rereading broad history, while still preserving full discussion context when needed.
