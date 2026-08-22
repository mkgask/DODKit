# Decision Record: agent-015-overwrite-default-all

## Metadata
- Created At: 2026-08-22
- Scope: Interactive installer overwrite default

## Notes
- This file is append-only discussion history.
- Do not add mutable tracking fields here (status, remaining work, open action items).
- Do not keep open-question backlogs here. If clarification is needed, ask in chat and append the resolved facts.
- If a fact becomes a binding implementation constraint, promote it to DECISIONS.yml.
- Keep each entry as short as the discussion allows.
- Evidence and detailed promotion metadata are optional; omit them when the entry stays clear without them.

Record boundary guidance:
- Keep one record focused on one cohesive decision theme. If an independent question, component, or follow-up appears, start a new record with a new discussion-id instead of extending unrelated history. Mention the prior record in Evidence / references when the new discussion continues from it.
- Use a practical reviewability signal: when a record reaches roughly 10 entries or 1,000 words, close at a natural boundary and continue in a new record with a new discussion-id. This is a heuristic, not a hard parser-enforced limit; stay in the current record only when the next same-theme entry remains concise and reviewable.

Append rules:
- Append at EOF only; do not edit earlier sections.
- Do not add status tracking or remaining-work items.

## Entry List

### Entry 0001 (2026-08-22)
- Why now: The installer prompt currently presents `a` as the all-remaining-files choice, but an empty response accepts only the current file. The requested behavior is for the default empty response to mean all remaining files and for the prompt to show `Overwrite this file? [y/n/A] (A = all remaining files):`.
- Findings / trade-offs: `confirm_overwrite` already changes the session policy to `yes` for `a|A`; its fallback accepts only the current file. Reusing that transition for an empty response keeps the change local and preserves the existing `should_overwrite` flow. The protected `DECISIONS.yml` check runs before confirmation, and explicit `--overwrite yes|no` policies do not call the prompt. The current decision `agent-002-8-existing-file-overwrite-policy` and the English/Japanese README and tests still describe the old Enter behavior.
- Current conclusion: Candidate direction is to treat an empty response, `A`, and `a` as the all-remaining-files choice: accept the current file and set `OVERWRITE_POLICY=yes` for subsequent changed managed files in the current install. `y` and other existing affirmative responses continue to accept only the current file, while `n` preserves only the current file. There is still no all-no shortcut, and non-interactive `ask` behavior remains automatic update.
- Promotion to DECISIONS.yml: none
- Evidence / references: `install.sh` (`confirm_overwrite` and `install_staged_asset`), `tests/install.test.sh` interactive confirmation checks, `DECISIONS.yml` `agent-002-8-existing-file-overwrite-policy`, `README.md`, and `.docs/ja/README.md`.

## Append Template (Copy and Append at EOF)

### Entry {next-sequence} ({timestamp})
- Why now:
- Findings / trade-offs:
- Current conclusion:
- Promotion to DECISIONS.yml:
- Evidence / references (optional):

### Entry 0002 (2026-08-22)
- Why now: Validate the candidate default against the reinstall objective and the active installer constraints before promotion.
- Findings / trade-offs: Making an empty response select all remaining files reduces repeated prompts for the common update-all case while preserving an explicit per-file opt-out through `n`. The transition remains session-scoped because it only changes `OVERWRITE_POLICY` during the current install. Explicit `--overwrite yes|no`, non-interactive fallback, idempotent unchanged-file handling, symlink protection, workspace scope, and the pre-confirmation `DECISIONS.yml` protection are unaffected.
- Current conclusion: The candidate fits the objective and active constraints. The focused acceptance check is a pseudo-terminal run with an empty response that asserts the exact `[y/n/A]` prompt, `policy=yes`, and no second prompt for a subsequent changed file.
- Promotion to DECISIONS.yml: promoted -> agent-002-8-existing-file-overwrite-policy
- Evidence / references: `tests/install.test.sh` should cover the empty-response transition and retain coverage for explicit `n`, `a`, explicit policies, non-interactive execution, protected decision data, and idempotence.

### Entry 0003 (2026-08-22)
- Why now: Record the implementation outcome after applying the promoted overwrite-default decision.
- Findings / trade-offs: `confirm_overwrite` now displays the `[y/n/A]` prompt in both terminal output paths and treats an empty response as the existing all-remaining transition. The focused tests verify that the empty response updates the current and subsequent files without another prompt, while explicit `n`, lowercase `a`, explicit policies, non-interactive execution, protected decision data, idempotence, symlink protection, and target manifests remain covered. README documentation is synchronized in English and Japanese.
- Current conclusion: Implementation and related artifacts match the promoted decision. The installer keeps the protected-file check before confirmation, so the new default does not authorize overwriting `DECISIONS.yml`.
- Promotion to DECISIONS.yml: none
- Evidence / references: `bash tests/install.test.sh` passed after the implementation and documentation updates.
