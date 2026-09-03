# Continuity Workflow

The intended maintenance loop is:

```text
Telegram
  → Hermes
  → project task
  → inspect current repository
  → modify files
  → security check
  → commit
  → push
  → report result
```

Each step should leave an auditable result without publishing private runtime state.

## State separation

- **Operational state:** process status, task history, and private logs. Useful for running the system; not repository content.
- **Configuration:** reviewed, non-secret settings and safe templates.
- **Secrets:** credentials and tokens injected at runtime; never repository content.
- **Source/documentation:** public files that explain behavior and procedures.
- **Deployment-specific state:** device/VPS paths, sessions, local databases, service registrations, and other environment artifacts.

## Maintenance loop

1. Receive a scoped task through Telegram or another trusted channel.
2. Inspect the current branch, files, and existing documentation before editing.
3. Preserve useful material and make the smallest coherent change.
4. Run relevant checks and distinguish observed results from plans.
5. Review staged files and the staged diff for secrets.
6. Commit with a clear message, preferably using a conventional type such as `docs:` or `fix:`.
7. Push only to the intended remote and branch.
8. Verify the remote result, then report files changed, checks performed, commit identity, and push status without sensitive values.

A continuity failure should be recoverable from Git plus privately held configuration—not from undocumented memory of one device.
