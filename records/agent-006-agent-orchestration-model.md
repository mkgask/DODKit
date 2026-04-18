# Decision Record: agent-006-agent-orchestration-model

## Metadata
- Created At: 2026-04-18
- Scope: Orchestration model for the DOD custom agent, phase skills, and artifact audit behavior

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

### Entry 0001 (2026-04-18)
- Why now: Decide whether DOD phase execution should stay in one primary agent or be split into multiple peer agents.
- Findings / trade-offs: DOD already fixes the official flow order through Gate A, Gate B, and Gate C, so phase transitions need one accountable controller. A symmetric multi-agent design would increase handoff overhead and make it easier for responsibility for artifact order, status updates, and final gate judgment to drift. The phase procedures themselves are still separable, so discussion handling, implementation handling, and artifact audit can be modularized as reusable skills without fragmenting overall accountability. A dedicated audit agent remains valuable only when audit independence or parallel workload outweighs the added orchestration cost.
- Current conclusion: Keep one main DOD agent as the single controller for flow and gate judgment. Execute discussion-phase work, implementation-phase work, and artifact audit through specialized skills by default. Introduce a separate read-only audit agent only when independence or scale justifies it.
- Promotion to DECISIONS.yml: promoted -> agent-006-agent-orchestration-model, agent-006-1-main-agent-governance, agent-006-2-phase-skills-default, agent-006-3-audit-skill-default, agent-006-4-audit-agent-exception
- Evidence / references (optional): DOD.md, templates/agent.md, DECISIONS.yml