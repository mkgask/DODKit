# Decision Record: agent-010-decision-single-field

## Metadata
- Created At: 2026-06-28
- Scope: Replace the DECISIONS.yml title/reason split with a single decision field

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

### Entry 0001 (2026-06-28)
- Why now: The current title/reason split is causing AI-authored updates to drift. The title is often reduced to a short headline while reason is used as narrative detail instead of the current binding constraint, which weakens semantic linkage and scanability.
- Findings / trade-offs: Related records, especially agent-005-lightweight-template-roles, already prioritize lightweight scanability and explicit active constraints. Keeping a split label-and-reason shape has become an operational source of mismatch in AI-assisted editing. A single decision field keeps the naming and binding content in one place and reduces accidental divergence. The trade-off is reduced structural separation, but this is offset by guidance that decision may use up to about 3 lines when needed.
- Current conclusion: Use decision as the only required descriptive field in DECISIONS.yml entries, remove title and reason from the active schema, and apply the same schema to DECISIONS.example.yml and templates/DECISIONS.yml.
- Promotion to DECISIONS.yml: promoted -> agent-010-decision-single-field, agent-010-1-decision-single-field-length
- Evidence / references (optional): records/agent-005-lightweight-template-roles.md, DECISIONS.yml, DECISIONS.example.yml, templates/DECISIONS.yml

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-06-28)
- Why now: Close the implementation phase for the promoted schema change and record implementation outcomes.
- Findings / trade-offs: DECISIONS.yml was migrated to the decision-only descriptive schema and the new decision family was added under Template with Implementation Approved status. DECISIONS.example.yml and templates/DECISIONS.yml were updated to remove title/reason usage and to document the decision field as concise with up to about three lines when needed. Japanese mirror artifacts were updated to stay synchronized.
- Current conclusion: The repository now uses decision as the single descriptive field for active and template decision objects, and the promoted rule is fully applied in canonical and example artifacts.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): DECISIONS.yml, DECISIONS.example.yml, templates/DECISIONS.yml, .docs/ja/DECISIONS.yml, .docs/ja/DECISIONS.example.yml, .docs/ja/templates/DECISIONS.yml
