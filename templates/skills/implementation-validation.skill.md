---
name: implementation-validation
description: 'Validate DOD implementation results before closeout. Use for checking tests, code, docs, templates, and related artifacts against the active decisions, while absorbing the default post-implementation audit.'
user-invocable: false
---

# Implementation Validation

## Purpose
Use this skill for Gate B step 3 and Gate C closeout checks.
Its job is to confirm that the implemented result and its surrounding artifacts actually match the promoted decisions.

## Required Inputs
- Discussion ID
- Active decisions and statuses in `DECISIONS.yml`
- The changed code, tests, docs, templates, and related artifacts
- Results from the narrow validation checks run during implementation

## Procedure
1. Start with deterministic checks.
   Prefer the narrowest behavior test, targeted test file, compile, lint, or typecheck that can falsify the changed slice.
2. Run the default post-implementation audit here.
   Audit consistency between active decisions and the changed artifacts instead of using a separate default audit skill.
3. Check artifact alignment.
   Confirm that tests, code, templates, agent guidance, and user-facing terminology stay aligned with the active decisions for the changed scope.
4. Check decision hygiene.
   Confirm that `DECISIONS.yml` status is current and that any materially new implementation fact has been appended to `records/{discussion-id}.md` and promoted when binding.
5. Repair locally when validation exposes a same-slice defect.
   Fix the defect and rerun the same focused validation before expanding scope.
6. Close only when the decision contract is satisfied.
   Report what was validated, what changed, and any remaining risk that did not rise to a new active constraint.

## Guardrails
- Do not substitute `git diff` for a narrower executable validation when one exists.
- Do not widen scope to avoid fixing a local validation failure.
- Do not leave terminology drift between decisions and changed artifacts.
- Do not close the work while statuses or records are stale.

## Completion Criteria
- Focused validation passes for the changed scope, or the remaining blocker is explicit.
- The changed artifacts match the promoted decisions.
- Default audit checks are covered by this validation step.
- Closeout information is ready for the main agent to report.