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

## Implementation Update (2026-05-22)
- Extended the `copilot` installer manifest to include the five shipped DOD skill templates.
- The installer now maps `templates/skills/*.skill.md` sources into `.github/skills/<skill-name>/SKILL.md` outputs.
- Installer validation guidance now includes the five installed skill files in addition to the DOD agent file and discussion-record template.
- Function-level installer validation passed with `bash tests/install.test.sh` after the manifest update.

## Discussion Update (2026-07-18)
- A reinstall through `curl -fsSL https://raw.githubusercontent.com/mkgask/DODKit/main/install.sh | bash` downloaded a changed `templates/agent.md`, but `.github/agents/dod.agent.md` was skipped after the overwrite prompt received no affirmative answer.
- `dod.agent.md` is not listed in `PROTECT_FROM_OVERWRITE`; it is an ordinary manifest-managed output. The skip came from the general existing-file confirmation path, which is reached before the installer can copy any changed non-protected asset.
- The user-facing reinstall objective is to use rerunning the pinned installer as the update mechanism for declared DOD assets. `DECISIONS.yml` remains project data and must keep its unconditional protection, while identical managed outputs should remain `Already up-to-date`.
- The candidate direction is to update changed manifest-managed outputs by default on reinstall, without creating backups. This intentionally treats those declared outputs as installer-owned files; local customizations to them are replaced by the current source templates.

## Discussion Validation Update (2026-07-18)
- The candidate direction fits the original installer objective because a rerun can deliver current agent and skill templates without requiring an interactive answer or a separate update command.
- It preserves the active workspace-only, template-source, idempotent, and fail-fast constraints. The existing `DECISIONS.yml` protection remains a separate invariant and continues to take precedence over any overwrite behavior.
- The candidate does change the previous prompt-on-conflict rule for declared managed outputs. That trade-off is explicit and bounded to manifest destinations; it does not authorize writes to undeclared paths or project decision data.
- Promote the managed-output reinstall rule by updating `agent-002-8-existing-file-overwrite-policy` in `DECISIONS.yml`, then validate the installer and documentation together.

## Implementation Update (2026-07-18)
- The overwrite policy was promoted so changed installer-managed outputs are updated by default during reinstall, while unchanged outputs remain untouched and `DECISIONS.yml` remains protected.
- Focused shell tests cover the changed-file update path and the protected decision-file path alongside the existing idempotence and target installation checks.

## Discussion Update (2026-07-18)
- Follow-up user feedback clarified that the default should remain overwrite, but the interactive confirmation should remain visible so a user can decline a particular replacement.
- The refined direction is an affirmative-default prompt (`Overwrite this file? [Y/n]:`) for changed managed files in an interactive terminal. Empty input accepts the overwrite, while an explicit `n` preserves that file. Non-interactive execution cannot answer a prompt and therefore keeps automatic managed-file updates; `--force` bypasses confirmation.

## Discussion Validation Update (2026-07-18)
- The refined direction preserves the reinstall objective while restoring a visible last-moment choice for interactive users. It keeps identical-file idempotence, workspace-only writes, template sourcing, no-backup behavior, and unconditional `DECISIONS.yml` protection.
- The distinction between interactive and non-interactive execution is explicit, so piping the installer through `bash` does not silently wait for input when no terminal is available.
- Promote the refined confirmation behavior in `agent-002-8-existing-file-overwrite-policy` and validate both pseudo-terminal responses and non-interactive installation.

## Implementation Update (2026-07-18)
- Restored the overwrite confirmation for changed managed outputs with an affirmative default. Explicit `n` skips that file; empty input, other affirmative input, and non-interactive execution continue with the update.
- Kept `--force` as the confirmation bypass and updated the completion notice, README files, and focused shell tests to describe and verify the refined behavior.

## Discussion Update (2026-07-18)
- Follow-up feedback proposed replacing the boolean-style `--force` switch with an explicit `--overwrite yes|no` option so automation states its overwrite decision directly.
- The candidate policy is to use `ask` as the internal default when `--overwrite` is omitted. Interactive terminals retain the affirmative-default prompt; `--overwrite yes` overwrites changed managed files without prompting, and `--overwrite no` preserves them without prompting.
- When the default `ask` policy has no usable terminal, the installer cannot obtain an answer and keeps the existing non-interactive update behavior. Explicit `--overwrite yes|no` always takes precedence over terminal detection. `DECISIONS.yml` remains protected in every mode.

## Discussion Validation Update (2026-07-18)
- The candidate policy satisfies the reinstall objective because users can keep the default terminal confirmation while scripted callers can choose `yes` or `no` explicitly without relying on prompt input.
- It preserves idempotence for identical files, workspace-only writes, template-based sourcing, no-backup behavior, symlink protection, and unconditional `DECISIONS.yml` protection. The option changes only the decision for changed manifest-managed outputs.
- Replacing `--force` removes the ambiguous boolean switch and makes both overwrite outcomes testable. The parser must reject missing or invalid values and the implementation must reject the legacy option.
- Promote the policy in `agent-002-8-existing-file-overwrite-policy` and the related `DECISIONS.yml` protection text, then validate parser, overwrite, documentation, and target-install behavior together.

## Implementation Update (2026-07-18)
- Replaced `FORCE_OVERWRITE` and `--force` with `OVERWRITE_POLICY` and `--overwrite yes|no`. Omitted options use the `ask` policy; explicit `yes` and `no` bypass the prompt in their respective directions.
- Preserved the existing affirmative-default terminal prompt, non-interactive update fallback, idempotent unchanged-file path, symlink protection, and unconditional protection for an existing `DECISIONS.yml`.
- Updated focused shell tests and English/Japanese README files. Validation covers parser acceptance and rejection, explicit yes/no outcomes, default prompt behavior, non-interactive updates, target manifests, and protected decision data.

## Discussion Update (2026-07-18)
- Follow-up feedback confirmed that the omitted `--overwrite` policy asks separately for each changed managed file, and proposed an `a` response to switch the remainder of the current install to overwrite-all behavior.
- The candidate prompt is `Overwrite this file? [Y/n/a] (a = all):`. Enter accepts the current file only, `n` preserves the current file only, and `a` overwrites the current file and changes the session policy to `yes` for all subsequent changed managed files. There is no all-no shortcut because overwrite is the affirmative default and per-file `n` remains available.
- The `a` transition is session-scoped and applies only while the omitted-option `ask` flow is running. Explicit `--overwrite yes|no` continues to take precedence, non-interactive `ask` continues to update automatically, and `DECISIONS.yml` remains protected even after `a`.

## Discussion Validation Update (2026-07-18)
- The candidate preserves the original reinstall objective while reducing repetitive confirmation for the common case where the user wants to update all current managed templates. A per-file `n` remains available for the exceptional file, so an all-no shortcut is unnecessary.
- The prompt should use `Overwrite this file? [Y/n/a] (a = all remaining files):` so the scope of `a` is explicit. Enter and `n` affect only the current file; `a` affects the current file and transitions the current install to the same effective behavior as `--overwrite yes`.
- The transition must be session-local: it must not alter future invocations, must not override an explicit `--overwrite no`, and must never bypass the existing protected-file check for `DECISIONS.yml`. Non-interactive `ask` remains automatic because no prompt answer can be obtained.
- Validation must cover a multi-file sequence where `a` is entered once and later files receive no prompt, alongside existing Enter, `n`, explicit yes/no, non-interactive, protected-file, idempotence, symlink, and target-manifest checks.
- Promote this behavior in `agent-002-8-existing-file-overwrite-policy`, then implement and validate the session transition and the exact prompt text.

## Implementation Update (2026-07-18)
- Extended the interactive overwrite prompt to `Overwrite this file? [Y/n/a] (a = all remaining files):`. Enter accepts only the current file, `n` preserves only the current file, and `a` accepts the current file and changes the current install policy to `yes` for all subsequent changed managed files.
- Kept the transition session-scoped and below the existing protected-file check, so `a` cannot overwrite `DECISIONS.yml` and does not affect later invocations or explicit `--overwrite no` runs.
- Updated focused tests and English/Japanese README files. Validation covers the exact prompt, one-time `a` input across multiple overwrite checks, existing Enter and `n` responses, explicit yes/no policies, non-interactive behavior, and all existing installer safety checks.
