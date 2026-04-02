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
	1. Write the process in **`records/{decision-id}.md`** (immutable, append-only; newly discovered facts can be added as they appear)
	2. Update the decision and reason in **`DECISIONS.yml`** (mutable)
	3. Write tests for implementing the decision first (primarily e2e tests, plus unit tests where possible)
- Constraint: Do not write implementation code until test creation is complete
- Constraint: Do not over-investigate beyond what is needed

**Implementation Phase** (until tests pass)
- Actions: Implement and refactor code to satisfy tests; add more tests whenever needed
- Deliverable: Working code (all tests pass)
- Constraints: Respect `DECISIONS.yml` and existing test code; `records/{decision-id}.md` remains append-only

## Document Structure

**`DECISIONS.yml`** (mutable, currently valid list)
- Top-level category list
- Each category contains an array of decision objects
- Main object properties:
	- `id` (`{category}-{sequence}-{shortname}`, called the decision ID), `title`, `decision`, `reason` (up to around 3 lines), `status` (`Accepted`, `Superseded`, etc.), `updated_at`, `link`
- Decision objects can be nested up to 5 levels (3 levels recommended)
- YAML should stay readable in table-style viewers

**`records/{decision-id}.md`** (immutable, decision history)
- Free-form format (MADR-style or plain text)
- Append-only in principle, to preserve historical facts

## Version Control

**`main` branch**
- Keep it consistent with `DECISIONS.yml` at all times
- Merge only when code passes tests and the decision is finalized

**Feature branch per decision**
- Branch name: `{decision-id}`
- Keep work isolated in that branch until tests pass and the decision is finalized

## Verification

Verification is not a separate phase. Enforce it through hooks.
Validate from high-level checks down to low-level checks.

**`pre-commit` hook**: prioritize decision consistency and fix issues early
- Consistency checks for `DECISIONS.yml`
- Consistency checks between `DECISIONS.yml` and high-level specification tests

**`pre-push` hook**: final validation of tests and code quality
- High-level e2e specification tests and unit tests
- Type checks, lint, and coding-standard checks

## Notes

DOD is not ADR.
It is not SDD (Specification-Driven Development).
It is not IDD (Intent-Driven Development).

Those methods can still be referenced, but do not let them pull the process away from DOD's core principles.
