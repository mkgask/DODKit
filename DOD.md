# Decision Oriented Development

**Decision Oriented Development: DOD**

A lightweight continuous development method centered on the sustainable accumulation of decisions.

DOD places decisions at the center of continuous development. By repeating the **discussion phase** and the **implementation phase**, and by separately maintaining the current decision list, the implementation that follows those decisions, and the history behind them, teams can search for what the software should truly become while staying lightweight.

## Purpose, Background, and Why DOD

The purpose of DOD is to keep a lightweight decision list sustainable even across medium- and long-term development, and thereby keep the cognitive load for the next decision as low as possible.

The background is a common failure in software projects: the current decisions, the history behind them, and the implementation details often get mixed together. When that happens, people must repeatedly dig through old context just to answer two basic questions: "What is decided now?" and "Why was it decided?"

DOD solves this by separating active decisions from discussion history and by making the source of truth for implementation explicit.

## Core Principle

The core distinction in DOD is not whether a piece of information is important. The real distinction is whether that information constrains the next implementation decision.

DOD must keep discussion, decision, and implementation separate.
- Discussion is where investigation, research, questions, trade-offs, and evolving understanding accumulate.
- Decision is the binding definition produced from discussion.
- Implementation is the act of turning those decisions into tests and working code.

For this reason, DOD separates the following two artifacts.

**Decision List File**
The set of decision objects and binding constraints needed to make the next implementation decision correctly without reading history.

**Discussion Record File**
Stores the reasons, research, trade-offs, alternatives, and discussion history from which one or more decisions can emerge.

One discussion can produce zero, one, or many decision objects.

If leaving a fact only in the discussion record file would force the next decision to require rereading discussion history, that fact should be managed in the decision list file.

## How DOD Works

DOD works through three connected ideas:
- Separate discussion history from active decisions, and separate both from implementation work
- Allow one discussion to produce multiple decisions when the resulting constraints are independently active
- Move work through only two phases: discussion and implementation

In the discussion phase, the team investigates, records discussion history, and updates one or more decision objects. In the implementation phase, the team writes tests and code that enforce the active decisions. Because the current decisions stay explicit, both humans and AI can start from the same source of truth without rereading all historical discussion.

## Development Flow (Only Two Phases)

**Discussion Phase** (until the relevant decisions for the current discussion scope are explicit)
- Actions: Investigate, research, ask questions, and discuss in order to finalize decisions (not only product specs, but also technology choices and constraints)
- Deliverables (always in this order):
	1. Write the process in **Discussion Record File (`records/{discussion-id}.md`)** (immutable, append-only; newly discovered facts can be added as they appear)
	2. Update **Decision List File (`DECISIONS.yml`)** with the active decision objects, and add one or more new decision objects or sub-decisions when the discussion produces independently active rules
- Constraint: Do not enter the implementation phase or start writing code until the relevant decisions and their decision contracts are explicit in `DECISIONS.yml`; use the discussion record file for history and supporting context.

**Implementation Phase** (until tests pass)
- Actions: Design, test implementation, and code implementation
- Deliverables:
	- Test code that enforces the decision
	- Working code (all tests pass)
- Constraints:
	- Do not deviate from the relevant decisions.
	- Fully respect `DECISIONS.yml`, existing test code, and existing implementation code
	- If new facts are discovered, append them to the related discussion record file, and promote them to `DECISIONS.yml` if they become binding constraints

## Decision Contract

Decision contracts are part of the active decision set, so they must be explicit in `DECISIONS.yml`.

Discussion record files exist to preserve history and supporting context. They are not the canonical place for current implementation constraints.

If a decision contract is too large for one decision entry, split it into multiple decision objects or sub-decisions rather than leaving the contract only in `records/{discussion-id}.md`.

At minimum, the relevant decision objects in `DECISIONS.yml` must make the following constraints explicit:
- Invariants
- Non-goals
- Acceptance criteria
- Failure criteria

## Document Structure

DOD is realized through the following two document types:

Use this classification rule before writing either file:
- If the information is needed for the next implementation decision, store it in `DECISIONS.yml`
- If the information explains the discussion, research, or trade-offs from which decisions emerged, store it in `records/{discussion-id}.md`
- If information in a discussion record later becomes a binding condition for implementation, promote it into `DECISIONS.yml` as a decision object or sub-decision

Examples:
- Scope boundaries, non-goals, invariants, acceptance criteria, and failure criteria belong in `DECISIONS.yml`
- Interfaces, target environments, selected technologies, paths, naming rules, compatibility requirements, and other implementation constraints belong in `DECISIONS.yml`
- Reasons, rejected alternatives, research notes, trade-offs, and discussion history belong in `records/{discussion-id}.md`
- Open questions, investigation notes, and comparison notes can stay in `records/{discussion-id}.md` until they become active constraints, then they must be promoted to `DECISIONS.yml`

Operational rule:
1. If this information were missing from `DECISIONS.yml`, could another implementer make the next change correctly without reading records?
2. If this information were missing, could tests, non-goals, constraints, or acceptance behavior be misinterpreted?
3. Is this information a current binding condition rather than an explanation of past discussion?

If the answer suggests that implementation could drift, the safe default is to store or promote the information in `DECISIONS.yml`.

**Decision List File (`DECISIONS.yml`)**: mutable, project decision register
- The canonical set of decision objects for this project
- The set of binding constraints required to make the next implementation decision correctly without rereading history
- All project decisions should be expressed here as decision objects or sub-decisions, with `status` showing whether they are active, on hold, cancelled, or otherwise
- Multiple decision objects may point to the same discussion record when they emerged from one discussion or research thread
- When making a new decision, you can start immediately by checking only this file, without rereading all historical context first
- Decision contracts must be explicit here because implementation should not require rereading discussion history
- Category list at the top level
- Each category contains an array of decision objects
- Main properties of a decision object:
	- `id`: required. `{category}-{sequence}-{shortname}`. Referred to as the decision ID
	- `title`: required
	- `reason`: required. Up to around 3 lines is acceptable
	- `status`: optional. Use these as defaults: `⚠️Discussion In Progress`, `⚠️Discussion Approved`, `⚠️Implementing`, `✅️Implementation Approved`. Use others only when necessary, for example `⛔️On Hold` or `⛔️Cancelled`.
	- `updated_at`: optional
	- `link`: optional. Pointer to the related discussion record file
- Decision objects can be nested up to 5 levels (3 levels recommended)
- Keep each decision entry as concise as possible
- Concise means concise per entry, not a small number of entries
- Prefer many small decision objects over a few overloaded decision objects
- Every decision that matters to implementation should exist here as a decision object or sub-decision
- If a new binding rule emerges, add it here instead of burying it only in records
- Keep YAML readable in table-view tools

**Discussion Record File (`records/{discussion-id}.md`)**: immutable, discussion history
- The background, investigation, trade-offs, and discussion process behind one discussion or research thread
- Append-only updates are the default, so it remains a reliable history for answering, "What was discussed, discovered, and concluded at that time?"
- One discussion record can produce zero, one, or many decision objects in `DECISIONS.yml`
- Free-form format (MADR-like or plain text)
- Append-only in principle, preserving historical facts
- Focus this file on discussion history: background, research, trade-offs, alternatives, and why the active decisions were formed
- Do not use this file as the only place to store implementation constraints; decision objects belong in `DECISIONS.yml`
- Discussion records may describe how contracts were formed, but the current binding contracts must remain explicit in `DECISIONS.yml`

This separation makes it possible to get both **what the project decisions are** and **why they became that way** with minimal effort at the right time.

## Version Control

**`main` branch**
- Keep it consistent with `DECISIONS.yml` at all times
- Merge only when code passes tests and the relevant decisions are finalized

**Feature branch per implementation scope**
- Branch name should reflect the implementation scope; include the related discussion ID or primary decision ID when useful
- Keep work isolated in that branch until tests pass and the relevant decisions are finalized

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
