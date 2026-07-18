# DODKit

[English](README.md) | [日本語版](.docs/ja/README.md)

> **Alpha software.** DODKit is in early development. It may contain bugs or breaking changes. Use at your own risk.

DODKit is a lightweight toolkit for Decision Oriented Development (DOD).
It provides a practical structure for keeping active decisions explicit, separating decision history from current constraints, and installing reusable Copilot, Cursor, or user-directed Grok customization assets into a workspace.

## Install

The installer is a single shell script at the repository root (`install.sh`).
It supports GitHub Copilot, Cursor, and a user-directed Grok workspace convention, and installs the current DOD assets into your current workspace directory.

Installed/copied assets:
- Shared for both targets:
	- `.dodkit/templates/discussion-record.md`
	- `DECISIONS.yml` (installed only when missing; existing file is preserved even with `--overwrite yes`)
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
- For `grok`:
	- `.grok/dod.agent.md`
	- `.grok/discussion.skill.md`
	- `.grok/discussion-validation.skill.md`
	- `.grok/decision-promotion.skill.md`
	- `.grok/implementation.skill.md`
	- `.grok/implementation-validation.skill.md`

The `.grok` directory is a workspace convention for files that you explicitly provide to Grok. It is not an official automatic Grok discovery path.

On reinstall, changed files declared in the selected target manifest are managed outputs, while identical files remain unchanged. When `--overwrite` is omitted, an interactive terminal asks `Overwrite this file? [Y/n/a] (a = all remaining files):`; pressing Enter accepts the current file, `n` keeps the current file, and `a` accepts the current file and overwrites all remaining changed managed files without further prompts. `--overwrite yes` overwrites changed managed files without confirmation, and `--overwrite no` keeps them without confirmation. If the default ask policy has no usable terminal, changed managed files update automatically. This includes the agent and skill files, so local edits to those managed outputs can be replaced by the current templates. Existing `DECISIONS.yml` is the exception: it is project data and is never overwritten, even with `--overwrite yes` or `a`.

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

# Install user-directed Grok assets
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- grok

# Overwrite changed managed target files without confirmation
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --overwrite yes

# Keep changed managed target files without confirmation
curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash -s -- cursor --overwrite no
```

## What is DOD?

Decision Oriented Development (DOD) is a lightweight development method centered on the sustainable accumulation of decisions.

For the full specification, see [DOD.md](DOD.md).

Core idea:
- `DECISIONS.yml` is the canonical list of active decisions and current implementation constraints.
- `records/{discussion-id}.md` keeps immutable discussion history such as context, research, trade-offs, and alternatives.

This separation helps teams make the next decision quickly without rereading broad history, while still preserving full discussion context when needed.
