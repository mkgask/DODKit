# Decision Record: agent-005-lightweight-template-roles

## Metadata
- Created At: 2026-04-16
- Scope: Lightweight role separation for DECISIONS.yml and discussion-record templates

## Notes
- This file is append-only discussion history.
- Do not add mutable tracking fields here (status, remaining work, open action items).
- Do not keep open-question backlogs here. If clarification is needed, ask in chat and append the resolved facts.
- If a fact becomes a binding implementation constraint, promote it to DECISIONS.yml.

Append rules:
- Append at EOF only; do not edit earlier sections.
- Do not add status tracking or remaining-work items.

## Entry List

### Entry 0001 (2026-04-16)
- Trigger: Assess whether AI friction around the two discussion-phase artifacts should be solved by adding a separate decision phase or by clarifying template roles.
- Context and Research: DOD already treats the discussion phase as incomplete until decisions are explicit, so a separate decision phase would add process weight without adding distinct work. The current friction comes mainly from the discussion-record template feeling verbose and from uncertainty about how much contract detail belongs in DECISIONS.yml versus records.
- Discussion: Keep DOD as a two-phase method and reduce artifact friction through template guidance instead of phase expansion. Preserve DECISIONS.yml scanability for humans by keeping the default decision shape light. When contract details need to become independently active constraints, express them as additional sub-decisions rather than mandatory fields on every decision node. Make discussion-record.md lighter by reducing required fields and treating evidence or detailed promotion metadata as optional.
- Outcome at this time: A new template-guidance decision family is needed to keep DOD lightweight while preserving explicit decision promotion.
- Decision impact: New active rules are needed for phase preservation, DECISIONS.yml scanability, contract expression as-needed, and lightweight discussion-record structure.
- DECISIONS.yml promotion: promoted
- Promotion target IDs (if promoted): agent-005-lightweight-template-roles, agent-005-1-two-phase-dod, agent-005-2-decisions-template-scanability, agent-005-3-contract-details-as-needed, agent-005-4-discussion-record-minimal-structure, agent-005-5-optional-record-detail
- Evidence / references: DOD.md, templates/DECISIONS.yml, templates/discussion-record.md, .github/agents/dod.agent.md

## Implementation Update (2026-04-16)
- Updated templates/DECISIONS.yml so the default decision shape stays minimal and contract details are represented as additional sub-decisions only when independently active.
- Updated templates/discussion-record.md and the installed workspace template at .dodkit/templates/discussion-record.md to reduce required entry fields and make evidence/promotion detail optional.
- Synced templates/agent.md with the current DOD agent guidance so installed agents preserve the fixed discussion-to-decision artifact order.
- Residual risk: repositories that already copied older templates keep their previous structure until the template asset is copied again or the installer is rerun.

## Specification Sync Update (2026-04-16)
- Aligned DOD.md with this decision family so decision contracts are described as explicit but still minimal and human-scannable.
- Clarified that invariants, non-goals, acceptance criteria, and failure criteria must be explicit in the relevant decision set when they materially constrain implementation, but they do not need to appear as four dedicated fields on every decision object.