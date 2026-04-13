# DODKit

[English](README.md) | [日本語版](.docs/ja/README.md)

> **Alpha software.** DODKit is in early development. It may contain bugs or breaking changes. Use at your own risk.

DODKit is a lightweight toolkit for Decision Oriented Development (DOD).
It provides a practical structure for keeping active decisions explicit, separating decision history from current constraints, and installing reusable Copilot customization assets into a workspace.

## Install

The installer is a single shell script at the repository root (`install.sh`).
It currently supports GitHub Copilot only and installs the current DOD assets into your current workspace directory.

Installed/copied assets:
- `.github/agents/dod.agent.md`
- `.dodkit/templates/discussion-record.md`
- `DECISIONS.yml` (installed only when missing; existing file is preserved even with `--force`)

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
# Force overwrite existing target files
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- --force
```

## What is DOD?

Decision Oriented Development (DOD) is a lightweight development method centered on the sustainable accumulation of decisions.

For the full specification, see [DOD.md](DOD.md).

Core idea:
- `DECISIONS.yml` is the canonical list of active decisions and current implementation constraints.
- `records/{discussion-id}.md` keeps immutable discussion history such as context, research, trade-offs, and alternatives.

This separation helps teams make the next decision quickly without rereading broad history, while still preserving full discussion context when needed.
