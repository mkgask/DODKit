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

## Decision Contract
### Invariants
- Installer must be idempotent (safe to run multiple times).
- Installer must only write files inside intended workspace customization paths.
- Installer must fail fast with explicit error messages.

### Non-goals
- Do not install system packages globally.
- Do not alter user-level VS Code profile configuration automatically.
- Do not silently overwrite user-modified files without backup or explicit mode.

### Acceptance Criteria
- Running installer once creates all required DOD agent files.
- Running installer again does not duplicate entries or corrupt files.
- Installer output clearly indicates success and next validation action.

### Failure Criteria
- Re-running installer causes duplicate configuration artifacts.
- Installer modifies files outside declared scope.
- Installer exits successfully while required files are missing.

## Consequences
Positive:
- Predictable onboarding for contributors.
- Lower support cost for environment setup.

Trade-offs:
- Script maintenance cost increases as customization surface grows.
- Cross-shell compatibility must be verified in CI or manual checks.
