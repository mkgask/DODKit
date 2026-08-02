# Decision Record: agent-013-discussion-record-boundaries

## Metadata
- Created At: 2026-08-02
- Scope: Define file-level boundaries and splitting guidance for DOD discussion records

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

### Entry 0001 (2026-08-02)
- Why now: A repository using DODKit accumulated very few discussion records, leaving one record much longer than is practical to review. The current template and discussion skill require concise entries but do not define when a discussion should move to a new file or discussion ID.
- Findings / trade-offs: A bounded scan of the discussion-record template, discussion skill, agent guidance, decision-promotion skill, installer manifests and tests, the `.dodkit` shared copy, and Japanese mirrors found no explicit file-level splitting rule. Existing decision/sub-decision splitting concerns DECISIONS.yml structure, not discussion-record boundaries. The existing lightweight-template decisions require minimal record structure and optional evidence, so new guidance must not add a mandatory planning form or a third DOD phase. The installer already distributes the affected template and skill sources, so no manifest change is needed. A purely qualitative instruction may be too easy to overlook; a hard line limit would be brittle. The candidate is a qualitative boundary backed by a practical signal: keep one record to one cohesive decision theme, and when the same-theme record reaches roughly 10 entries or 1,000 words, close it at a natural boundary and continue in a new record with a new discussion ID and a reference to the prior record.
- Current conclusion: Add file-level boundary guidance to `templates/discussion-record.md` and `templates/skills/discussion.skill.md`, then synchronize the installed shared copy and Japanese mirrors. The guidance should distinguish same-theme continuation from an independent decision thread, make the size signal explicit without treating it as a hard failure, and preserve append-only history. Discussion-validation must confirm that this improves reviewability without conflicting with the lightweight record and two-phase DOD constraints before promotion.
- Promotion to DECISIONS.yml: none; candidate direction is ready for discussion-validation
- Evidence / references (optional): `templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `templates/agent.md`; `templates/skills/decision-promotion.skill.md`; `install.sh`; `tests/install.test.sh`; `.dodkit/templates/discussion-record.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `DECISIONS.yml`; `records/agent-005-lightweight-template-roles.md`

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-08-02)
- Why now: Validate the candidate record-boundary guidance against the original request and the active lightweight DOD constraints before promotion.
- Findings / trade-offs: The bounded scan covered the source template and discussion skill, their installed and Japanese mirrors, the main agent and adjacent promotion guidance, installer mappings, and focused manifest tests. The candidate directly addresses the missing file-level boundary. It keeps same-theme history append-only, starts a new discussion ID only for a genuinely independent thread or when the practical size signal is reached, and can point the new record back to the prior record. The approximate size signal is guidance rather than a parser-enforced limit, so it does not add a brittle failure mode. It also does not add mandatory record fields, a new lifecycle phase, or installer assets.
- Current conclusion: Discussion-validation passed. Promote `agent-013-discussion-record-boundaries` with separate contract details for the theme boundary, practical size signal, lightweight non-goals, and synchronized template/skill acceptance coverage. The implementation can then update the source template, discussion skill, `.dodkit` copy, and Japanese mirrors without changing the installer manifest.
- Promotion to DECISIONS.yml: none; discussion-validation passed, promotion targets -> agent-013-discussion-record-boundaries and its contract sub-decisions
- Evidence / references (optional): `DECISIONS.yml`; `records/agent-005-lightweight-template-roles.md`; `templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `.dodkit/templates/discussion-record.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `install.sh`; `tests/install.test.sh`

### Entry 0003 (2026-08-02)
- Why now: Record the implementation outcome after applying the promoted boundary guidance.
- Findings / trade-offs: `templates/discussion-record.md` and `.dodkit/templates/discussion-record.md` are identical. The English discussion skill and Japanese template/skill mirrors contain the independent-theme trigger, new discussion ID instruction, practical size signal, append-only boundary, and lightweight non-goals. The existing installer regression suite passed without a manifest change. A YAML parser check still reports a pre-existing unquoted colon in the existing installer overwrite-policy decision at `DECISIONS.yml` line 112; the same error exists in `HEAD`, so it was left outside this focused documentation change.
- Current conclusion: The implementation matches the promoted decision contract and is ready for closeout. New discussions now have explicit guidance to split before a record becomes difficult to review, while the heuristic remains flexible for short same-theme continuation.
- Promotion to DECISIONS.yml: promoted -> agent-013-discussion-record-boundaries and agent-013-1-one-theme-per-record, agent-013-2-practical-record-size-signal, agent-013-3-lightweight-boundary-nongoals, agent-013-4-template-skill-sync-acceptance
- Evidence / references (optional): `templates/discussion-record.md`; `.dodkit/templates/discussion-record.md`; `templates/skills/discussion.skill.md`; `.docs/ja/templates/discussion-record.md`; `.docs/ja/templates/skills/discussion.skill.md`; `tests/install.test.sh` (`[PASS] install.sh function-level tests passed`); `DECISIONS.yml` baseline parse check
