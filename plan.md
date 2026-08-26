# jBallerina Test Migration Orchestrator Implementation Plan

## Summary

Implement a clean TypeScript orchestrator under `tools/jballerina-test-migration/`
from the contract in `MIGRATION.md`. Do not reuse the old migration-tool
implementation.

The tool will:

- consume a strict JSONL candidate manifest;
- isolate each candidate attempt in a dedicated Git worktree;
- launch fresh Codex migration, review, and fix roles;
- control and audit the model and reasoning effort used by every role;
- require role-owned Git checkpoints before advancing;
- validate generated `-v`, `-e`, and `-p` cases with the pinned local `bal`;
- merge accepted candidates into a serialized aggregation branch;
- persist state, logs, validation evidence, incidents, and archival refs; and
- expose Start, Pause, progress, evidence, and recovery state through a
  localhost dashboard.

The first end-to-end validation will use an eight-candidate pilot manifest.
The later full migration manifest must be accepted without code changes.
Promotion into the Nutcracker repository remains out of scope.

## API and Type Changes

### Command-line interface

There is currently no migration-orchestrator command. Add the executable entry
point `tools/jballerina-test-migration/migrate` with these commands:

```text
migrate dashboard --manifest <path> [--agent-config <path>] [--port <port>]
migrate doctor
migrate toolchain adopt
migrate inspect <candidate-id> --attempt <number>
migrate validate --candidate-dir <path> --bal <absolute-path>
```

Behavior:

- `dashboard` binds to `127.0.0.1`, defaults to port `4173`, opens the browser,
  reconciles state while paused, and requires an explicit Start action.
- `doctor` performs the same read-only repository, worktree, state, toolchain,
  and agent-configuration checks used at startup. It never repairs state.
- `toolchain adopt` records a changed installed `bal` and requeues passed
  candidates for validation as specified by `MIGRATION.md`.
- `inspect` materializes a temporary diagnostic worktree from an archival ref
  and removes it when inspection ends.
- `validate` is the deterministic validator invoked by migration/fix agents and
  independently by the orchestrator. It emits a machine-readable validation
  receipt to stdout and exits nonzero on any failed case.

### Candidate inventory

Implement the existing public inventory contract exactly:

```ts
/** One minimal jBallerina migration candidate from a UTF-8 JSONL manifest. */
export interface CandidateInventoryRecord {
  schemaVersion: 1;
  javaSource: string;
  javaSupportSources?: string[];
  ballerinaSources: string[];
}
```

Reject blank-field variants, comments, unknown fields, absolute paths, `..`
traversal, symlink escapes, untracked inputs, duplicate canonical paths,
duplicate Java harnesses, and empty `ballerinaSources` arrays. Canonicalize
records and arrays before hashing. Derive the ID from the Java class slug and
the first ten hexadecimal SHA-256 characters of the normalized `javaSource`.

### Agent execution configuration

Add a checked-in
`tools/jballerina-test-migration/agent-config.json` and allow `dashboard` to
select another file through `--agent-config`. There are no live dashboard
controls for these values.

```ts
/** Reasoning efforts accepted by the Codex CLI configuration contract. */
export type ReasoningEffort =
  | "minimal"
  | "low"
  | "medium"
  | "high"
  | "xhigh";

/** Immutable model configuration for one orchestrated Codex role run. */
export interface AgentRoleConfig {
  model: string;
  reasoningEffort: ReasoningEffort;
}

/** Versioned configuration for every Codex role used by the orchestrator. */
export interface AgentExecutionConfig {
  schemaVersion: 1;
  roles: {
    migration: AgentRoleConfig;
    review: AgentRoleConfig;
    fix: AgentRoleConfig;
  };
}
```

Use this initial balanced profile:

```json
{
  "schemaVersion": 1,
  "roles": {
    "migration": {
      "model": "gpt-5.6-terra",
      "reasoningEffort": "high"
    },
    "review": {
      "model": "gpt-5.6-sol",
      "reasoningEffort": "high"
    },
    "fix": {
      "model": "gpt-5.6-terra",
      "reasoningEffort": "high"
    }
  }
}
```

Parse and validate the complete file before enabling Start. Reject unknown
fields, missing roles, empty model names, and unsupported reasoning efforts.
Canonicalize and hash the configuration. Load it only at process startup; a
file edit while the server is running has no effect until restart.

On restart, reconcile a changed configuration while paused, persist the new
hash, and append an event. Apply it only to newly launched roles. Existing role
records and passed candidates retain their original configuration.

Launch each role with explicit overrides so user defaults cannot silently
select another model or reasoning effort:

```sh
codex exec \
  --model <role-model> \
  -c 'model_reasoning_effort="<role-effort>"' \
  --json \
  --output-schema <role-outcome-schema> \
  --output-last-message <role-result-path> \
  --cd <candidate-owned-directory> \
  -
```

Resolve and record the Codex executable path and version for every role. Treat
a Codex CLI error that rejects the configured model or effort as the
campaign-level fault `agent_configuration_invalid`; it must not consume a
candidate infrastructure retry.

References:

- <https://learn.chatgpt.com/docs/developer-commands?surface=cli>
- <https://learn.chatgpt.com/docs/config-file/config-reference>
- <https://developers.openai.com/api/docs/guides/latest-model>

### Persisted state extensions

Retain the campaign, candidate, attempt, and role schemas in `MIGRATION.md` and
add the agent-configuration fields below:

```ts
export interface CampaignAgentConfiguration {
  path: string;
  hash: string;
  roles: AgentExecutionConfig["roles"];
}

export interface CampaignState {
  // Existing MIGRATION.md fields remain unchanged.
  agentConfig: CampaignAgentConfiguration;
}

export interface RoleRunState {
  // Existing MIGRATION.md fields remain unchanged.
  model: string;
  reasoningEffort: ReasoningEffort;
  agentConfigHash: string;
  codexPath: string;
  codexVersion: string;
  command: string[];
}
```

The persisted command is an argument array, not a shell-form string. Redact any
environment value that could contain credentials. Store the rendered prompt,
JSON event stream, final structured result, session ID, model, effort, and
configuration hash together in the role evidence directory.

### Structured role outcomes

Use `codex exec --output-schema` instead of interpreting free-form final text:

```ts
export type RoleOutcome =
  | {
      status: "committed";
      summary: string;
    }
  | {
      status: "blocked";
      code: string;
      summary: string;
      evidence: string[];
    };
```

A `committed` result is advisory until the orchestrator verifies the exact
commit count, parent, message, diff allowlist, output hash, validator receipt,
and clean worktree. A terminal `blocked` result requires no role commit because
no subsequent role will consume it; archive the attempt with its complete
evidence.

### Dashboard HTTP interface

Use Node's built-in HTTP server and expose same-origin endpoints:

```text
GET  /api/snapshot
GET  /api/events
GET  /api/candidates/:id
GET  /api/evidence/*
POST /api/control/start
POST /api/control/pause
```

`/api/events` is an SSE stream. Mutation endpoints reject non-loopback clients,
non-JSON bodies, and requests whose `Origin` is not the dashboard origin. The
dashboard displays the active per-role model and reasoning effort read-only.

## Behavior Changes

### Inventory and campaign startup

The repository currently contains only the migration design and candidate data;
there is no executable orchestration behavior. The new startup sequence is:

1. Acquire the single-owner lock.
2. Read and validate the complete inventory and agent configuration.
3. Resolve the repository, `exp/test-migration`, `codex`, and `bal` identities.
4. Run read-only state and Git health checks.
5. Reconcile manifest/configuration revisions and interrupted attempts while
   paused.
6. Start the dashboard with Start disabled until every check succeeds.

Persist snapshots with same-directory temporary files, file fsync, atomic
rename, and directory fsync. Snapshots are authoritative; `events.jsonl` is
append-only audit history and is never replayed to reconstruct state.

### Git and worktree ownership

Implement the exact branch/worktree model from `MIGRATION.md`:

```text
aggregation: feat/test-migration-results
candidate:   feat/test-migration/<candidate-id>/attempt-<n>
```

Allow at most three active candidate worktrees and one integration worktree.
The orchestrator alone creates, merges, archives, removes, and prunes them.

Every completed role creates exactly one role-owned commit. Verify its message,
parent, changed paths, and worktree state before advancing. Reject any commit
containing the rendered `migration-results/<candidate-id>/AGENTS.md`, even
though the repository ignore rule will also cover that exact generated file.

Merge accepted candidates serially with `--no-ff`, rerun validation in the
integration worktree, record the accepted and merge commits atomically, then
remove the candidate worktree and branch. Preserve every other terminal attempt
under `.orchestrator/archive/` and at
`refs/migration-attempts/<candidate-id>/<attempt>` before cleanup.

### Fail-closed execution

On a repository/worktree/ancestry/ownership/archive/cleanup invariant failure:

1. Persist a structured campaign incident.
2. Stop all candidate transitions and dequeuing.
3. Terminate active Codex and `bal` process groups.
4. Mark affected attempts `interrupted_by_campaign_fault`.
5. Perform no more Git mutations in that process.
6. Leave the dashboard available with the exact evidence and recovery checks.

Give each Codex role 45 minutes. Recover an invalid/missing role commit or
ordinary Codex failure from `preRoleCommit` at most three consecutive times.
The fourth failure blocks the candidate as `agent_retry_exhausted`. This limit
does not apply to `agent_configuration_invalid`, which faults the campaign.

### Validator

Discover only standalone `.bal` files named `*-v.bal`, `*-e.bal`, or `*-p.bal`
and Ballerina project directories named `*-v`, `*-e`, or `*-p`. Reject duplicate
cases, unrecognized standalone files, nested case ambiguity, symlinks escaping
the candidate directory, and marker/suffix mismatches.

Resolve and pin the absolute `bal` executable, complete version output, and
fingerprint. Use a fresh target directory and a 90-second timeout for each case.
Terminate the complete process group on timeout, Pause, or campaign fault.

Implement marker parsing and `-v`/`-e`/`-p` behavior exactly as specified by
`MIGRATION.md`, including exact stdout, bidirectional inclusive diagnostic-span
coverage, first-stack-frame matching, and the one-output-file rule for projects.

### Prompt and role loop

Track these templates:

```text
prompts/AGENTS.md.tmpl
prompts/migrate.md.tmpl
prompts/review.md.tmpl
prompts/fix.md.tmpl
```

Render only operational facts. Store each rendered file and SHA-256 hash before
launch. Migration and fix roles must run the exact validator command before
committing. Parse a validator receipt from the Codex JSON event stream and
require its output hash to match the committed output before the orchestrator's
independent validation.

Use at most three semantic reviews: initial, first post-fix, and final
post-fix. A remaining finding becomes `blocked:review_exhausted`.

## Pilot Manifest

Add `tools/jballerina-test-migration/pilot-manifest.jsonl`. It is the frozen
first eight entries from the unfiltered random draw and contains no expected
outcomes or classifications:

```jsonl
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/statements/block/BlockStmtTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/statements/block/block-stmt.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/block/block-stmt-negative.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/block/block-stmt-semantics-negative.bal"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/statements/matchstmt/varbindingpatternmatchpattern/ListBindingPatternTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/list_binding_pattern.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/list_binding_pattern_negative.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/list_binding_pattern_semantics_negative.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/list_binding_pattern_with_rest_binding_pattern.bal"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/types/constant/SimpleConstantTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/types/constant/simple-literal-constant.bal"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/types/string/StringTemplateLiteralTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/types/string/string-template-literal.bal"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/statements/matchstmt/varbindingpatternmatchpattern/CaptureBindingPatternTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/capture-binding-pattern.bal","tests/jballerina-unit-test/src/test/resources/test-src/statements/matchstmt/varbindingpatternmatchpattern/capture-binding-pattern-negative.bal"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/runtime/api/RuntimeAPITest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/runtime/api"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/bala/readonly/ImmutabilityBalaTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/bala/test_bala/readonly/test_intersection_with_inherently_immutable_type.bal","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_bala/readonly/test_selectively_immutable_type.bal","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_bala/readonly/test_selectively_immutable_type_negative.bal","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_projects/test_project_immutable","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_projects/test_project_records","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_projects/test_project_selectively_immutable","tests/jballerina-unit-test/src/test/resources/test-src/bala/test_projects/test_project_types"]}
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/types/tuples/TupleMutabilityTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/types/tuples/tuple-mutability.bal","tests/jballerina-unit-test/src/test/resources/test-src/types/tuples/tuple-mutability-negative.bal"]}
```

The expected derived IDs are:

```text
block-stmt-test-58e33229dc
list-binding-pattern-test-b87d28a686
simple-constant-test-a426694281
string-template-literal-test-75d189a1b5
capture-binding-pattern-test-cbcddb7fc4
runtime-api-test-c64c2bd9f2
immutability-bala-test-8299d8267f
tuple-mutability-test-4a07e00b3d
```

## Implementation Tasks

### Stage 1: Contract and project scaffold

- Add the agent-execution section and state fields to `MIGRATION.md`.
- Add the executable wrapper, isolated package metadata, strict TypeScript
  configuration, source/test layout, checked-in agent configuration, role
  outcome schema, and repository ignore rules for `migrated/` and rendered
  candidate `AGENTS.md` files.
- Use Node built-ins for runtime behavior and a development-only TypeScript
  dependency for `tsc --noEmit`.

Verification:

- The wrapper prints command help from the repository root.
- Type checking succeeds.
- Configuration fixtures accept the balanced profile and reject every unknown
  field, missing role, invalid model value, and invalid effort value.

### Stage 2: Inventory and persistent state

- Implement strict JSONL parsing, path ownership checks, tracked directory
  expansion, canonicalization, IDs, manifest hashes, and input revisions.
- Implement schemas, transition validation, atomic snapshots, event appends,
  locking, manifest/config reconciliation, and crash detection.
- Add `doctor` read-only checks before any reconciliation mutation.

Verification:

- Unit fixtures cover malformed JSONL, duplicates, traversal, symlink escapes,
  directories, stable IDs, revisions, add/change/remove reconciliation, stale
  locks, corrupt snapshots, and configuration changes.
- Running `doctor` against failure fixtures produces evidence without changing
  Git refs, worktrees, state, or files.

### Stage 3: Git worktree lifecycle

- Implement branch/worktree creation, attempt replacement from
  `preRoleCommit`, commit inspection, strict diff allowlists, archival refs,
  durable failure archives, serialized integration merges, cleanup, and the
  fail-closed incident path.
- Never mutate the user's main checkout or any worktree outside the managed
  `migrated/` root.

Verification:

- Temporary-repository tests cover every Git operation failure listed in
  `MIGRATION.md`, invalid commits, dirty worktrees, wrong ancestry, conflicts,
  archive/cleanup failures, stale registrations, restart recovery, and the
  four-worktree ceiling.
- After a campaign fault, intercepted Git calls prove that no subsequent
  mutation is attempted.

### Stage 4: Deterministic validator

- Implement installed-`bal` discovery and pinning, case discovery, marker
  parsing, standalone/project execution, diagnostic and stack-frame parsing,
  fresh target directories, structured evidence, receipts, and cancellation.
- Implement `toolchain adopt` and post-adoption validation requeueing.

Verification:

- Scripted `bal` fixtures cover valid output, multiline output, compile errors,
  inclusive diagnostic spans, source-less diagnostics, panics, project cases,
  duplicate/unknown cases, external symlinks, timeouts, and cancellation.
- End-to-end validator smoke cases pass with the installed `bal`.

### Stage 5: Codex roles and review loop

- Implement prompt rendering/hashing, fresh process-group launches, JSON event
  capture, structured outcomes, model/effort arguments, validator receipt
  recognition, commit verification, infrastructure recovery, timeouts, and the
  three-review loop.
- Ensure migration, review, and fix each receive only their role-specific
  permissions and required commit message.

Verification:

- A scripted Codex executable asserts the exact model and effort for every
  role and simulates approvals, findings, fixes, terminal blocks, missing and
  multiple commits, dirty exits, reviewer output mutation, invalid config,
  role timeout, Pause, retry exhaustion, and review exhaustion.
- Every archived run retains the effective model, effort, command, prompt,
  session, events, final outcome, status, diff, and validation evidence.

### Stage 6: Dashboard

- Implement the snapshot/detail/evidence/control endpoints, SSE broadcasts,
  browser opening, and a framework-free TypeScript/HTML/CSS interface.
- Show toolchain identity, inventory/configuration hashes, read-only role model
  and effort, campaign health, candidate counts, inputs, role state, sessions,
  worktrees, branches, commits, validations, findings, logs, durations, blocks,
  and incident recovery checks.

Verification:

- HTTP tests cover loopback binding, same-origin mutation checks, Start/Pause,
  disabled controls while faulted, SSE snapshots and revisions, evidence path
  containment, graceful shutdown, and forced restart recovery.
- Inspect the completed UI in the in-app browser at desktop and narrow widths.

### Stage 7: Real pilot

- Run the dashboard with `pilot-manifest.jsonl`, the balanced agent profile,
  and the dynamically discovered local `bal`.
- Start paused, verify the initial snapshot, run the campaign, exercise
  Pause/Resume, and allow every candidate to reach `passed` or an
  evidence-backed supported `blocked` state.
- Retain the aggregation branch, campaign state, logs, validation records,
  archival refs, and dashboard evidence. Remove terminal candidate worktrees
  and temporary branches as part of normal orchestration.

Verification:

- Every Codex role log contains the configured explicit model and reasoning
  effort.
- Passed candidates have an accepted role commit, aggregation merge commit,
  and passing post-merge validator record.
- Blocked candidates have a supported code and evidence paths.
- Pause creates fresh attempts and leaves abandoned attempts inspectable.
- `git worktree list` never shows more than three managed candidates plus the
  integration worktree.
- `migrate doctor` reports a healthy final state with no unexpected managed
  refs, branches, paths, or worktrees.
- Record the manifest/config hashes, tool versions, candidate outcomes,
  commits, worktree maximum, Pause/Resume result, doctor result, and dashboard
  screenshot in a concise pilot-validation report.

## Tests and Validation

The feature is complete only when all of these pass:

1. TypeScript type checking and unit tests.
2. Inventory, configuration, state, validator, role, Git, HTTP, and SSE
   integration tests in temporary isolated repositories.
3. Deterministic Pause tests during migration, review, and fix roles.
4. Real installed-`bal` validator smoke tests.
5. The real eight-candidate Codex campaign reaches only `passed` or supported
   `blocked` terminal states without a campaign invariant fault.
6. Dashboard inspection confirms controls, live updates, model/effort display,
   evidence navigation, fault presentation, and responsive layout.
7. Final Git inspection confirms accepted merges, archival refs, automatic
   cleanup, the four-worktree bound, and a healthy read-only `doctor` result.

## Assumptions and Defaults

- `exp/test-migration` is the pinned campaign base.
- The agent configuration controls Codex model and named reasoning effort;
  Codex CLI does not expose a numeric reasoning-token cap for this workflow.
- The initial profile is Terra/high for migration and fix and Sol/high for
  independent review.
- Configuration changes require a dashboard process restart and do not rewrite
  or requeue already passed candidate output.
- Defaults are three concurrent candidates, three semantic reviews, 90 seconds
  per `bal` case, 45 minutes per Codex role, and three consecutive role
  infrastructure recoveries.
- All acceptance execution uses the pinned locally installed `bal`, never an
  in-tree distribution or Nutcracker.
- The pilot's aggregation results and audit state remain available after
  validation; terminal candidate worktrees are removed automatically.
