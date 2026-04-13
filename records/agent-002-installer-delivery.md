# Decision Record: agent-002-installer-delivery

## Metadata
- Status: Accepted
- Date: 2026-04-03
- Scope: Installation and bootstrap workflow

## Context and Research
The custom agent package must be easy to adopt in a clean environment.
Manual copy instructions are error-prone and slow for repeated setup.

Research findings:
- Workspace customization files are file-based assets; they can be provisioned by script.
- A shell installer is the lowest-friction bootstrap for Linux/macOS and WSL workflows.
- A single entry installer can create/update required directories and copy templates safely.

Sources:
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/prompt-files

## Decision
Create a repository installer script that provisions DOD agent assets into the expected workspace locations.

Installer responsibilities:
- verify runtime prerequisites,
- create required directories,
- install or update customization files,
- print post-install validation steps.

This parent decision now has active sub-decisions in `DECISIONS.yml` for:
- template-file based installer inputs,
- initial CLI scope limited to GitHub Copilot Chat.

The detailed history and rationale for those sub-decisions are recorded in this file.

## Decision Contract
### Invariants
- Installer must be idempotent (safe to run multiple times).
- Installer must only write files inside intended workspace customization paths.
- Installer must fail fast with explicit error messages.
- Installer must use template assets as the source of generated/copied customization files.
- Installer must require an explicit CLI target and reject unsupported targets.

### Non-goals
- Do not install system packages globally.
- Do not alter user-level VS Code profile configuration automatically.
- Do not silently overwrite existing files; preserve them unless the user explicitly approves overwrite.
- Do not implement multi-CLI behavior in the first release.

### Acceptance Criteria
- Running installer once creates all required DOD agent files.
- Running installer again does not duplicate entries or corrupt files.
- Installer output clearly indicates success and next validation action.
- Installer templates are separated from runtime output paths and can be extended for additional CLIs later.
- When `copilot` is selected, the current template set is installed into the expected workspace customization paths.
- If a target file already exists, the installer preserves it unless the user explicitly approves overwrite.

### Failure Criteria
- Re-running installer causes duplicate configuration artifacts.
- Installer modifies files outside declared scope.
- Installer exits successfully while required files are missing.
- Unsupported CLI values are accepted silently.
- Installer overwrites an existing target file without explicit user approval.

## Research Update (2026-04-04)
Additional findings used for this decision refinement:
- VS Code customizations are markdown-file based (`.agent.md`, `.prompt.md`, instruction files), which is compatible with template-driven installer generation/copy.
- VS Code customization UI supports multiple agent types (local agents, Copilot CLI, Claude agent). Restricting the initial scope to one CLI is a valid incremental rollout strategy.
- Custom agents can be reused in background agents (Copilot CLI), which justifies a CLI-expansion-ready template structure even when release scope starts with Chat only.

Discussion outcome:
- The template-file rule should not live only in this history record; it is an active sub-decision and is now tracked in `DECISIONS.yml`.
- The GitHub Copilot Chat-only scope should not live only in this history record; it is an active sub-decision and is now tracked in `DECISIONS.yml`.
- Template-file implementation details are important enough to be split into a separate decision record: `agent-004-installer-template-details`.

Sources:
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/customization/prompt-files

## Implementation Specification Snapshot (2026-04-10)
- The accepted CLI target selector for the first release is `copilot`.
- For `copilot`, the initial manifest is:
	- `templates/agent.md` -> `.github/agents/dod.agent.md`
	- `templates/DECISIONS.yml` -> `DECISIONS.yml`
- The installer creates missing parent directories required by that manifest, including `.github/agents`.
- Existing target files take precedence by default; when a target already exists, the installer should ask before overwriting it.
- The first release does not create backup files when handling existing targets.

Promotion outcome:
- The CLI target name, existing-file handling rule, and first-release template file set are now active binding constraints and should be tracked in `DECISIONS.yml`.

## Consequences
Positive:
- Predictable onboarding for contributors.
- Lower support cost for environment setup.

Trade-offs:
- Script maintenance cost increases as customization surface grows.
- Cross-shell compatibility must be verified in CI or manual checks.

## Implementation Update (2026-04-10)
- Implemented root-level `install.sh` with a no-argument default flow (`copilot`) and conflict-time overwrite confirmation.
- Locked installer source to `mkgask/DODKit@main` for safety and reproducibility of official installation behavior.
- Removed source override paths (`--repo`, `--ref`) so installation cannot pull assets from arbitrary repositories or refs.
- Added function-level shell tests (`tests/install.test.sh`) that source `install.sh` and validate parser, target validation, and copy behavior.

## Terminology Synchronization Update (2026-04-13)
- Active terminology is unified to `copilot` as the installer target value.
- Historical mentions of "GitHub Copilot Chat" in this record are retained as discussion context, while active constraints are tracked in `DECISIONS.yml`.

## Implementation Update (2026-04-13)
- Extended the installer manifest to include `templates/discussion-record.md`.
- Added destination mapping for that template: `.dodkit/templates/discussion-record.md`.
- Existing `DECISIONS.yml` preservation behavior remains unchanged and takes precedence over overwrite options.

## Terminology Synchronization Update (2026-04-13)
- Updated the discussion-record template destination from `.dodkit/templates/discussion-record.md` to `DODKit/templates/discussion-record.md`.
- The destination directory is intentionally visible and reserved for DODKit-managed assets.

## Terminology Synchronization Update (2026-04-13)
- Reverted the active destination from `DODKit/templates/discussion-record.md` back to `.dodkit/templates/discussion-record.md`.
- `.dodkit` is aligned with other dot-prefixed tool-managed directories and remains reserved for DODKit-managed assets.
