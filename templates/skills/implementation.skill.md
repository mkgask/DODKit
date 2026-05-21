---
name: implementation
description: 'Run the DOD implementation step. Use for phase-local design, narrow test selection, and short test-and-implement loops after discussion and decision promotion are complete.'
user-invocable: false
---

# Implementation

## Purpose
Use this skill for Gate B steps 1 and 2: design, then test and implement.
Its job is to turn the active decision set into the smallest useful change that can be validated quickly.

## Required Inputs
- Discussion ID
- Active decision IDs and statuses in `DECISIONS.yml`
- Requested implementation scope
- The owning code path, test, or failing behavior that anchors the work

## Procedure
1. Confirm Gate A is complete.
   Ensure the discussion record is updated, discussion-validation has passed, and the relevant decisions are already promoted in `DECISIONS.yml`.
2. Design against the active decisions.
   Translate the promoted decisions into one small implementation slice with a cheap falsifying check.
3. Prefer fail-first when practical.
   Choose the narrowest test or executable check that can prove the slice is wrong before widening scope.
4. Implement in short loops.
   Make the smallest reversible edit that exercises the current hypothesis.
5. Validate immediately after the first substantive edit.
   Run the focused behavior check, narrow test, or narrow compile/lint/typecheck before doing more reading or more patching.
6. Keep records current when new facts matter.
   If implementation reveals a new binding constraint or a materially decision-relevant fact, append it to `records/{discussion-id}.md` and promote the constraint to `DECISIONS.yml` in the same change set.
7. Stop before closeout.
   Hand the result to implementation-validation rather than declaring completion here.

## Guardrails
- Do not reopen broad exploration once a local implementation slice is chosen unless the current hypothesis is falsified.
- Do not widen the edit surface before rerunning the same focused validation.
- Do not let implementation drift beyond the promoted decision scope.
- Update adjacent docs or tests only when the active decisions make them part of the same slice.

## Completion Criteria
- The implementation slice is in place.
- At least one focused validation has been run for the changed slice.
- Any newly binding fact has been recorded and promoted.
- The work is ready for implementation-validation.