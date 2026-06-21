# Decision Record: agent-009-cursor-install-target

## Metadata
- Created At: 2026-06-22
- Scope: Add Cursor as an installer target while preserving the current DOD asset flow

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

### Entry 0001 (2026-06-22T00:00:00Z)
- Why now: The installer currently supports only `copilot`, and the requested scope is to add a selectable `cursor` target without abandoning the current DOD workflow shape.
- Findings / trade-offs: The bounded broad scan touched installer CLI parsing and validation, installer manifest decisions, runtime customization asset formats, existing function-level shell tests, and user-facing install docs. The broad scan kept user-level Cursor rules, team rules, non-bash installers, and non-workspace installs out of scope. Official Cursor docs identify project rules as version-controlled `.mdc` files stored under `.cursor/rules`, and plain `.md` files in that directory are ignored because they lack rule frontmatter. The same docs describe `AGENTS.md` as a simpler alternative, but project rules provide deterministic per-file destinations and fit the existing agent-plus-phase-assets flow better. Cursor manual rules with `alwaysApply: false` are closer to the existing explicit-entry workflow than always-applied instructions, because they avoid changing every chat session by default.
- Current conclusion: Keep shared DOD assets target-neutral, add `cursor` as a second explicit installer target, install Cursor-specific main and phase guidance as manual project rules under `.cursor/rules/*.mdc`, and preserve the current no-argument default of `copilot` for backward compatibility.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): https://cursor.com/docs/rules

### Entry 0002 (2026-06-22T00:10:00Z)
- Why now: Discussion-validation is needed before promoting the Cursor direction into active installer and template constraints.
- Findings / trade-offs: The broad scan covered the controlling surfaces for this scope: install target parsing, supported-target validation, target-specific manifests, DOD template destinations, tests, and install documentation. The narrowed focus is justified because Cursor support only changes workspace-scoped runtime asset mapping and does not require a new delivery mechanism, a new record template location, or a new decision phase. The direction fits active constraints because it keeps writes inside workspace paths, preserves `DECISIONS.yml`, retains idempotent reruns, and keeps explicit target validation. The new binding rules that cannot stay implicit are the supported target set, the Cursor manifest contents, the Cursor source-template layout, the Cursor destination paths, and the choice to keep Cursor rule activation opt-in rather than always applied.
- Current conclusion: Discussion-validation passed. Promote Cursor target support by updating the affected `agent-002` and `agent-004` decision families, then implement with minimal installer, test, template, and documentation changes.
- Promotion to DECISIONS.yml: promoted -> agent-002-installer-delivery, agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-14-initial-cursor-template-manifest, agent-004-installer-template-details, agent-004-8-cursor-rule-template-source-layout, agent-004-9-cursor-rule-template-destinations, agent-004-10-cursor-manual-rule-frontmatter
- Evidence / references (optional): https://cursor.com/docs/rules; install.sh; tests/install.test.sh; README.md; records/agent-002-installer-delivery.md; records/agent-004-installer-template-details.md

### Entry 0003 (2026-06-22T01:00:00Z)
- Why now: Implementation and implementation-validation completed for the promoted Cursor installer target scope.
- Findings / trade-offs: `install.sh` now accepts `cursor` as a supported target, keeps `copilot` as the no-argument default, and dispatches through target-specific manifests. Cursor runtime assets are installed as manual project rules under `.cursor/rules/*.mdc`, while shared assets remain `DECISIONS.yml` and `.dodkit/templates/discussion-record.md`. The focused validation was `bash tests/install.test.sh`, extended to cover Cursor parsing, manifest membership, and an end-to-end `cursor` install run in a temporary workspace with fake downloads. The existing symlink-protection test is environment-dependent on this Windows bash runtime because `ln -s` does not create a real symlink here, so that test now self-skips when the runtime cannot represent one.
- Current conclusion: The requested Cursor target support is implemented and validated without widening installer scope beyond the explicit `copilot` and `cursor` target set.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): bash tests/install.test.sh

### Entry 0004 (2026-06-22T01:20:00Z)
- Why now: The newly created Cursor rule templates are nearly identical to the Copilot templates, so the current split needs to be re-evaluated before the duplication becomes a maintenance burden.
- Findings / trade-offs: The bounded broad scan for this follow-up touched the Copilot template sources, the installed Cursor rule outputs, the installer manifest arrays, the focused shell tests, and the active template-layout decisions. The only material runtime-specific difference is that Cursor project rules require `.mdc` output with Cursor frontmatter such as `description` and `alwaysApply`, while the body content is otherwise shared with the Copilot templates. That means the prior decision to keep dedicated Cursor source files under `templates/cursor/rules` overfit the current implementation shape instead of the true active constraint, which is rendered Cursor frontmatter plus deterministic `.cursor/rules` destinations.
- Current conclusion: Discussion should switch the active template rule from separate Cursor source files to shared Copilot markdown sources rendered into Cursor `.mdc` outputs at install time.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): templates/agent.md; templates/skills/discussion.skill.md; templates/cursor/rules/dod-implementation-agent.mdc; templates/cursor/rules/discussion.mdc; install.sh; tests/install.test.sh

### Entry 0005 (2026-06-22T01:25:00Z)
- Why now: Discussion-validation is needed before replacing the current dedicated Cursor source-file layout with a rendered shared-source layout.
- Findings / trade-offs: The narrowed focus is justified because the user request is specifically about template-source duplication, not about changing the supported target set, runtime destinations, or manual-rule behavior. The proposed direction still satisfies the active constraints that matter: installer writes remain workspace-scoped, target validation remains explicit, Cursor outputs remain `.cursor/rules/*.mdc`, and Cursor rules remain opt-in manual project rules. The only binding rule that must change is the source-layout decision. The destination-layout and manual-frontmatter decisions stay active, but the frontmatter should now be produced by the installer rather than stored in duplicated source files.
- Current conclusion: Discussion-validation passed. Promote a shared-source rendering model by updating the affected template decisions, then remove the duplicated Cursor source templates and implement installer-side rendering.
- Promotion to DECISIONS.yml: promoted -> agent-004-installer-template-details, agent-004-8-cursor-rule-template-source-layout, agent-004-9-cursor-rule-template-destinations, agent-004-10-cursor-manual-rule-frontmatter, agent-002-14-initial-cursor-template-manifest
- Evidence / references (optional): install.sh; tests/install.test.sh; DECISIONS.yml

### Entry 0006 (2026-06-22T01:40:00Z)
- Why now: Implementation and implementation-validation completed for the shared-source Cursor rendering change.
- Findings / trade-offs: `install.sh` now renders Cursor `.mdc` outputs from the shared Copilot template sources by stripping the source frontmatter, synthesizing Cursor manual-rule frontmatter, and writing the rendered result to `.cursor/rules`. The dedicated Cursor source templates were deleted from both the English and Japanese template trees. Focused validation remained `bash tests/install.test.sh`, updated to verify that the Cursor manifest points at shared sources and that rendered `.mdc` outputs contain the Cursor frontmatter plus the shared markdown body.
- Current conclusion: The shared-source model satisfies the same runtime constraints as the previous split while removing the duplicated Cursor template bodies.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): bash tests/install.test.sh