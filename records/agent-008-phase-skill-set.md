# Decision Record: agent-008-phase-skill-set

## Metadata
- Created At: 2026-05-21
- Scope: Define the default four-skill package for DOD phase execution and absorb default audit checks into validation skills

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

### Entry 0001 (2026-05-21)
- Why now: Clarify what concrete skills should ship under the main DOD agent after phase skills and verification checkpoints were approved, and decide whether a separate default audit skill is still warranted.
- Findings / trade-offs: Existing decisions already approve phase skills and separate discussion-validation and implementation-validation checkpoints, but the default skill package is still underspecified. Keeping a separate audit skill would duplicate work because most audit activity is either directional checking before promotion or artifact checking before closeout. Folding those checks into the two validation skills keeps the package smaller, matches the two-phase DOD model more closely, and still leaves room for a separate read-only audit agent later when independence or scale justifies it. The reusable default package should therefore be four explicit skills: discussion, discussion-validation, implementation, and implementation-validation, while the main agent keeps flow control, gate judgment, and promotion sequencing.
- Current conclusion: The default DOD skill package should use four phase-aligned skills. Default audit checks should be absorbed into the discussion-validation and implementation-validation skills instead of shipping a separate audit skill.
- Promotion to DECISIONS.yml: promoted -> agent-008-phase-skill-set, agent-008-1-discussion-skill, agent-008-2-discussion-validation-skill, agent-008-3-implementation-skill, agent-008-4-implementation-validation-skill, agent-006-2-phase-skills-default, agent-006-3-audit-skill-default
- Evidence / references (optional): DECISIONS.yml, records/agent-006-agent-orchestration-model.md, records/agent-007-phase-verification-model.md, templates/agent.md

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-05-21)
- Why now: Choose the repository source layout for the four new skill artifacts before writing their content.
- Findings / trade-offs: VS Code discovers installed skills from `.github/skills/<name>/SKILL.md`, but the repository still needs a source-of-truth layout that is easy to review, diff, and translate alongside the other DOD templates. Storing the source files under `templates/skills/` as one `.skill.md` file per shipped skill keeps the reusable content grouped together without pretending that these source files are already live workspace customizations. This also lets the content be authored first while installer wiring and output mapping can follow in a later change.
- Current conclusion: The four default DOD skill sources should live under `templates/skills/` as `.skill.md` files. These files are repository templates, and later installation or sync work should map them into the actual skill discovery layout.
- Promotion to DECISIONS.yml: promoted -> agent-004-6-skill-template-source-layout
- Evidence / references (optional): templates/, .github/skills/, records/agent-004-installer-template-details.md, records/agent-008-phase-skill-set.md

### Entry 0003 (2026-05-21)
- Why now: Refine the discussion-phase skill behavior after reviewing whether the initial template overfit implementation-style narrow exploration.
- Findings / trade-offs: The first discussion skill draft leaned too quickly toward local hypothesis formation, which fits implementation loops better than discussion. In DOD discussion work, narrowing too early increases omission risk because active constraints are often distributed across adjacent domains, existing decisions, nearby interfaces, and scope boundaries that are not visible from a single local anchor. The better default is a bounded broad scan first, followed by an explicit narrowing step that records chosen focus areas, intentional exclusions, and remaining uncertainty. Discussion-validation should then verify not only directional fit but also whether the broad scan was sufficient to justify the narrowed focus.
- Current conclusion: The discussion skill should begin with a bounded broad scan across the affected landscape before focusing. The discussion-validation skill should explicitly validate broad-scan coverage and the justification for the narrowed focus.
- Promotion to DECISIONS.yml: promoted -> agent-008-5-broad-then-focus-discussion
- Evidence / references (optional): DOD.md, templates/skills/discussion.skill.md, templates/skills/discussion-validation.skill.md