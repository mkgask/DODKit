# Decision Record: agent-001-dod-custom-agent

## Metadata
- Status: Accepted
- Date: 2026-04-03
- Scope: VS Code workspace-level Copilot customization

## Context and Research
We need a repeatable way to practice DOD as an execution workflow, not only as prose guidance.

Research findings:
- VS Code supports custom agents in `.agent.md` files and loads workspace agents from `.github/agents`.
- Custom agents can define dedicated instructions, tool restrictions, model preferences, and handoffs.
- Custom agents are better than one-off prompts when a persistent role with constrained capabilities is required.

Sources:
- https://code.visualstudio.com/docs/copilot/customization/custom-agents
- https://code.visualstudio.com/docs/copilot/customization/overview
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions

## Decision
Create a dedicated DOD custom agent as the primary runtime for DOD implementation tasks.

This agent will:
- enforce DOD phase behavior in instructions,
- expose only required tools for each workflow stage,
- provide predictable behavior across contributors.

## Decision Contract
### Invariants
- The DOD custom agent must be defined as a workspace file under `.github/agents`.
- The agent instructions must explicitly reference DOD phases and required artifacts.
- The agent must be reusable by multiple contributors without local manual edits.

### Non-goals
- Do not replace all existing agents or global user-level settings.
- Do not require proprietary external infrastructure to run the agent.
- Do not hardcode machine-specific paths.

### Acceptance Criteria
- A `.agent.md` definition exists and is detectable by VS Code in the workspace.
- The agent can be selected and used as a dedicated DOD workflow persona.
- The agent behavior text includes explicit guidance for decision records and DECISIONS updates.

### Failure Criteria
- The agent file is stored outside supported discovery locations.
- The agent cannot be selected in VS Code chat.
- The instructions omit DOD artifact requirements, causing decision drift.

## Consequences
Positive:
- Improves consistency and reduces prompt variance.
- Makes DOD workflow easier to execute for new contributors.

Trade-offs:
- Requires upfront maintenance of agent definition and related files.
- Tool restrictions must be tuned to avoid under-permission or over-permission.
