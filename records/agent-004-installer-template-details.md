# Decision Record: agent-004-installer-template-details

## Metadata
- Status: Discussion Approved
- Date: 2026-04-04
- Scope: Installer template asset structure and output mapping

## Context and Research
The decision to use template files for installer input is already active, but the template details are still underspecified.
If the template layout remains implicit, installer implementation will drift into ad hoc file handling.

This decision is split out from `agent-002-installer-delivery` because template details are independently active rules, not only historical notes.

Current known constraints:
- The installer initially targets GitHub Copilot Chat only.
- Installer outputs must map to workspace customization paths.
- Future CLI expansion is expected, so template structure should remain extensible.

## Decision
Create a standalone decision for installer template file details before implementing the installer.

This decision will define:
- where template files live in the repository,
- how template files map to installed output paths,
- how CLI-specific variants are represented,
- which files are copied directly versus rendered or parameterized.

## Decision Contract
### Invariants
- Template source files must be separate from installed output files.
- Output mapping must be deterministic and inspectable.
- The initial layout must support GitHub Copilot Chat without blocking future CLI additions.

### Non-goals
- Do not finalize multi-CLI support in this decision.
- Do not implement installer execution logic in this decision.
- Do not introduce unnecessary template abstraction before there is a concrete second CLI.

### Acceptance Criteria
- A repository-level template location is defined.
- Each installed output file has a clear source template or generation rule.
- GitHub Copilot Chat templates can be identified without ambiguity.
- Future CLI-specific expansion paths are visible from the structure.

### Failure Criteria
- Template source and output files are mixed together.
- File mapping depends on hidden conventions or manual knowledge.
- The structure assumes only one CLI forever and blocks later extension.

## Open Questions
- Should template files live under a top-level `templates/` directory or a more installer-scoped path?
- Which files should remain literal copies, and which should allow placeholder substitution?
- How should CLI target names be represented in paths and metadata?

## Discussion Resolution (2026-04-04)
Resolved outcomes for the current scope:
- Use `templates/agent.md` as the initial template path.
- Keep the installer's copy-target list inside the installer even if the first release copies only one file.
- Use `raw.githubusercontent.com` as the remote source of copied files.
- Resolve destination paths relative to the current working directory where the installer is executed.

Interpretation for implementation:
- The initial template layout stays minimal rather than introducing early directory nesting.
- A manifest-like list in the installer is required so file mapping remains explicit as the number of copied files grows.
- Source resolution and destination resolution are separate concerns and must not be inferred implicitly from one another.

Current decision effect:
- The open questions above are resolved for the first release scope.
- Active rules derived from this resolution are tracked in `DECISIONS.yml` as sub-decisions under `agent-004-installer-template-details`.

## Implementation Update (2026-04-05)
- Implemented the initial template file at `templates/agent.md`.
- The template content is aligned with the current DOD agent definition to ensure deterministic first-copy behavior.
- `agent-004-1-template-path` is now implementation-approved.
- Remaining work for this parent decision:
	- Implement and verify installer-internal copy-target list management.
	- Apply source/destination resolution rules during installer execution.
