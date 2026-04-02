# Decision Record: agent-003-raw-github-install

## Metadata
- Status: Accepted
- Date: 2026-04-03
- Scope: Remote installer delivery endpoint

## Context and Research
The required installation UX is `installer.sh | bash` using GitHub raw hosting.
A correct host choice and stable URL strategy are required to avoid breakage.

Research findings:
- GitHub raw file hosting works on `raw.githubusercontent.com`.
- DNS lookup confirms `raw.githubusercontent.com` resolves in this environment, while `raw.gitusercontent.com` does not resolve.
- GitHub documentation recommends permalinks (commit-based references) for immutable linking when stability is required.

Sources:
- https://raw.githubusercontent.com/github/docs/main/README.md
- https://docs.github.com/en/repositories/working-with-files/using-files/getting-permanent-links-to-files
- Local verification: `getent hosts raw.githubusercontent.com` and `getent hosts raw.gitusercontent.com`

## Decision
Use `raw.githubusercontent.com` as the installer endpoint host and provide a `curl | bash` installation command.

Recommended command pattern:
- `curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/<ref>/installer.sh | bash`

Where `<ref>` defaults to a stable branch or tag, and can be pinned to a commit for reproducibility.

## Decision Contract
### Invariants
- Installer endpoint host must be `raw.githubusercontent.com`.
- Command must fail on HTTP/network errors (`-f`) and remain quiet but diagnosable (`-sS`).
- URL structure must map directly to the repository path of `installer.sh`.

### Non-goals
- Do not use `raw.gitusercontent.com`.
- Do not rely on shortened URLs with opaque redirects.
- Do not claim cryptographic verification if not implemented.

### Acceptance Criteria
- Published one-line command downloads and executes installer successfully from a clean shell.
- Endpoint URL is copy-pasteable and documented with owner/repo/ref placeholders.
- Documentation explains how to pin `<ref>` for deterministic installs.

### Failure Criteria
- URL host does not resolve or returns non-raw HTML pages.
- Installer command succeeds inconsistently due to branch drift without documented pinning guidance.
- Installation instructions point to an invalid or typo domain.

## Consequences
Positive:
- Meets requested installation UX.
- Works with common shell tooling and CI bootstrapping.

Trade-offs:
- `curl | bash` has supply-chain risk; mitigations should be documented (pinning, code review, checksum/signature in future).
