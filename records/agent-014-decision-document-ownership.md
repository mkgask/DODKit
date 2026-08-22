# Decision Record: agent-014-decision-document-ownership

## Metadata
- Created At: 2026-08-22
- Scope: Define ownership and non-duplication rules for DOD decisions across project and agent documents

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

### Entry 0001 (2026-08-22)
- Why now: An AI agent previously copied the same project decision into DECISIONS.yml and other documents such as PRINCIPLES.md and AGENTS.md. The existing DOD method already defines the decision list and discussion-record roles, but the discussion skill does not explicitly ask the agent to classify document ownership before writing.
- Findings / trade-offs: A bounded scan of DOD.md, DECISIONS.yml, AGENTS.md, README.md, templates/agent.md, the discussion and discussion-validation skills, the adjacent decision-promotion skill, the installer manifest and tests, the agent-013 record, and the English/Japanese mirrors found that DECISIONS.yml is already the canonical source for current project decisions and implementation constraints. DOD.md already explains this classification, so changing it would add method-level repetition rather than address the write-time failure. PRINCIPLES.md does not currently exist. AGENTS.md contains repository and agent operating rules and may remain independently authoritative for that role; a blanket prohibition on editing it would be too broad. The useful boundary is to prohibit copying the same project-specific decision text while allowing independently required operational or explanatory content. The installer already distributes the affected skill templates, so no manifest change is needed.
- Focus / exclusions: Focus on the discussion-time ownership check and the pre-promotion validation check in templates/skills. Keep DOD.md, AGENTS.md, README.md, PRINCIPLES.md creation, installer behavior, and new decision-file hierarchy behavior out of scope. The English source and its Japanese mirror are the affected documentation surfaces.
- Current conclusion: Add a concise document-ownership guardrail to templates/skills/discussion.skill.md and an equivalent Japanese mirror. Add a corresponding discussion-validation check that confirms project-specific binding constraints have one canonical DECISIONS.yml owner and that other document changes are independently justified, then mirror that change in Japanese. Keep the binding rule in DECISIONS.yml and rationale in this record; do not copy the decision text into AGENTS.md, PRINCIPLES.md, DOD.md, README.md, or skill files. This candidate direction is ready for discussion-validation.
- Promotion to DECISIONS.yml: none; candidate direction is ready for discussion-validation
- Evidence / references (optional): DOD.md; DECISIONS.yml; AGENTS.md; README.md; templates/agent.md; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; templates/skills/decision-promotion.skill.md; install.sh; tests/install.test.sh; records/agent-013-discussion-record-boundaries.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-08-22)
- Why now: Validate the candidate document-ownership direction against the original objective and the active DOD constraints before promoting it.
- Findings / trade-offs: The bounded scan covered the current decision list, DOD method, agent instructions, discussion-related skills, adjacent promotion guidance, installer/test scope, the existing record-boundary decision, and the English/Japanese mirrors. The candidate addresses the observed failure at the point where an agent writes discussion conclusions and adds a second lightweight check before promotion. It preserves the existing two-phase model, append-only records, decision scanability, scoped decision-file rules, and the distinction between project decisions and independently maintained agent or repository operating instructions. A blanket ban on updating AGENTS.md or skills would be incorrect because those files may need distinct operational changes; the binding project-specific decision text must be the part that is not duplicated.
- Current conclusion: Discussion-validation passed. Promote a new DOD Process decision family for document ownership with separate rules for the canonical DECISIONS.yml source, non-duplication of project-specific decision text while permitting independent operational or explanatory content, and ownership checks in discussion and discussion-validation. The implementation should update the English discussion and discussion-validation skill templates plus their Japanese mirrors. DOD.md, AGENTS.md, README.md, PRINCIPLES.md, the installer manifest, and the existing agent-013 record remain unchanged.
- Promotion to DECISIONS.yml: none; discussion-validation passed, promotion targets -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DOD.md; DECISIONS.yml; AGENTS.md; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; templates/skills/decision-promotion.skill.md; records/agent-013-discussion-record-boundaries.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md

### Entry 0003 (2026-08-22)
- Why now: Record the implementation outcome after promoting the document-ownership decision family.
- Findings / trade-offs: The discussion skill now classifies document ownership before a conclusion is written, and the discussion-validation skill checks for one canonical DECISIONS.yml owner and unjustified duplicate project-specific decision text. Both English skill templates have equivalent Japanese mirrors. DOD.md, AGENTS.md, README.md, PRINCIPLES.md, the installer manifest, and the prior agent-013 record were left unchanged. The edited files report no diagnostics, the installer function-level regression suite passed, and git diff --check passed.
- Current conclusion: The implementation matches the promoted decision contract. Project-specific binding constraints now have an explicit canonical-source and non-duplication guard, while independently required operational or explanatory document changes remain possible. The agent-014 decision family is ready for closeout with implementation-approved statuses.
- Promotion to DECISIONS.yml: promoted -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DECISIONS.yml; templates/skills/discussion.skill.md; templates/skills/discussion-validation.skill.md; .docs/ja/templates/skills/discussion.skill.md; .docs/ja/templates/skills/discussion-validation.skill.md; tests/install.test.sh; git diff --check

### Entry 0004 (2026-08-22)
- Why now: Final artifact validation found that the required Japanese mirror of the updated DECISIONS.yml had not yet received the new decision family.
- Findings / trade-offs: The Japanese DECISIONS.yml mirror was updated with the same agent-014 parent decision, three sub-decisions, approved statuses, and record link. Its diagnostics now pass. This keeps the repository's English-first and Japanese-mirror documentation rule intact without changing the installer or adding a separate principles document.
- Current conclusion: The English and Japanese decision lists, skill templates, and discussion records now express the same document-ownership contract. The previously recorded implementation conclusion remains valid after this synchronization correction.
- Promotion to DECISIONS.yml: already promoted -> agent-014-decision-document-ownership, agent-014-1-canonical-project-decision-source, agent-014-2-no-duplicate-project-decision-text, agent-014-3-document-ownership-validation
- Evidence / references (optional): DECISIONS.yml; .docs/ja/DECISIONS.yml; tests/install.test.sh
