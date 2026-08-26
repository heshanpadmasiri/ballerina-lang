# Resumable Agent-Driven jBallerina Test Migration Harness

## Summary

Build a clean TypeScript tool under `tools/jballerina-test-migration/` that:

- Takes minimal candidates containing only a Java harness and associated Ballerina files/projects.
- Creates an isolated jBallerina Git worktree for every candidate attempt.
- Launches fresh Codex subagents for migration, review, and fixes.
- Requires every subagent to commit its work before the next role begins.
- Validates migrated tests using the locally installed `bal`.
- Provides a persistent dashboard with Start, Pause, progress, blocked cases, Git checkpoints, and installed Ballerina version.

Candidate discovery and promotion into Nutcracker remain out of scope. Nutcracker supplies only the corpus naming and marker contract.

## Candidate Inventory Format

The dashboard consumes a UTF-8 JSONL file passed through `--manifest`. Each non-blank line is one candidate; comments and unknown fields are rejected.

```ts
interface CandidateInventoryRecord {
  schemaVersion: 1;

  /** Repository-relative path to the one suite-selected Java test harness. */
  javaSource: string;

  /** Repository-relative Java helpers/superclasses supplied with the candidate. */
  javaSupportSources?: string[];

  /** Repository-relative .bal files or directories containing complete source/project inputs. */
  ballerinaSources: string[];
}
```

Example with independent Ballerina files:

```json
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/expressions/binaryoperations/AddOperationTest.java","ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/expressions/binaryoperations/add-operation.bal","tests/jballerina-unit-test/src/test/resources/test-src/expressions/binaryoperations/add-operation-negative.bal"]}
```

Example with a Ballerina project directory and a Java helper:

```json
{"schemaVersion":1,"javaSource":"tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/imports/ImportsTest.java","javaSupportSources":["tests/jballerina-unit-test/src/test/java/org/ballerinalang/test/imports/ImportTestUtils.java"],"ballerinaSources":["tests/jballerina-unit-test/src/test/resources/test-src/imports/test_project"]}
```

Inventory rules:

- Resolve all paths relative to the pinned jBallerina repository root; absolute paths, `..` traversal, and paths escaping through symlinks are invalid.
- `javaSource` must be a tracked `.java` file and may occur in exactly one record. Support sources must be tracked `.java` files.
- Every `ballerinaSources` entry must be either a tracked `.bal` file or a tracked directory. A directory contributes all tracked files beneath it, including `Ballerina.toml`, modules, resources, and other project fixtures; generated/untracked `build` and `target` contents are never included.
- Arrays must not contain duplicate canonical paths. The same Ballerina file/project may appear in different candidates because candidate worktrees isolate their results.
- `ballerinaSources` must be non-empty. `javaSupportSources` defaults to an empty array.
- Record order and array order carry no semantics. Canonicalization sorts records by normalized `javaSource` and arrays by normalized path before hashing.
- Derive the candidate ID rather than storing it in the inventory: `<java-class-slug>-<first-10-hex-of-sha256(normalized-javaSource)>`. Correcting the Ballerina source list therefore keeps the same candidate ID.
- Compute an input-revision hash over the canonical record plus the pinned contents and paths of every supplied file. Store the manifest hash and each candidate revision in campaign state.
- Parse and validate the complete inventory before creating branches or worktrees. Any invalid row is a campaign-level `inventory_invalid` fault displayed with its JSONL line number and reason.

No test inventory, expected result, classification, source grouping, or marker position is supplied.

The migration subagent discovers the tests from the sources. A fresh review subagent independently rediscovers them. Neither role receives a precomputed test inventory or writes an inventory artifact.

If a listed Java source refers to a missing helper or Ballerina fixture, the candidate becomes `blocked:candidate_input_incomplete`; agents must not silently explore unrelated repository tests or guess the missing behavior.

On dashboard restart, an unchanged manifest hash reuses persisted state. An added record becomes queued; a changed record with the same `javaSource` creates a new input revision and requeues that candidate from scratch while retaining old attempts. Removing a record marks it `retired` and stops future scheduling, but never deletes already merged output automatically. Inventory reconciliation completes while paused and is recorded in the event log before Start is enabled.

## Git Worktree and Commit Model

Use the existing `exp/test-migration` branch as the campaign base and pin its commit when the campaign is created.

Create a dedicated aggregation branch and worktree:

```text
branch:   feat/test-migration-results
worktree: migrated/.integration/worktree
```

Each fresh candidate attempt receives its own branch and worktree:

```text
branch:   feat/test-migration/<candidate-id>/attempt-<n>
worktree: migrated/<candidate-id>/attempts/<n>/worktree
```

For a candidate not yet present in the aggregation branch, create the attempt from the pinned campaign base. If an already-merged candidate is intentionally re-migrated after an input revision, create its attempt from the current aggregation HEAD so it updates its existing owned directory. Only one attempt for a candidate ID may be active or merge-pending at a time.

Candidate worktrees contain the complete jBallerina checkout for reading, but agents may modify only:

```text
migration-results/<candidate-id>/
```

Track `tools/jballerina-test-migration/prompts/AGENTS.md.tmpl` and render it for each attempt as `migration-results/<candidate-id>/AGENTS.md`. Run Codex with that candidate-owned directory as its working directory so the rendered instructions are automatically in scope. The repository's migration-tool setup ignores only `migration-results/*/AGENTS.md`; the rendered file must remain untracked and must never appear in a role commit. Store an audited copy and SHA-256 hash beside the agent logs before launch. The orchestrator must enforce the same boundary independently by inspecting every commit diff.

The filled `AGENTS.md` must state:

- The candidate ID, candidate-owned writable path, branch, and attempt number.
- The repository-relative Java and Ballerina input paths that may be read.
- Input sources are read-only; all generated migration files belong under the candidate-owned path.
- The subagent may create only its required role commit. It must not create/delete worktrees or branches, merge, rebase, reset, checkout another ref, amend earlier role commits, or run cleanup/recovery commands.
- The role prompt further narrows permissions; for example, review may write only `review.md` and may not edit migrated output.
- The exact validator command comes from the role prompt and must use the campaign-pinned locally installed `bal`.
- Missing inputs or instructions must be reported rather than guessed.

Role checkpoint rules:

- Before launching a role, require a clean worktree and record `preRoleCommit`.
- Every role must create exactly one commit and leave the worktree clean.
- Record the new commit as `postRoleCommit`.
- Reject commits that modify paths outside the candidate-owned result directory.
- Preserve rejected commits and uncommitted diffs in the attempt archive; recover by creating a replacement worktree from `preRoleCommit`, never by trusting the damaged working tree.

Required commits:

```text
Migration: test(migration): migrate <candidate-id>
Review:    docs(migration): review <candidate-id> round <n>
Fix:       test(migration): fix <candidate-id> round <n>
```

Commit ownership is strict:

- The migration, review, and fix subagents each create their own required role commit after completing their work and required validation.
- The orchestrator never stages candidate files, completes a subagent's partial commit, amends a role commit, or commits uncommitted agent output.
- After a role exits, the orchestrator only verifies that exactly one new commit exists, its message and parent are correct, its diff is confined to the role's allowed paths, and the worktree is clean.
- A missing, extra, malformed, or out-of-scope role commit fails that role. The orchestrator archives it and restarts from `preRoleCommit`; it does not repair the commit.
- The orchestrator creates only the serialized `--no-ff` merge commit that integrates an already accepted candidate branch into `feat/test-migration-results`.

When issues exist, the review subagent writes and commits `review.md`. A passing review creates an explicit empty commit with `--allow-empty`, so every role still has a recoverable Git checkpoint without adding a redundant result file.

## Automatic Merge and Worktree Cleanup

Candidate merging is fully automatic and serialized through a single merge queue. A candidate is not considered passed until its accepted branch has been merged into `feat/test-migration-results`.

Merges are conflict-free by construction: every candidate owns exactly one unique `migration-results/<candidate-id>/` directory, commits may not touch any other path, and only one attempt for that candidate ID can enter the merge queue. A new candidate adds an absent owned directory; an intentional re-migration starts from an aggregation commit that already contains that directory and updates only that directory.

After the final review passes, the orchestrator must:

1. Mark the candidate `merge_pending` and acquire the global merge mutex.
2. Verify the candidate worktree is clean, its accepted commit descends from the pinned campaign base, and every candidate commit touches only `migration-results/<candidate-id>/`.
3. Refresh the dedicated integration worktree, assert the candidate-owned path has the expected absent-or-existing state for that attempt, and preflight the merge against its current HEAD.
4. Merge the candidate branch with `--no-ff` into `feat/test-migration-results` using an orchestrator-created commit.
5. Rerun the deterministic validator against the merged candidate files in the integration worktree.
6. Atomically record the accepted candidate commit and integration merge commit, then mark the candidate `passed`.
7. Remove the candidate worktree with `git worktree remove`, delete the now-merged candidate branch with `git branch -d`, run `git worktree prune`, and release the candidate slot.

If Git nevertheless reports a conflict, abort the merge and stop the scheduler with a campaign-level `invariant_error`; do not classify it as a candidate migration failure. Preserve the attempt and integration diagnostics, because a conflict means the branch base, candidate-ID ownership, allowlist enforcement, or merge serialization is defective. A post-merge validation failure remains a candidate-level `blocked:post_merge_validation`. No merge operation uses or mutates the user’s main checkout, and the user never merges individual candidates manually.

All other terminal attempts are archived and cleaned automatically:

- Before removing a failed, rejected, paused, or abandoned worktree, save its state, logs, `git status --porcelain=v2`, and `git diff --binary` under `.orchestrator/archive/<candidate-id>/<attempt>/`.
- Create `refs/migration-attempts/<candidate-id>/<attempt>` at the attempt HEAD so committed checkpoints remain reachable without keeping a local branch or worktree.
- After the archive and ref are durable, remove the worktree with `git worktree remove --force`, delete its temporary branch, and run `git worktree prune`.
- `migrate inspect <candidate-id> --attempt <n>` may materialize a temporary diagnostic worktree from the archival ref when investigation is needed; closing the inspection removes it again.

With the default concurrency of three, the scheduler permits at most four ordinary worktrees while running: three active candidate worktrees plus the integration worktree. It does not dequeue a replacement candidate until cleanup releases a slot. On graceful shutdown it also removes the clean integration worktree; the aggregation branch remains and the worktree is recreated on the next dashboard start.

## Fail-Closed Orchestration

The orchestrator is the only component allowed to create, merge, archive, remove, or prune worktrees and branches. Subagents only edit and commit inside the worktree they are given; they never run orchestration or recovery operations.

Treat repository/worktree failures as campaign-level faults, not candidate-level blocks. This includes:

- A failed `git worktree add`, `remove`, `list`, or `prune` operation.
- An unexpected dirty or detached integration worktree.
- A missing, moved, duplicate, or externally registered managed worktree.
- A branch/ref/HEAD mismatch with persisted state.
- A path-ownership violation or unexpected commit ancestry.
- A merge conflict, which violates the conflict-free merge invariant.
- Failure to durably archive an attempt before cleanup.
- Failure to remove a terminal attempt and release its scheduler slot.

On any such fault, the deterministic program must:

1. Atomically set the campaign to `faulted` and persist a structured incident containing the error code, failed command, exit status, stderr, affected candidate/worktree/branch/ref, expected state, observed state, and timestamp.
2. Stop dequeuing and transitioning candidates immediately.
3. Terminate active Codex and `bal` process groups, marking those attempts `interrupted_by_campaign_fault` without attempting further Git cleanup.
4. Make no more Git mutations in that server process, including automatic retries, forced resets, merges, branch deletion, or worktree pruning.
5. Keep the dashboard server available and show a prominent fault banner with the exact evidence and deterministic remediation checks.

`Start` and `Resume` are disabled while faulted. The user fixes the repository/worktree problem externally and restarts the dashboard process. Startup then performs read-only Git/state health checks first. If they still fail, the dashboard remains faulted without mutation. If they pass, startup reconciles interrupted attempts using the normal archive-and-cleanup procedure, clears the incident into history, and returns the campaign to `paused`; the user explicitly starts it again.

Provide `migrate doctor` as a read-only command that runs the same startup checks and prints the fault evidence and expected invariants. It diagnoses only and never repairs repository state.

## Filled Prompt Templates

Track four templates under `tools/jballerina-test-migration/prompts/`:

```text
AGENTS.md.tmpl
migrate.md.tmpl
review.md.tmpl
fix.md.tmpl
```

The orchestrator fills only operational facts:

```text
{{candidate_id}}
{{attempt_number}}
{{candidate_branch}}
{{java_sources}}
{{ballerina_sources}}
{{allowed_output_dir}}
{{validator_command}}
{{pre_role_commit}}
{{review_round}}
{{review_file}}
{{required_commit_message}}
```

It stores the rendered prompt with the agent log so the exact instructions for every commit remain auditable.

The migration prompt must instruct the subagent to:

- Read every supplied Java and Ballerina source rather than relying on precomputed semantic metadata.
- Find every enabled TestNG method and data-provider expansion, compile/load/cache operation, invocation, assertion, expected exception, and diagnostic assertion.
- Generate all required `-v`, `-e`, and `-p` files/projects, splitting unrelated compile targets and creating one `-p` case per independent panic.
- Preserve every observable assertion; report `candidate_input_incomplete` or another supported block reason instead of omitting or guessing a test.
- Run the filled validator command, modify only the candidate-owned output directory, and create the required migration commit.

The review prompt must contain the acceptance criteria and instruct a fresh subagent to:

- Rediscover the complete test intent directly from the supplied Java and Ballerina sources; do not treat filenames, the migration commit message, or generated markers as evidence that coverage is complete.
- Account for every enabled TestNG method and provider row, every assertion, every expected diagnostic, every invocation, and every expected panic.
- Confirm unrelated compile targets and independent panics were split correctly, while genuine projects remain projects.
- Confirm `@output`, `@error`, and `@panic` preserve the Java harness's observable intent and do not manufacture behavior the harness never asserted.
- Rerun the filled validator command and reject a migration that lacks a successful migration-agent validation for the current output hash.
- Never modify migrated output. Write `review.md` with concrete, actionable findings only when any criterion fails; otherwise leave it absent.
- Commit `review.md` when issues exist, or create the required empty approval commit when all criteria pass.

The fix prompt must include the current `review.md` and instruct the subagent to address every finding, rerun validation, modify only the candidate output, remove the consumed `review.md`, and create the required fix commit.

The orchestrator hashes migration output before review and rejects any reviewer commit that changes it. No migration or review inventory JSON file is created; Git history, validator records, the rendered prompts, and `review.md` provide the audit trail.

## Review/Fix Loop

```text
migration commit
      ↓
orchestrator validation
      ↓
review commit
      ↓ issues
fix commit → orchestrator validation → review commit
```

Run at most three reviews:

1. Initial review.
2. First post-fix review.
3. Final post-fix review.

A remaining issue becomes `blocked:review_exhausted`.

Migration and fix subagents must run validation before committing. The validator records the role, command, result, and output hash in orchestrator state. The orchestrator independently validates each resulting commit afterward.

If a role corrupts its worktree, makes an invalid commit, or fails before committing, restart that role from its recorded `preRoleCommit` in a replacement worktree. This infrastructure recovery does not consume a semantic review round.

## Locally Installed jBallerina Validation

Resolve `bal` through `PATH` when opening a campaign:

- Resolve its absolute path and symlinks.
- Run `bal version`.
- Record the executable path, complete version output, and fingerprint.
- Display the path and complete version prominently in the dashboard.
- Pass the pinned absolute executable to every validation command.
- Disable Start if the executable is missing or differs from the campaign pin.

Provide:

```sh
migrate toolchain adopt
```

Adopting a different installed version updates the campaign pin and requeues all previously passed candidates for validation. Never silently mix validation versions.

The current installation is `/Library/Ballerina/bin/bal`, reporting Ballerina `2201.13.4`; these values must be discovered dynamically rather than hardcoded.

Validator rules:

- Recognize only `-v`, `-e`, and `-p`.
- Use a fresh target directory and 90-second timeout per case.
- Terminate the complete process group on timeout or Pause.
- Store commands, toolchain identity, stdout/stderr, parsed diagnostics/frames, duration, output hash, and verdict.
- Reject path escapes, external symlinks, undeclared output files, duplicate cases, suffix/marker mismatches, and skipped cases.

Marker behavior:

- Parse from the first `//`, with precedence `@output`, `@panic`, then `@error`.
- `-v`: run using `bal run`; require exit zero, no compile errors, and exact stdout matching ordered `@output` markers.
- `-e`: use `bal build`; require compilation failure, source-located errors, and bidirectional inclusive-span coverage between errors and `@error` markers.
- `-p`: use `bal run`; require compilation success followed by nonzero runtime exit, exactly one `@panic`, exact pre-panic stdout, and a marker matching the first Ballerina stack-frame basename and line.
- For projects, all `@output` markers must reside in one `.bal` file.

Warning/hint-only, AST/BIR/JVM introspection, source-less diagnostics, Java-specific behavior, CLI-argument tests, and unsupported lifecycle tests remain visible as blocked with evidence.

## Persistent State and Pause/Resume

Persist orchestration state outside candidate commits:

```text
migrated/
  .orchestrator/
    campaign.json
    control.json
    candidates/<id>.json
    events.jsonl
  .integration/worktree/
  <candidate-id>/
    input-revisions/
    attempts/
```

The persisted state schemas are operational only; they do not contain a discovered test inventory:

```ts
type CampaignMode = "paused" | "running" | "faulted";

interface CampaignState {
  schemaVersion: 1;
  revision: number;
  mode: CampaignMode;
  manifestPath: string;
  manifestHash: string;
  baseCommit: string;
  aggregationBranch: string;
  aggregationHead: string;
  bal: { path: string; version: string; fingerprint: string };
  currentIncident?: CampaignIncident;
  incidentHistory: CampaignIncident[];
  updatedAt: string;
}

type CandidateStatus =
  | "queued"
  | "migrating"
  | "validating"
  | "reviewing"
  | "fixing"
  | "merge_pending"
  | "pending_restart"
  | "passed"
  | "blocked"
  | "retired";

interface CandidateState {
  schemaVersion: 1;
  revision: number;
  id: string;
  javaSource: string;
  inputRevision: string;
  status: CandidateStatus;
  activeAttempt?: number;
  lastAttempt: number;
  reviewRound: number;
  acceptedCommit?: string;
  integrationCommit?: string;
  block?: { code: string; summary: string; evidencePaths: string[] };
  attempts: AttemptState[];
  updatedAt: string;
}

type AttemptStatus =
  | "active"
  | "accepted"
  | "failed"
  | "abandoned"
  | "interrupted_by_campaign_fault"
  | "archived";

interface AttemptState {
  schemaVersion: 1;
  revision: number;
  candidateId: string;
  attempt: number;
  inputRevision: string;
  status: AttemptStatus;
  branch: string;
  worktreePath?: string;
  baseCommit: string;
  headCommit: string;
  agentsInstructionsHash: string;
  agentsInstructionsLogPath: string;
  reviewRound: number;
  roles: RoleRunState[];
  validationRuns: Array<{
    id: string;
    role: "migration" | "review" | "fix" | "orchestrator";
    outputHash: string;
    verdict: "pass" | "fail" | "infra_error";
    evidencePath: string;
  }>;
  archiveRef?: string;
  archivePath?: string;
  startedAt: string;
  updatedAt: string;
}

interface RoleRunState {
  role: "migration" | "review" | "fix";
  reviewRound?: number;
  status: "starting" | "running" | "committed" | "failed" | "terminated";
  preRoleCommit: string;
  postRoleCommit?: string;
  promptPath: string;
  codexSessionId?: string;
  pid?: number;
  processGroupId?: number;
  startedAt: string;
  finishedAt?: string;
}
```

Candidate lifecycle transitions are fixed and validated by the orchestrator:

```text
queued → migrating → validating → reviewing
                                  ├─ pass → merge_pending → passed
                                  └─ issues → fixing → validating → reviewing

active stage ── user pause ──> pending_restart ── user start ──> migrating (new attempt)
any candidate stage ── non-migratable/review exhaustion ──> blocked
inventory removal ──> retired
```

The scheduler derives its queue only from candidate snapshots: candidates in `queued` are eligible when the campaign is running; `pending_restart` first creates a new attempt and then becomes `migrating`. It persists `migrating` and a `starting` role before spawning Codex, then persists the PID/session in a second revision. A crash at either point is therefore detectable on restart.

For every transition, acquire the candidate's in-process mutex, verify the current state/revision and allowed transition, update the candidate and its attempt records together in the single candidate snapshot, and persist it through temporary-file + file fsync + atomic rename. Then append an event containing the resulting revision and notify dashboard SSE clients. The single-file candidate snapshot avoids partial candidate/attempt updates. Snapshots are authoritative after a crash; `events.jsonl` is audit history and is never replayed to reconstruct state.

The dashboard obtains counts and details from the scheduler's in-memory view of these persisted snapshots. The single-owner scheduler lock prevents a second process from changing them concurrently.

Pause:

- Stop scheduling new roles and terminate active Codex and `bal` process groups.
- Archive each active attempt's commits, uncommitted binary diff, status, and logs.
- Remove its worktree and temporary branch after the archive is durable.
- Mark the attempt abandoned and the candidate `pending_restart`.

Resume:

- Create a new candidate attempt branch and worktree from the pinned campaign base.
- Restart with a fresh migration subagent.
- Do not reuse partial output or a previous Codex session.
- Keep abandoned attempts available through their archive and Git archival ref, not as checked-out worktrees.

On startup, first run the read-only campaign health checks. Only when they pass may reconciliation compare `git worktree list --porcelain` with persisted state, archive and remove interrupted managed worktrees under `migrated/`, and run `git worktree prune`. Never modify worktrees outside the managed `migrated/` root.

## Dashboard

Provide one entry command:

```sh
./tools/jballerina-test-migration/migrate dashboard --manifest <candidates.jsonl>
```

It starts a localhost-only server, opens the browser, restores state, and starts paused.

Show:

- Installed `bal` path and version.
- Candidate inventory path, manifest hash, schema version, last reconciliation result, and any invalid JSONL line.
- Campaign base and aggregation branch.
- Start/Resume and Pause controls.
- Campaign health (`paused`, `running`, or `faulted`) and a persistent fault banner containing the exact failed Git operation, affected paths/refs, observed state, and recovery checks.
- Queued, migrating, reviewing, fixing, merge-pending, pending-restart, passed, blocked, and retired counts.
- Candidate inputs and input revision.
- Current role, agent session, worktree, branch, and commits.
- Validation reports, review findings, logs, durations, and block reasons.
- Live updates through server-sent events.

## Implementation and Tests

1. **Git/state foundation**
   - Implement JSONL inventory parsing/canonicalization/reconciliation, candidate IDs, input revisions, atomic state, bounded worktree/branch lifecycle, role checkpoints, diff allowlists, serialized integration merging, attempt archival, automatic cleanup, fail-closed campaign faults, read-only doctor checks, and crash reconciliation.
   - Test malformed/unknown inventory fields, duplicate harnesses and paths, path traversal, file-versus-directory inputs, stable IDs, revision changes, added/removed records, every Git operation failure, dirty worktrees, invalid commits, unexpected paths, merge-invariant violations, post-merge validation failure, stale worktree registrations, archive/cleanup failure, the four-worktree ceiling, fault persistence across restart, mutation prohibition while faulted, and recovery from archival refs.

2. **Validator**
   - Implement installed-`bal` discovery, version pinning, marker parsing, file/project execution, structured reports, and process-group cancellation.
   - Cover valid, error, panic, project, multiline output, diagnostic spans, source-less diagnostics, and timeouts.

3. **Subagent roles**
   - Add filled `AGENTS.md`, migration, independent-review, and fix templates plus mandatory commit rules.
   - Test template rendering and hashing, ignored/uncommitted `AGENTS.md`, candidate-directory Codex working roots, missing commits, multiple commits, dirty exits, reviewer mutation, omitted Java tests, missing inputs, missing validation, and review exhaustion.

4. **Dashboard**
   - Add persistent controls, SSE updates, toolchain/Git information, merge/cleanup state, campaign fault evidence, reviews, validation, and logs.
   - Verify graceful and forced server termination, Start/Resume disabling while faulted, read-only failed startup checks, and clean recovery only after an external fix and restart.

5. **Pilot**
   - Exercise valid, compile-error, multi-panic, project, incomplete-input, and non-portable candidates.
   - Pause during every role and confirm Resume creates a fresh attempt, old worktrees are removed, archival refs remain inspectable, passed candidates merge automatically, and the live worktree count never exceeds four.

## Assumptions

- `exp/test-migration` is the campaign base; its exact commit is pinned when the campaign starts.
- Agents may read their jBallerina worktree but may only commit within their candidate-owned result directory.
- Candidate discovery supplies only Java and Ballerina source paths.
- All acceptance execution uses the pinned locally installed `bal`, never an in-tree distribution or Nutcracker.
- Promotion into the Nutcracker repository remains out of scope.
- Defaults are three concurrent candidates, three reviews, and 90 seconds per `bal` execution.
