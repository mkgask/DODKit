# Decision Oriented Development

**Decision Oriented Development: DOD**

DOD is a lightweight development method that places decisions at the center of development. By repeating only two phases, the **discussion phase** and the **implementation phase**, teams can deliver software that stays aligned with real goals.

It keeps decision-making lightweight while preserving strong traceability for later review. This enables AI and humans to collaborate on fast and accurate development without losing rationale.

## Purpose, Background, and Why DOD

The purpose of DOD is to reduce cognitive load during development by keeping implementation aligned with explicit project decisions instead of informal memory, scattered chat, or partially outdated documents.

DOD is not merely a way to separate documents. It is a method for surfacing only the information required for future implementation decisions, and for building a canonical set of binding constraints that minimizes judgment cost for future implementers.

The background is a common failure in software projects: the current decisions, the history behind them, and the implementation details often get mixed together. When that happens, people must repeatedly dig through old context just to answer two basic questions: "What is decided now?" and "Why was it decided?"

DOD exists to solve that problem directly. It reduces cognitive load, makes active decisions easier to read, and gives AI-assisted workflows a clear source of truth so implementation is less likely to drift.

## Core Principle

The core distinction in DOD is not whether a piece of information feels important. The real distinction is whether that information constrains the next implementation decision.

`DECISIONS.yml` is the set of constraints needed to make the next implementation decision correctly without reading history.

`records/{decision-id}.md` stores the surrounding reasoning, research, trade-offs, alternatives, and discussion history that explain why the decision exists.

If leaving a fact only in `records/{decision-id}.md` would force the next implementer to reread history in order to implement correctly, that fact belongs in `DECISIONS.yml`.

## How DOD Works

DOD works through two connected ideas:
- Separate the current decision set from the historical reasoning behind it
- Move work through only two phases: discussion and implementation

In the discussion phase, the team investigates and finalizes the decision contract. In the implementation phase, the team writes tests and code that enforce those decisions. Because the current decisions stay explicit, both humans and AI can start from the same source of truth without rereading all historical discussion.

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

DOD is realized through the following two document types:

Use this classification rule before writing either file:
- If the information is needed for the next implementation decision, store it in `DECISIONS.yml`
- If the information explains why the decision was formed, store it in `records/{decision-id}.md`
- If information in a record later becomes a binding condition for implementation, promote it into `DECISIONS.yml` as a decision object or sub-decision

Examples:
- Scope boundaries, non-goals, invariants, acceptance criteria, and failure criteria belong in `DECISIONS.yml`
- Interfaces, target environments, selected technologies, paths, naming rules, compatibility requirements, and other implementation constraints belong in `DECISIONS.yml`
- Reasons, rejected alternatives, research notes, trade-offs, and discussion history belong in `records/{decision-id}.md`
- Open questions, investigation notes, and comparison notes can stay in `records/{decision-id}.md` until they become active constraints, then they must be promoted to `DECISIONS.yml`

Operational rule:
1. If this information were missing from `DECISIONS.yml`, could another implementer make the next change correctly without reading records?
2. If this information were missing, could tests, non-goals, constraints, or acceptance behavior be misinterpreted?
3. Is this information a current binding condition rather than an explanation of past discussion?

If the answer suggests that implementation could drift, the safe default is to store or promote the information in `DECISIONS.yml`.

**Decision List File (`DECISIONS.yml`)**: mutable, project decision register
- The canonical set of decision objects for this project
- The set of binding constraints required to make the next implementation decision correctly without rereading history
- All project decisions should be expressed here as decision objects or sub-decisions, with `status` showing whether they are active, on hold, cancelled, or otherwise
- When making a new decision, you can start immediately by checking only this file, without rereading all historical context first
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
- Keep each decision entry as concise as possible
- Concise means concise per entry, not a small number of entries
- Prefer many small decision objects over a few overloaded decision objects
- Every decision that matters to implementation should exist here as a decision object or sub-decision
- If a new binding rule emerges, add it here instead of burying it only in records
- Keep YAML readable in table-view tools

**Decision Record File (`records/{decision-id}.md`)**: immutable, decision history
- The background, investigation, trade-offs, and discussion process behind each decision
- Append-only updates are the default, so it remains a reliable history for answering, "Why was this decided at that time?"
- Free-form format (MADR-like or plain text)
- Append-only in principle, preserving historical facts
- Focus this file on history: background, research, trade-offs, alternatives, and why the active decisions were formed
- Do not use this file as the only place to store implementation constraints; decision objects belong in `DECISIONS.yml`
- Keep the decision contract in this file:
	- Invariants: what must always be preserved
	- Non-goals: what will not be done
	- Acceptance criteria: observable target values/behaviors
	- Failure criteria: explicitly define what is unacceptable

This separation makes it possible to get both **what the project decisions are** and **why they became that way** with minimal effort at the right time.
In traditional SDD or ADR-style workflows, those concerns are often mixed together, so people must filter old noise before making new decisions. DOD addresses this problem at the root.

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
