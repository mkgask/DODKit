# DOD: Decision-Oriented Development

DOD is a lightweight development method that places decisions at the center of development, and by simply repeating the **discussion phase** and **implementation phase**, it obtains truly purposeful software.

It makes decisions quick and easy, yet manages them in a way that allows for reliable later review, enabling AI and humans to work together to drive fast and accurate development.

In DOD, the following two types of documentation are used:

- **Variable File (DECISIONS.yml)**: Manages a list of currently valid decisions and their reasons.

-> When creating a new decision, you can **start immediately by looking only at this**, without having to reread past history. Cognitive load is dramatically reduced, and it is highly compatible with AI.

- **Immutable File (records/{decision ID}.md)**: Records the background, research, trade-offs, and discussion process that led to the decision.

-> Once written, basically only appends are made. It remains as a history that allows for accurate later review of "why this decision was made at the time."

This separation allows you to obtain **only what is effective now and why it was done, at the time and at the minimum cost**.
Traditional SDD and ADR mix these together, requiring you to sift through past noise to find reference material for new decisions, but DOD fundamentally solves this problem.

## Development Flow (Only 2 Phases)

**Discussion Phase** (Until a decision is finalized)
- Actions: Research, study, questions, and discussions for the decision (including not only specifications but also technology selection and constraints)
- Deliverables (must be output in this order):
1. Record the process in **records/{Decision ID}.md** (immutable, only additions are OK / new facts discovered during research, etc. can be recorded)
2. Update the decisions and reasons in **DECISIONS.yml** (variable)
3. Create test code to implement the decision first (mainly end-to-end tests, write unit tests where possible)
- Constraint: Do not write code until the test code creation is complete
- Constraint: Do not delve deeper than necessary

**Implementation Phase** (Until tests pass)
- Actions: Implement code to pass the test code (including refactoring), add test code as needed
- Deliverables: Working code (all tests pass)
- Constraints: DECISIONS.md and existing test code must be fully respected; records/{decision ID}.md can only be appended to.
## Document Structure

**DECISIONS.yml** (Variable, currently active list)
- Category list at the top level
- Array of decision objects within each category
- Main properties of the object:
- `id` ({category}-{sequence number}-{shortname}, called the decision ID), `title`, `decision`, `reason` (up to about 3 lines allowed), `status` (Accepted / Superseded, etc.), `updated_at`, `link`
- YAML displayed in table view for human readability

**records/{decision ID}.md** (Immature, history record)
- Free-form text format (MADR style or plain text is acceptable)
- Basically, only appends are allowed. To be preserved as a historical fact

## Version Control

**Main Branch**
- Always maintain consistency with DECISIONS.yml
- Merge only when the code passes tests and the decision is finalized

**Individual Working Branch**
- Branch name is `{Decision ID}`
- Work only within this branch until the code passes tests and the decision is finalized
