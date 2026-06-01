# Tasks

Task format, statuses, priorities, dependencies, blocking, and the Definition
of Done are defined in the canonical schema: see `docs/task-schema.md`.

The `Status` field is the only source of a task's state. Tasks are listed in
ascending ID order; file order does not affect selection.

---

### T-001 — Example approved task (worked example)
- Status: approved
- Priority: P2
- Owner: unassigned
- Dependencies: none
- Acceptance criteria:
  - [ ] User can perform the described action successfully
  - [ ] Given invalid input, when submitted, then a clear error is shown
- Notes: This task is `approved`, has no unfinished dependencies, and is the
  highest-priority eligible task — so it is the one the selection logic in
  `docs/task-schema.md` ("Deterministic task selection") would pick next.

### T-002 — Example backlog task
- Status: backlog
- Priority: P3
- Owner: unassigned
- Dependencies: none
- Acceptance criteria:
  - [ ] Describe the first observable, testable outcome
  - [ ] Describe the second observable, testable outcome
- Notes: Not yet approved for work. The Product Manager moves a task to
  `approved` once priority and business value are confirmed.

### T-003 — Example task waiting on a dependency
- Status: approved
- Priority: P2
- Owner: unassigned
- Dependencies: T-001
- Acceptance criteria:
  - [ ] Describe the testable outcome here
- Notes: This task is `approved` but depends on T-001, which is not yet `done`,
  so it is not eligible for selection until then. Waiting on a dependency keeps
  the status `approved` — it is not `blocked`.

### T-004 — Example blocked task
- Status: blocked
- Priority: P2
- Owner: unassigned
- Dependencies: none
- Blocked by: Awaiting API credentials from vendor (since 2026-06-01)
- Acceptance criteria:
  - [ ] Describe the testable outcome here
- Notes: `blocked` is for an external blocker on a task already in progress, not
  for waiting on another task. When unblocked, set `Status: in-progress` and
  remove the `Blocked by` line.

<!-- Completed tasks keep Status: done and stay in this list; they must satisfy
     the Definition of Done in docs/task-schema.md. -->
