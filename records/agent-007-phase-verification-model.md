# Decision Record: agent-007-phase-verification-model

## Metadata
- Created At: 2026-04-22
- Scope: Clarify whether DOD needs explicit discussion-validation in addition to implementation validation

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

### Entry 0001 (2026-04-22)
- Why now: Assess whether DOD should add an explicit validation phase, or whether validation should remain embedded inside the existing two-phase model.
- Findings / trade-offs: DOD intentionally stays lightweight with only discussion and implementation phases, but the actual work naturally includes recording discussion, promoting decisions, implementing, and validating. Implementation validation alone is insufficient because code can correctly satisfy an active decision while that decision itself still points in the wrong direction relative to the original purpose. However, adding a separate validation phase would make the process heavier and risks duplicating discussion or implementation work. The lighter alternative is to keep two phases while making two distinct validation checkpoints explicit: discussion-validation before decision promotion, and implementation-validation before closeout. Discussion-validation should verify directional fit against the original objective, active constraints, and likely drift before a candidate conclusion becomes an active decision. Implementation-validation should verify tests, code, and artifacts against the promoted decisions.
- Current conclusion: DOD should keep its two-phase model. It should not add a standalone validation phase, but it should explicitly require lightweight discussion-validation before promoting decisions and explicit implementation-validation before closing implementation work.
- Promotion to DECISIONS.yml: promoted -> agent-007-phase-verification-model, agent-007-1-no-third-phase, agent-007-2-discussion-validation-before-promotion, agent-007-3-implementation-validation-before-closeout
- Evidence / references (optional): DOD.md, DECISIONS.yml, records/agent-005-lightweight-template-roles.md, templates/agent.md

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-04-22)
- Why now: Sync the approved verification model into the active English and Japanese specifications, README summaries, and DOD agent guidance.
- Findings / trade-offs: The specification and agent guidance now keep DOD as a two-phase method while making two verification checkpoints explicit. Discussion-validation is defined as a lightweight pre-promotion check inside the discussion phase, and implementation-validation is defined as a closeout check inside the implementation phase. This keeps the process lightweight while making it clearer that implementation validation alone cannot catch every directional error.
- Current conclusion: The verification model has been implemented in the repository documentation and agent guidance without adding a third lifecycle phase.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): DOD.md, README.md, templates/agent.md, .github/agents/dod.agent.md, .docs/ja/DOD.md, .docs/ja/README.md, .docs/ja/templates/agent.md, .docs/ja/.github/agents/dod.agent.md

### Entry 0003 (2026-04-22)
- Why now: Reduce the agent-guidance cognitive load by expressing the DOD workflow as an explicit step order inside each phase rather than mainly as scattered gate conditions.
- Findings / trade-offs: The same constraints can be preserved while making the agent instructions more sequence-oriented. Explicitly naming the preferred order inside the discussion phase and the implementation phase helps human operators and agent outputs stay aligned without adding a new phase or expanding the DOD specification again.
- Current conclusion: Agent guidance should present the same DOD constraints through phase-local step order: discussion -> discussion-validation -> decision promotion, then design -> test and implement -> validation.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): templates/agent.md, .github/agents/dod.agent.md, .docs/ja/templates/agent.md, .docs/ja/.github/agents/dod.agent.md