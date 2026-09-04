# OHA DATABASE ARCHITECTURE

## ONAR Hermes Agent — Two-Supabase Architecture

This document defines the database architecture for ONAR-HERMES-AGENT.

The system uses **two separate Supabase projects** with a strict ownership boundary:

1. **`smartct-OHA`** — Smart CT Registry / CT Intelligence Layer
2. **`web3track-OHA`** — OHA Operational Database / Hermes Operational Memory

These systems must remain separate. Hermes acts as the orchestration layer between them.

---

## 1. Executive Decision

### `smartct-OHA`

Purpose:

> Store, identify, enrich, score, and track Crypto Twitter / community intelligence.

`smartct-OHA` is the authoritative system for CT identity and CT intelligence.

It owns:

- CT identity
- CT profiles
- CT aliases
- CT accounts
- CT discovery
- CT activity
- CT signals
- CT signal history
- CT ↔ project relationships
- CT reliability/history
- CT scoring history
- CT behavioral patterns
- CT signal outcomes

### `web3track-OHA`

Purpose:

> Store the operational state, research observations, tasks, campaigns, monitoring targets, scoring records, and execution history used by Hermes.

It owns:

- projects
- programs
- campaigns
- tasks
- deadlines
- sources
- observations
- alpha inputs
- scores
- wallet requirements
- monitoring targets
- execution logs
- operational state
- Hermes work history

---

# 2. Core Architecture

```text
                         ┌──────────────────────────┐
                         │          ONAR            │
                         │      Human Operator      │
                         └────────────┬─────────────┘
                                      │
                                      │ direct intake
                                      ▼
                         ┌──────────────────────────┐
                         │         HERMES           │
                         │   Orchestrator / Agent   │
                         └────────────┬─────────────┘
                                      │
                     ┌────────────────┴────────────────┐
                     │                                 │
                     ▼                                 ▼
        ┌─────────────────────────┐       ┌─────────────────────────┐
        │       smartct-OHA       │       │      web3track-OHA      │
        │                         │       │                         │
        │ Smart CT Registry       │       │ OHA Operational DB      │
        │                         │       │                         │
        │ CT identity             │       │ Projects                │
        │ CT profiles             │       │ Campaigns               │
        │ CT accounts             │       │ Tasks                   │
        │ CT signals              │       │ Observations            │
        │ CT activity             │       │ Alpha inputs            │
        │ CT relationships        │       │ Scores                  │
        │ CT history              │       │ Monitoring              │
        │ CT reliability          │       │ Execution logs           │
        └─────────────────────────┘       └─────────────────────────┘
```

The databases are intentionally independent.

Hermes is responsible for translating intelligence from one system into operational work in the other.

---

# 3. Data Ownership Boundary

## smartct-OHA owns CT intelligence

If the question is:

> "Who is this CT?"

Query `smartct-OHA`.

If the question is:

> "What has this CT historically posted or signaled?"

Query `smartct-OHA`.

If the question is:

> "How reliable has this CT been?"

Query `smartct-OHA`.

If the question is:

> "What projects has this CT historically been associated with?"

Query `smartct-OHA`.

---

## web3track-OHA owns operational intelligence

If the question is:

> "What project is Hermes currently monitoring?"

Query `web3track-OHA`.

If the question is:

> "What campaign is active?"

Query `web3track-OHA`.

If the question is:

> "What task is pending?"

Query `web3track-OHA`.

If the question is:

> "What did Hermes do yesterday?"

Query `web3track-OHA`.

If the question is:

> "What observations, scores, monitoring targets, and execution history exist for this operational workflow?"

Query `web3track-OHA`.

---

# 4. Critical Rule

Do **not** duplicate complete CT records into `web3track-OHA`.

The authoritative CT identity remains inside `smartct-OHA`.

`web3track-OHA` may store:

```text
ct_registry_id
```

and, when necessary for historical integrity:

```text
ct_snapshot_reference
```

The snapshot is contextual history, not a replacement for the CT Registry.

---

# 5. Cross-System Identity

Both systems should use stable identifiers.

Recommended conceptual relationship:

```text
smartct-OHA
    ct_profiles.id
          │
          │ stable reference
          ▼
web3track-OHA
    observations.ct_registry_id
    alpha_inputs.ct_registry_id
    scores.ct_registry_id
    execution_logs.ct_registry_id
```

Avoid direct cross-database foreign keys.

The relationship should be resolved through application/API logic.

---

# 6. CT Intelligence Flow

A CT publishes a signal:

```text
CT posts signal
      │
      ▼
smartct-OHA
      │
      ├── identify CT
      ├── resolve account
      ├── record signal
      ├── attach source
      ├── update activity
      └── update historical intelligence
      │
      ▼
Hermes
      │
      ├── retrieve CT intelligence
      ├── interpret signal
      ├── verify source
      └── create operational observation
      │
      ▼
web3track-OHA
      │
      ├── observation
      ├── source
      ├── score
      ├── campaign/task
      └── monitoring target
      │
      ▼
Hermes execution
      │
      └── execution_logs
      │
      ▼
Outcome
      │
      └── feedback to smartct-OHA when relevant
```

---

# 7. Direct ONAR Intake

ONAR input has a special rule.

Everything directly entered by ONAR is considered:

```text
VALIDATED
```

The scoring system does not reject ONAR intake.

Instead:

```text
ONAR intake
    │
    ▼
VALIDATED
    │
    ▼
web3track-OHA
    │
    └── scoring happens afterward
```

A low score does not mean the information is discarded.

Low-scoring information remains useful as historical context.

Therefore:

```text
validated ≠ high score
```

and:

```text
low score ≠ invalid
```

Hermes must preserve the full history.

---

# 8. Recommended smartct-OHA Schema

The exact implementation may evolve, but the CT Registry should conceptually contain the following tables.

## `ct_profiles`

Canonical CT identity.

Suggested fields:

```text
id
display_name
handle
bio
avatar_url
primary_platform
status
created_at
updated_at
```

---

## `ct_aliases`

Historical or alternative identities.

Suggested fields:

```text
id
ct_profile_id
alias
platform
first_seen_at
last_seen_at
created_at
```

---

## `ct_accounts`

Platform-specific accounts.

Suggested fields:

```text
id
ct_profile_id
platform
platform_user_id
handle
profile_url
status
created_at
updated_at
```

---

## `ct_signals`

Individual CT signals.

Suggested fields:

```text
id
ct_profile_id
ct_account_id
signal_type
content
signal_url
published_at
discovered_at
confidence
created_at
```

---

## `ct_signal_sources`

Provenance for signals.

Suggested fields:

```text
id
ct_signal_id
source_type
source_url
source_reference
captured_at
metadata
```

---

## `ct_project_relationships`

CT ↔ project intelligence.

Suggested fields:

```text
id
ct_profile_id
project_reference
relationship_type
confidence
first_seen_at
last_seen_at
metadata
created_at
updated_at
```

---

## `ct_activity`

Aggregated CT activity.

Suggested fields:

```text
id
ct_profile_id
activity_type
activity_at
metadata
created_at
```

---

## `ct_scores`

Historical CT scoring.

Suggested fields:

```text
id
ct_profile_id
score_type
score
reasoning
scored_at
created_at
```

Scores are historical records.

Do not overwrite the entire history with a single mutable value.

---

## `ct_signal_outcomes`

What happened after a CT signal.

Suggested fields:

```text
id
ct_signal_id
outcome_type
outcome_value
observed_at
notes
created_at
```

This allows `smartct-OHA` to learn from previous CT signals.

---

# 9. smartct-OHA Responsibilities

`smartct-OHA` should be able to answer:

- Who is this CT?
- Which accounts belong to this CT?
- What aliases has this CT used?
- What signals has this CT produced?
- What projects has this CT discussed?
- What historical relationships exist?
- How reliable has this CT been?
- What was the outcome of previous signals?
- What behavioral patterns have appeared?
- What is the CT's historical score trajectory?

It should not become the task manager for Hermes.

---

# 10. Recommended web3track-OHA Schema

## `projects`

Operational project registry.

Suggested fields:

```text
id
name
slug
description
status
category
website_url
created_at
updated_at
```

---

## `programs`

Higher-level programs or initiatives.

Suggested fields:

```text
id
project_id
name
description
status
start_at
end_at
created_at
updated_at
```

---

## `campaigns`

Operational campaigns.

Suggested fields:

```text
id
project_id
program_id
name
description
status
priority
start_at
end_at
created_at
updated_at
```

---

## `tasks`

Concrete work items for Hermes.

Suggested fields:

```text
id
project_id
campaign_id
title
description
status
priority
assigned_to
due_at
completed_at
created_at
updated_at
```

Recommended statuses:

```text
pending
in_progress
blocked
completed
cancelled
```

---

## `deadlines`

Important time-bound events.

Suggested fields:

```text
id
project_id
campaign_id
task_id
title
deadline_at
source_id
status
created_at
updated_at
```

---

# 11. Sources

## `sources`

Every meaningful external observation should preserve provenance.

Suggested fields:

```text
id
source_type
url
title
publisher
published_at
retrieved_at
content_hash
metadata
created_at
```

Possible `source_type` values:

```text
official
twitter
github
discord
docs
blog
announcement
onchain
community
other
```

Source provenance is mandatory for reliable research.

---

# 12. Observations

## `observations`

An observation represents what Hermes found.

Suggested fields:

```text
id
project_id
campaign_id
source_id
ct_registry_id
observation_type
content
observed_at
confidence
status
created_at
```

Important distinction:

```text
source = where information came from

observation = what Hermes learned from it
```

For CT-originated observations:

```text
ct_registry_id
```

should reference the canonical CT identity in `smartct-OHA`.

---

# 13. Alpha Inputs

## `alpha_inputs`

Alpha inputs are actionable intelligence that may influence future decisions.

Suggested fields:

```text
id
project_id
campaign_id
observation_id
ct_registry_id
title
content
importance
confidence
status
created_at
updated_at
```

Possible importance:

```text
low
medium
high
critical
```

The alpha input should preserve the observation that produced it.

---

# 14. Scores

## `scores`

Scoring is an evaluation layer, not a validation gate for direct ONAR intake.

Suggested fields:

```text
id
project_id
campaign_id
observation_id
alpha_input_id
ct_registry_id
score_type
score
reasoning
scored_at
created_at
```

Recommended behavior:

```text
Input
  ↓
Validation
  ↓
Observation
  ↓
Scoring
  ↓
Decision / prioritization
```

For ONAR intake:

```text
ONAR
  ↓
VALIDATED
  ↓
Observation
  ↓
Score
```

The score does not invalidate the original intake.

---

# 15. Wallet Requirements

## `wallet_requirements`

Track operational wallet requirements.

Suggested fields:

```text
id
project_id
campaign_id
task_id
chain
asset
amount
wallet_type
requirement_type
status
deadline_at
notes
created_at
updated_at
```

Possible requirement types:

```text
hold
fund
bridge
stake
claim
swap
deposit
transaction
other
```

---

# 16. Monitoring Targets

## `monitoring_targets`

Persistent things Hermes needs to monitor.

Suggested fields:

```text
id
project_id
campaign_id
target_type
target_identifier
source_url
check_frequency
last_checked_at
last_changed_at
status
metadata
created_at
updated_at
```

Examples:

```text
project announcement
GitHub repository
Twitter account
contract
token
governance proposal
campaign page
documentation
deadline
```

---

# 17. Execution Logs

## `execution_logs`

This is the official Hermes operational journal.

It should record meaningful actions taken by Hermes.

Suggested fields:

```text
id
project_id
campaign_id
task_id
observation_id
ct_registry_id
action_type
action_summary
input_reference
result
status
executed_at
metadata
created_at
```

Examples:

```text
research
verification
source_check
score
task_created
task_updated
monitoring_check
announcement_detected
campaign_updated
wallet_requirement_detected
telegram_action
github_action
database_action
error
recovery
```

Example record:

```text
action_type:
source_check

action_summary:
Verified campaign deadline against official project documentation.

result:
Deadline confirmed.

status:
completed
```

This table is the historical memory of Hermes' operational behavior.

---

# 18. Operational State

Hermes should be able to reconstruct current state from operational records.

Conceptually:

```text
Historical records
       │
       ▼
Current operational state
       │
       ├── project state
       ├── campaign state
       ├── task state
       ├── monitoring state
       └── latest verified information
```

Do not rely exclusively on a mutable "current state" field without retaining history.

History matters.

---

# 19. Change Detection

Monitoring should detect changes rather than repeatedly storing identical observations.

For example:

```text
Previous:
deadline = 2026-09-20

New:
deadline = 2026-09-25
```

Hermes should record:

```text
change detected
```

and preserve both states.

A content hash can help detect duplicate sources:

```text
content_hash
```

Recommended deduplication principle:

```text
same source
+
same content hash
+
same observation context
=
do not create duplicate observation
```

---

# 20. CT → Operational Intelligence

A CT signal should not automatically become a task.

Recommended pipeline:

```text
CT signal
   ↓
smartct-OHA
   ↓
Hermes interpretation
   ↓
source verification
   ↓
observation
   ↓
score
   ↓
decision
   ├── archive
   ├── monitor
   ├── create task
   ├── update campaign
   └── escalate
```

This keeps intelligence separate from action.

---

# 21. Operational → CT Feedback

When an operational event reveals something useful about a CT, Hermes can feed the result back into `smartct-OHA`.

Example:

```text
CT recommends project
        ↓
Hermes verifies
        ↓
Project becomes successful
        ↓
Outcome recorded
        ↓
CT signal outcome updated
```

This creates a feedback loop:

```text
CT intelligence
      ↓
Hermes
      ↓
Operational execution
      ↓
Outcome
      ↓
CT intelligence improvement
```

---

# 22. Research Memory

Before beginning meaningful work, Hermes should search existing operational memory.

Recommended sequence:

```text
New task
   ↓
Search web3track-OHA
   ↓
Search smartct-OHA when CT context exists
   ↓
Retrieve previous observations
   ↓
Retrieve previous execution logs
   ↓
Retrieve previous sources
   ↓
Determine what is already known
   ↓
Perform new research only where necessary
```

This prevents Hermes from rediscovering the same information repeatedly.

---

# 23. Memory Queries

## smartct-OHA queries

Examples:

```text
Find CT by handle
Find CT by alias
Find previous signals
Find historical project relationships
Find previous outcomes
Find reliability history
Find score history
Find activity around a project
```

## web3track-OHA queries

Examples:

```text
Find previous research about project
Find current campaign state
Find completed tasks
Find recent observations
Find previous source checks
Find previous scores
Find monitoring history
Find recent execution logs
Find unresolved tasks
```

---

# 24. API Boundary

The two Supabase projects should communicate through application-level clients.

Conceptually:

```python
SmartCTRegistryClient
```

Responsibilities:

```text
get_ct()
get_ct_by_handle()
get_ct_signals()
get_ct_history()
get_ct_relationships()
get_ct_scores()
record_signal_outcome()
```

And:

```python
OHAClient
```

Responsibilities:

```text
get_project()
get_campaign()
create_observation()
create_alpha_input()
create_score()
create_task()
update_task()
create_monitoring_target()
create_execution_log()
get_recent_history()
```

Hermes owns orchestration:

```python
Hermes
 ├── SmartCTRegistryClient
 └── OHAClient
```

---

# 25. No Tight Database Coupling

Do not create direct foreign keys across the two Supabase projects.

Avoid architecture such as:

```text
web3track-OHA
    FK → smartct-OHA.database
```

Prefer:

```text
Hermes
   │
   ├── API → smartct-OHA
   │
   └── API → web3track-OHA
```

Benefits:

- independent migrations
- independent backups
- simpler failure handling
- cleaner ownership
- easier scaling
- safer access control
- easier replacement of either system

---

# 26. Authentication and Security

Each Supabase project should have its own authentication and access policy.

Never expose:

```text
service_role
secret keys
database passwords
private credentials
```

to the frontend, public repository, or untrusted runtime.

Use environment variables.

Example:

```text
SMARTCT_OHA_URL
SMARTCT_OHA_ANON_KEY
SMARTCT_OHA_SERVICE_ROLE_KEY

WEB3TRACK_OHA_URL
WEB3TRACK_OHA_ANON_KEY
WEB3TRACK_OHA_SERVICE_ROLE_KEY
```

Service-role credentials must remain server-side.

---

# 27. Row Level Security

All exposed application tables should use appropriate Row Level Security policies.

The exact policies depend on how Hermes and any human dashboard authenticate.

Do not assume:

```text
authenticated
```

automatically means authorized.

Authorization must be explicitly defined.

Sensitive operational tables should not be publicly readable.

---

# 28. Indexing

At minimum, consider indexes for:

### smartct-OHA

```text
ct_profiles.handle
ct_accounts.platform_user_id
ct_signals.ct_profile_id
ct_signals.published_at
ct_project_relationships.project_reference
ct_scores.ct_profile_id
ct_signal_outcomes.ct_signal_id
```

### web3track-OHA

```text
projects.slug
campaigns.project_id
tasks.project_id
tasks.status
tasks.due_at
observations.project_id
observations.ct_registry_id
observations.observed_at
sources.url
sources.content_hash
scores.project_id
scores.ct_registry_id
monitoring_targets.project_id
monitoring_targets.last_checked_at
execution_logs.project_id
execution_logs.executed_at
```

Indexes should be validated against actual query patterns.

---

# 29. Timestamps

Use consistent timestamps.

Recommended:

```text
created_at
updated_at
published_at
observed_at
retrieved_at
executed_at
```

Store timestamps in UTC.

Convert to local time only at the presentation layer.

---

# 30. Historical Integrity

Never destroy meaningful operational history merely because the current state changed.

Example:

```text
Campaign deadline:
2026-09-20
```

Later:

```text
Campaign deadline:
2026-09-25
```

The system should preserve the fact that the original deadline was 2026-09-20.

This matters for:

- auditability
- research
- debugging
- scoring
- behavioral analysis
- postmortems
- future model improvement

---

# 31. Execution Journal Principle

The Hermes journal is not simply a list of messages.

It is a record of operational state transitions and meaningful actions.

Use:

```text
observations
```

for what Hermes discovered.

Use:

```text
scores
```

for how Hermes evaluated it.

Use:

```text
tasks
```

for what Hermes needs to do.

Use:

```text
execution_logs
```

for what Hermes actually did.

Use:

```text
sources
```

for where the information came from.

Use:

```text
projects / campaigns
```

for current operational state.

This separation keeps the database intelligible.

---

# 32. Optional Human Interfaces

The database is the source of truth.

Human interfaces are views into the database.

Possible interfaces:

```text
Telegram
Web dashboard
Admin panel
Google Sheets export
Notion research notes
CLI
```

Google Sheets should not become the authoritative journal.

Notion should not become the authoritative operational database.

Local SQLite can be used as cache/offline fallback, but not as the primary source of truth.

---

# 33. Optional Google Sheets Export

If ONAR wants a spreadsheet view, Hermes may export selected operational data.

Example:

```text
web3track-OHA
      ↓
export
      ↓
Google Sheets
```

Possible exported sheets:

```text
Projects
Campaigns
Tasks
Monitoring
Recent Observations
Recent Execution Logs
```

The spreadsheet is a presentation/export layer.

It should not be treated as the authoritative database.

---

# 34. Failure Handling

If `smartct-OHA` is temporarily unavailable:

```text
Hermes
   ↓
detect failure
   ↓
record operational error
   ↓
retry according to policy
   ↓
continue non-dependent work where safe
```

If `web3track-OHA` is unavailable:

```text
Hermes
   ↓
detect failure
   ↓
avoid claiming successful persistence
   ↓
retry
   ↓
preserve pending action locally if required
```

Hermes must distinguish:

```text
action attempted
```

from:

```text
action persisted successfully
```

---

# 35. Repository Integration

The repository should contain architecture documentation that explains:

```text
smartct-OHA
web3track-OHA
Hermes
API boundaries
database ownership
security model
operational flows
```

Recommended documentation layout:

```text
docs/
├── architecture.md
├── OHA-DATABASE.md
├── deployment/
│   ├── local-android.md
│   └── vps.md
└── operations/
    ├── safe-mode.md
    ├── telegram.md
    └── continuity.md
```

The database architecture document should remain synchronized with the actual implementation.

---

# 36. Supabase Implementation Principles

When implementing either Supabase project:

1. Verify current Supabase documentation before making changes.
2. Create schema changes through Supabase migrations.
3. Inspect available CLI commands before assuming syntax.
4. Enable RLS on exposed tables.
5. Define explicit authorization policies.
6. Keep service-role credentials server-side.
7. Validate indexes against actual queries.
8. Test inserts, reads, updates, and deletes according to intended permissions.
9. Run security and performance checks after implementation.
10. Keep migration history committed to Git.

Do not invent migration filenames or CLI syntax without checking the installed CLI documentation.

---

# 37. End-to-End Test

The system should eventually pass this test:

```text
1. ONAR provides a CT/project signal.
2. Hermes accepts the intake as VALIDATED.
3. Hermes stores operational context in web3track-OHA.
4. Hermes resolves CT identity through smartct-OHA.
5. Hermes retrieves CT history when relevant.
6. Hermes verifies the source.
7. Hermes creates an observation.
8. Hermes creates a score.
9. Hermes decides whether monitoring/task creation is necessary.
10. Hermes creates or updates the operational record.
11. Hermes records the action in execution_logs.
12. A future Hermes run can retrieve that history.
```

---

# 38. Security Test

Verify that:

```text
Public clients cannot access sensitive operational records.
Unauthorized users cannot modify tasks.
Service-role credentials are never exposed.
RLS policies behave as intended.
Cross-system identifiers do not grant unauthorized access.
Hermes can access only the operations it actually needs.
```

---

# 39. Definition of Done

The database architecture is considered operationally ready when:

```text
[ ] smartct-OHA exists as the Smart CT Registry
[ ] web3track-OHA exists as the OHA Operational Database
[ ] Ownership boundaries are documented
[ ] Stable CT identifiers are established
[ ] Cross-database direct FKs are avoided
[ ] Hermes can read from smartct-OHA
[ ] Hermes can write/read web3track-OHA
[ ] ONAR intake is treated as VALIDATED
[ ] Scoring does not invalidate ONAR intake
[ ] Sources preserve provenance
[ ] Observations preserve research findings
[ ] Scores preserve evaluation history
[ ] Tasks preserve operational work
[ ] Monitoring targets preserve persistent watches
[ ] execution_logs preserve Hermes actions
[ ] Historical state remains queryable
[ ] RLS is configured
[ ] Secrets remain server-side
[ ] Indexes cover important query paths
[ ] Failure states are handled
[ ] End-to-end flow is tested
[ ] Security behavior is tested
[ ] Documentation is committed to Git
```

---

# 40. Final Architecture

The final system is:

```text
                    ONAR
                     │
                     ▼
                  HERMES
             Orchestrator Layer
               /            \
              /              \
             ▼                ▼
     ┌───────────────┐   ┌────────────────┐
     │  smartct-OHA  │   │ web3track-OHA  │
     │               │   │                │
     │ CT Intelligence│  │ Operations     │
     │ Registry      │   │ Database       │
     └───────────────┘   └────────────────┘
             │                │
             │                │
             ▼                ▼
       CT intelligence     Operational
       + history           state + history
             │                │
             └───────┬────────┘
                     ▼
                  HERMES
                     │
                     ▼
              Execution / Actions
```

The architectural rule is simple:

> **`smartct-OHA` knows the CT. `web3track-OHA` knows the operation. Hermes connects the two.**

The database is the source of truth.

The journal is `execution_logs`.

The intelligence layer is `smartct-OHA`.

The operational memory is `web3track-OHA`.

ONAR intake is always preserved as validated input, while scoring determines priority and downstream action.
