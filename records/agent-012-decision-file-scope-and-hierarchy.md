# Decision Record: agent-012-decision-file-scope-and-hierarchy

## Metadata
- Created At: 2026-07-18
- Scope: Decide whether active DOD decisions may be scoped by nested directories while preserving project-wide constraints

## Notes
- This file is append-only discussion history.
- Do not add mutable tracking fields here (status, remaining work, open action items).
- Do not keep open-question backlogs here. If clarification is needed, ask in chat and append the resolved facts.
- If a fact becomes a binding implementation constraint, promote it to DECISIONS.yml.
- Keep each entry as short as the discussion allows.
- Evidence and detailed promotion metadata are optional; omit them when the entry stays clear without them.

Append rules:

- Append at EOF only; do not edit earlier sections.
- Do not add status tracking or remaining-work items.

## Entry List

### Entry 0001 (2026-07-18)
- Why now: The current repository only needs the root-level `install.sh` implementation and one root `DECISIONS.yml`, but a future application may contain several components and internal modules written in different languages. `AGENTS.md` can be nested by directory, so the scope model for `DECISIONS.yml` needs to be considered before the repository grows around a root-only assumption.
- Findings / trade-offs: DOD currently defines `DECISIONS.yml` as the canonical list of active decisions and binding implementation constraints. The repository documentation, agent template, and installer all treat the root file as a shared workspace artifact, and the installer protects that file from overwrite. The existing decision hierarchy is inside one YAML document through categories and `sub_decisions`; it does not define filesystem-level discovery or inheritance. Keeping only the root file is simplest and keeps cross-component contracts visible, which is sufficient for the current installer scope. Allowing independent decision files in arbitrary directories without an effective-set rule would instead make it unclear which constraints apply to a file, how parent and child conflicts are resolved, where cross-component decisions belong, and whether an agent must inspect sibling or descendant directories. The bounded candidate direction is to keep the root `DECISIONS.yml` as the project-wide baseline, allow optional nested `DECISIONS.yml` files as additive constraints for their directory subtrees, resolve applicable files from the root toward the nearest ancestor, keep cross-component constraints at the root, and treat parent-child conflicts as validation failures rather than silently selecting a more specific value. The established plural filename `DECISIONS.yml` should remain unchanged; `DECISION.yml` would introduce an unnecessary terminology variant.
- Current conclusion: The repository should evolve toward a scoped hierarchy, but not by making every directory an independent decision universe. The root-only form remains valid for small projects and for the current `install.sh` implementation. A future hierarchical implementation should make root decisions apply globally and nested decisions apply only to their subtrees as additional constraints, with explicit discovery, identity, conflict, and validation rules before the behavior is enabled. This direction preserves the current canonical-root and scanability goals while leaving room for multi-module applications.
- Promotion to DECISIONS.yml: none; candidate direction is ready for discussion-validation before promotion
- Evidence / references (optional): `DOD.md`; `README.md`; `templates/agent.md`; `templates/DECISIONS.yml`; `install.sh`; `tests/install.test.sh`; `records/agent-004-installer-template-details.md`; `records/agent-005-lightweight-template-roles.md`; `records/agent-006-agent-orchestration-model.md`; `records/agent-007-phase-verification-model.md`; `records/agent-010-decision-single-field.md`

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-07-18)
- Why now: Validate the candidate hierarchy direction against the original objective and the active DOD and installer constraints before making it binding.
- Findings / trade-offs: Discussion-validation covered the current decision specification, agent guidance, installer manifest and overwrite protection, focused installer tests, and the related records about template scope, lightweight decision structure, orchestration, phase verification, and the single decision field. The candidate direction preserves the root canonical file and current root-oriented installation, addresses the future multi-module scope question, and avoids silently resolving parent-child conflicts. It also keeps the two-phase DOD model unchanged. The exact discovery algorithm, decision identity rules, merge representation, and executable support for nested files remain intentionally non-binding until a later implementation discussion.
- Current conclusion: The candidate direction fits the original objective and active constraints. Promote the root baseline, additive ancestor scope, cross-scope conflict validation, and deferred runtime activation as the agent-012 decision family.
- Promotion to DECISIONS.yml: promoted -> agent-012-decision-file-scope-and-hierarchy, agent-012-1-root-baseline, agent-012-2-nested-additive-scope, agent-012-3-cross-scope-conflict, agent-012-4-hierarchy-runtime-deferred
- Evidence / references (optional): `DOD.md`; `README.md`; `templates/agent.md`; `templates/DECISIONS.yml`; `install.sh`; `tests/install.test.sh`; `DECISIONS.yml`; `.docs/ja/DECISIONS.yml`
- Evidence / references (optional): `DOD.md`; `README.md`; `templates/agent.md`; `templates/DECISIONS.yml`; `install.sh`; `tests/install.test.sh`; `DECISIONS.yml`; `.docs/ja/DECISIONS.yml`

### Entry 0003 (2026-07-18)
- Why now: Reconsider the prior conflict behavior for non-interactive environments. A hard validation stop is undesirable when the applicable parent-child relationship provides a deterministic resolution and the environment is expected to complete in one run without user input.
- Findings / trade-offs: Non-interactive CI and batch execution cannot answer a question, so stopping on every parent-child conflict makes one-shot execution fail even when scope specificity provides an explicit ordering. Choosing the narrower child decision with a warning is different from silently overriding the parent: the diagnostic can identify the affected paths, decision IDs, conflicting constraints, and fallback that was applied. Interactive execution should still ask the user when a conflict needs a judgment call. The fallback must be limited to an unambiguous parent-child conflict; same-scope duplicates, sibling ambiguity, unknown decision identity, or any conflict without a deterministic scope relation must remain validation failures because no safe automatic choice exists.
- Current conclusion: Change the parent-child conflict rule so an interactive run asks the user with actionable conflict details, while a non-interactive run warns and continues with the narrower child decision when the scope relationship is unambiguous. Keep unresolved ambiguity as a validation failure and add an explicit decision for diagnostics, interactive resolution, and the non-interactive fallback.
- Promotion to DECISIONS.yml: promoted -> agent-012-3-cross-scope-conflict, agent-012-5-actionable-conflict-resolution
- Evidence / references (optional): `DOD.md`; `templates/skills/discussion-validation.skill.md`; `DECISIONS.yml`; `records/agent-012-decision-file-scope-and-hierarchy.md`

### Entry 0004 (2026-07-18)
- Why now: Implement the approved scope guidance in the project documentation and agent template while preserving the current root-oriented installer behavior.
- Findings / trade-offs: `DOD.md` and `templates/agent.md` now describe DOD as applicable across languages, runtimes, project layouts, components, and artifact types. The documents define the project-level `DECISIONS.yml` as the baseline, require explicit activation before scoped decision files are used, and describe deterministic validation for projects without executable test harnesses. Scoped conflict diagnostics and the interactive/non-interactive fallback are documented without enabling nested-file discovery or changing `install.sh`. Japanese mirrors were updated with the same operational meaning.
- Current conclusion: The documentation implementation preserves the approved root baseline, additive scoped constraints, deferred hierarchy runtime, and actionable conflict policy. No additional active decision was needed because the artifact-generalization language clarifies the existing DOD phase and validation contracts rather than introducing a new runtime behavior.
- Promotion to DECISIONS.yml: no new decision; the agent-012 decision family is ready for implementation approval after implementation validation.
- Evidence / references (optional): `DOD.md`; `templates/agent.md`; `.docs/ja/DOD.md`; `.docs/ja/templates/agent.md`; `install.sh`; `tests/install.test.sh`
