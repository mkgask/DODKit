# Decision Record: agent-011-grok-install-target

## Metadata
- Created At: 2026-07-15
- Scope: Add Grok as an installer target with workspace-local assets under `.grok`

## Notes
- This file is append-only discussion history.
- Do not add mutable tracking fields here (status, remaining work, open action items).
- Do not keep open-question backlogs here. If clarification is needed, ask in chat and append the resolved facts.
- If a fact becomes a binding implementation constraint, promote it to DECISIONS.yml.
- Keep each entry as short as the discussion allows.
- Evidence and detailed promotion metadata are optional; omit them when the entry stays clear without them.

Append rules:
- Append at EOF only; do not edit earlier sections.
- Do not add status tracking or remaining-work items.

## Entry List

### Entry 0001 (2026-07-15T00:00:00Z)
- Why now: Add `grok` as an explicit installer target. The requested workspace convention is to place Grok-related DOD files under `.grok`, while Grok does not provide a known repository-local directory discovery contract.
- Findings / trade-offs: `install.sh` currently supports `copilot` and `cursor`, keeps target-specific source/destination mappings in per-target asset specifications, and installs shared workspace assets at `DECISIONS.yml` and `.dodkit/templates/discussion-record.md`. Copilot copies the agent and skills into `.github`; Cursor renders shared sources into `.cursor/rules/*.mdc`. The xAI documentation overview describes Grok Build and the Code API but does not define `.grok` as an automatic instruction directory. The user-provided operating assumption is therefore treated as a local convention, not as official Grok discovery behavior.
- Current conclusion: Candidate direction is to add `grok` to the explicit target set and directly copy the shared agent source to `.grok/dod.agent.md` plus the five shipped skill sources to `.grok/<skill-name>.skill.md`. Keep `DECISIONS.yml` and `.dodkit/templates/discussion-record.md` shared at their existing workspace paths, because they are project DOD artifacts rather than editor-specific instructions. Do not render Cursor frontmatter for Grok or claim that Grok automatically discovers `.grok`.
- Promotion to DECISIONS.yml: none
- Evidence / references (optional): `install.sh`; `tests/install.test.sh`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0002 (2026-07-15T00:10:00Z)
- Why now: Validate the candidate Grok direction against the requested behavior and the active installer/template constraints before making it binding.
- Findings / trade-offs: The direction satisfies the original objective because `install.sh grok` can select a dedicated target manifest whose target-specific destinations all begin with `.grok/`. It preserves workspace-only writes, idempotent staged installation, existing-file protection, the `source|destination|asset_name` manifest contract, shared template-source separation, and the protected canonical `DECISIONS.yml`. The trade-off is intentional: `.grok` is useful as a visible convention for user-directed reading, but the installer cannot guarantee automatic Grok discovery or instruction execution.
- Current conclusion: Discussion-validation passed. Invariants are: support exactly `copilot`, `cursor`, and `grok`; keep no-argument behavior as `copilot`; direct-copy Grok agent and skill sources into `.grok`; keep shared DOD artifacts at their existing paths; and avoid Cursor-specific rendering for Grok. Non-goals are native Grok integration, automatic discovery claims, new Grok-only source templates, and relocation of the canonical decision file. Acceptance requires parser/target validation, a fake-download Grok installation test covering all `.grok` outputs and shared assets, unchanged Copilot/Cursor behavior, and synchronized installation guidance. Failure includes writing Grok target-specific files outside `.grok`, overwriting the canonical project decision file, or silently accepting an unsupported target.
- Promotion to DECISIONS.yml: promoted -> agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-15-initial-grok-template-manifest, agent-004-11-grok-asset-destinations
- Evidence / references (optional): `DECISIONS.yml`; `install.sh`; `tests/install.test.sh`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0003 (2026-07-15T00:15:00Z)
- Why now: Record the completed decision promotion for the boundary around Grok instruction discovery.
- Findings / trade-offs: The discovery boundary is independently actionable because documentation and validation must prevent users from interpreting `.grok` as a native Grok configuration path. It does not require a separate installer mechanism: the existing explicit target manifest and direct-copy path are sufficient.
- Current conclusion: The active decision set now includes the `.grok` convention boundary as `agent-002-16-grok-discovery-boundary`; implementation may proceed with the documented limitation intact.
- Promotion to DECISIONS.yml: promoted -> agent-002-16-grok-discovery-boundary
- Evidence / references (optional): `DECISIONS.yml`; `README.md`; https://docs.x.ai/docs/overview

### Entry 0004 (2026-07-15T00:30:00Z)
- Why now: Implementation and implementation-validation completed for the promoted Grok installer target decisions.
- Findings / trade-offs: `install.sh` now accepts `grok`, selects `GROK_ASSET_SPECS`, directly installs the Grok agent and five skills under `.grok`, and installs the shared decision and discussion-record assets at their existing paths. The installer keeps the no-argument default as `copilot`, rejects unsupported targets with the complete supported-target list, and leaves Cursor rendering unchanged. README guidance is synchronized in English and Japanese and explicitly describes `.grok` as a user-directed convention.
- Current conclusion: The Grok target satisfies the original objective and the promoted invariants. Focused tests cover parsing, validation, manifest destinations, fake-download installation, shared assets, and existing Copilot/Cursor behavior.
- Promotion to DECISIONS.yml: implementation approved -> agent-002-2-installer-target-scope, agent-002-7-supported-target-names, agent-002-15-initial-grok-template-manifest, agent-002-16-grok-discovery-boundary, agent-004-11-grok-asset-destinations
- Evidence / references (optional): `install.sh`; `tests/install.test.sh`; `README.md`; `.docs/ja/README.md`; `bash tests/install.test.sh`; `bash install.sh --help`
