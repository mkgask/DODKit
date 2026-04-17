# Decision Oriented Development

**Decision Oriented Development: DOD**

A lightweight continuous development method for discovering and obtaining the true form of software that should truly exist.

DOD places decisions at the center of continuous development. By repeating the **discussion phase** and the **implementation phase**, and by separately maintaining the current decision list, the implementation that follows those decisions, and the history behind them, teams can search for what the software should truly become while keeping the active decision set lightweight and sustainable.

## Purpose, Background, and Why DOD

The purpose of DOD is to discover what the software should truly be, and to obtain that software through continuous development.

To make that sustainable across medium- and long-term development, DOD keeps the active decision list lightweight and sustainable, so the cognitive load for the next decision stays as low as possible.

The background is a common failure in software projects: the current decisions, the history behind them, and the implementation details often get mixed together. When that happens, people must repeatedly dig through old context just to answer two basic questions: "What is decided now?" and "Why was it decided?"

DOD solves this by separating active decisions from discussion history and by making the source of truth for implementation explicit.

Another part of the motivation is that the source of specification is rarely explicit at the start.
It often exists as tacit understanding distributed across people, constraints, context, and prior discussion.
DOD is a way to turn that tacit source into explicit decisions and reasons, so implementation can proceed from a shared and inspectable basis.

## Core Principle

The core distinction in DOD is not whether a piece of information is important. The real distinction is whether that information constrains the next implementation decision.

DOD must keep discussion, decision, and implementation separate.
- Discussion is where investigation, research, questions, trade-offs, and evolving understanding accumulate.
- Decision is the binding definition produced from discussion. In DOD, "decision" is not limited to resolved disputes — specifications, design constraints, interface contracts, technology selections, project constitution, philosophy, governing principles, behavioral invariants, and non-goals are all decisions and must be managed in `DECISIONS.yml`.
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
- Repeat investigation, research, questions, and discussion until the active constraints for the current scope are explicit.
- Always write the discussion history to `records/{discussion-id}.md` first, then promote the resulting active decisions to `DECISIONS.yml`.
- Do not enter implementation until the relevant decisions and decision contracts are explicit in `DECISIONS.yml`.

**Implementation Phase** (until tests pass)
- Design, test, and implement against the active decisions.
- Do not deviate from the relevant decisions.
- If new facts are discovered, append them to the related discussion record file, and promote them to `DECISIONS.yml` if they become binding constraints.

## Decision Contract

Decision contracts are part of the active decision set, so they must be explicit in `DECISIONS.yml`.
They must be explicit to the degree necessary to keep implementation from drifting, while keeping `DECISIONS.yml` lightweight and easy to scan.

Discussion record files exist to preserve history and supporting context. They are not the canonical place for current implementation constraints.

If contract details need their own active rule, split them into multiple decision objects or sub-decisions rather than leaving the contract only in `records/{discussion-id}.md`.

At minimum, the relevant decision set in `DECISIONS.yml` must make the following kinds of constraints explicit when they materially constrain implementation:
- Invariants
- Non-goals
- Acceptance criteria
- Failure criteria

These constraints do not need to appear as four dedicated fields on every decision object. Express them in the smallest set of decision objects or sub-decisions needed to keep the next implementation decision correct.

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
- This is the canonical set of active decision objects and binding constraints for the project.
- A new implementer should be able to start here without rereading broad history.
- Keep entries concise, but do not omit any active rule that can change implementation.
- Prefer many small decisions or sub-decisions over a few overloaded entries.
- Top-level categories should usually express a concern area or domain such as `Feature`, `Infrastructure`, `Business Logic`, `Security`, `Data`, or `CI/CD`.
- Do not default to splitting the top level by lifecycle axes such as specification, design, implementation, or test. When those axes independently constrain work, express them as decisions or sub-decisions inside the relevant concern category.
- The core fields are `id`, `title`, and `reason`. `status` and `link` are optional but recommended when they help keep the active set understandable.
- A parent decision can point to the shared discussion record for one discussion or research thread, and sub-decisions can inherit that `link` unless they need a different record.
- Decision objects can be nested up to 5 levels, though 3 levels is usually enough.

**Discussion Record File (`records/{discussion-id}.md`)**: immutable, discussion history only
- **This file is discussion history only — it is not a specification document, design document, or operational playbook**
- It stores the background, investigation, trade-offs, alternatives, and discussion process behind one discussion or research thread.
- It is append-only: new observations can be appended as they emerge, but existing entries are not rewritten to track progress.
- It may include implementation-discovered facts when those facts are part of the history of how the decision evolved.
- **Do not write mutable tracking fields here: status indicators, remaining-work checklists, open action items, or any content expected to be updated after the fact.** That content belongs in `DECISIONS.yml` or in implementation artifacts.
- Do not use this file as the only place to store active implementation constraints. If a fact becomes binding, promote it to `DECISIONS.yml` immediately.

This separation makes it possible to get both **what the project decisions are** and **why they became that way** with minimal effort at the right time.

## Decision Enforcement

DOD does not work if decisions remain only as remembered intent.
They must be enforced in implementation.

- Tests and working code enforce the behavioral side of active decisions.
- Automated checks such as hooks can enforce consistency between `DECISIONS.yml`, tests, and implementation.
- The exact enforcement mechanism is project-specific, but some enforcement mechanism is required; otherwise decisions remain advisory and implementation drift becomes likely.

## Testing

The exact testing approach may differ by project.
The recommended default is fail-first TDD.

## Notes

DOD is not ADR.
It is not SDD (Specification-Driven Development).
It is not IDD (Intent-Driven Development).

Those methods can still be referenced, but do not let them pull the process away from DOD's core principles.
