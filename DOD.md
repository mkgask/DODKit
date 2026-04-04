# Decision Oriented Development

**Decision Oriented Development: DOD**

DOD is a lightweight development method that places decisions at the center of development. By repeating only two phases, the **discussion phase** and the **implementation phase**, teams can deliver software that stays aligned with real goals.

It keeps decision-making lightweight while preserving strong traceability for later review. This enables AI and humans to collaborate on fast and accurate development without losing rationale.

DOD uses the following two document types:

**Decision List File (`DECISIONS.yml`)**: A list of currently valid decisions and their reasons.
This file is mutable. When making a new decision, you can **start immediately by checking only this file**. You do not need to reread historical context first. That sharply reduces cognitive load and works very well with AI-assisted workflows.

**Decision Record File (`records/{decision-id}.md`)**: The background, investigation, trade-offs, and discussion process behind each decision.
This file is immutable in principle. Once created, append-only updates are the default. It remains a reliable history for accurately answering, "Why was this decided at that time?"

This separation makes it possible to get both **what is currently valid** and **why it became valid** with minimal effort at the right time.
In traditional SDD or ADR-style workflows, those concerns are often mixed together, so people must filter old noise before making new decisions. DOD addresses this problem at the root.

## Development Flow (Only Two Phases)

**Discussion Phase** (until a decision is finalized)
- Actions: Investigate, research, ask questions, and discuss in order to finalize decisions (not only product specs, but also technology choices and constraints)
- Deliverables (always in this order):
	1. Write the process in **Decision Record File (`records/{decision-id}.md`)** (immutable, append-only; newly discovered facts can be added as they appear)
	2. Update **Decision List File (`DECISIONS.yml`)** with the active decision objects, and add new decision objects or sub-decisions when discussion produces additional independently active rules
- Constraint: Do not enter the implementation phase or start writing code until the decision contract (invariants, non-goals, acceptance criteria, and failure criteria) is finalized in the decision record file and the decision is recorded in `DECISIONS.yml`

**Implementation Phase** (until tests pass)
- Actions: Design, test implementation, and code implementation
- Deliverables:
	- Test code that enforces the decision
	- Working code (all tests pass)
- Constraints:
	- Do not deviate from the relevant decisions.
	- Fully respect `DECISIONS.yml`, existing test code, and existing implementation code
	- If new facts are discovered, append them to the decision record file

## Document Structure

**Decision List File (`DECISIONS.yml`)**: mutable, currently active list
- Category list at the top level
- Each category contains an array of decision objects
- Main properties of a decision object:
	- `id`: required. `{category}-{sequence}-{shortname}`. Referred to as the decision ID
	- `title`: required
	- `reason`: required. Up to around 3 lines is acceptable
	- `status`: optional. Use these as defaults: `⚠️Discussion In Progress`, `⚠️Discussion Approved`, `⚠️Implementing`, `✅️Implementation Approved`. Use others only when necessary, for example `⛔️On Hold` or `⛔️Cancelled`.
	- `updated_at`: optional
	- `link`: optional. Pointer to the related decision record file
- Decision objects can be nested up to 5 levels (3 levels recommended)
- Keep each decision entry as thin as possible
- Thin means concise per entry, not a small number of entries
- Prefer many small decision objects over a few overloaded decision objects
- If a new currently active rule emerges, add it as a new decision object or sub-decision instead of burying it only in records
- Keep YAML readable in table-view tools

**Decision Record File (`records/{decision-id}.md`)**: immutable, decision history
- Free-form format (MADR-like or plain text)
- Append-only in principle, preserving historical facts
- Focus this file on history: background, research, trade-offs, alternatives, and why the active decisions were formed
- Do not use this file as the only place to store currently active sub-decisions; current active rules belong in `DECISIONS.yml`
- Keep the decision contract in this file:
	- Invariants: what must always be preserved
	- Non-goals: what will not be done
	- Acceptance criteria: observable target values/behaviors
	- Failure criteria: explicitly define what is unacceptable

## Version Control

**`main` branch**
- Keep it consistent with `DECISIONS.yml` at all times
- Merge only when code passes tests and the decision is finalized

**Feature branch per decision**
- Branch name: `{decision-id}`
- Keep work isolated in that branch until tests pass and the decision is finalized

## Verification

Verification is not a separate phase. Enforce it through hooks.

**`pre-commit` hook**: validation for tests and code quality
- High-level e2e specification tests and unit tests
- Type checks, lint, and coding-standard checks

**`pre-push` hook**: early correction for decision consistency
- Consistency checks for `DECISIONS.yml`
- Consistency checks between `DECISIONS.yml` and high-level specification tests

## Notes

DOD is not ADR.
It is not SDD (Specification-Driven Development).
It is not IDD (Intent-Driven Development).

Those methods can still be referenced, but do not let them pull the process away from DOD's core principles.
