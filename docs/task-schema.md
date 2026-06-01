# Task Schema and Lifecycle

This is the **canonical definition** of how tasks are written, tracked, and
completed in the AI Workflow System. Any file that mentions tasks, approval,
priority, or completion defers to this document.

Tasks live in each project's `tasks.md`. The schema is plain markdown so it is
readable by humans and unambiguously parseable by Claude Code.

Sections are referenced by name throughout (e.g. see "Deterministic task
selection"), not by number, so they stay valid if the document is reordered.

---

## Task ID

- Format: `T-` followed by a zero-padded sequence number (`T-001`, `T-002`,
  … `T-014`). Use at least three digits; zero-padding keeps IDs sorting
  correctly when ties are broken by ID (see "Deterministic task selection").
- IDs are **monotonic and never reused.** If a task is cancelled, its ID is
  retired, not recycled.
- Each task has exactly one ID for its entire life. Renaming the title does not
  change the ID.
- Other files reference tasks by ID (e.g. "implement `T-014`"). IDs, not titles,
  are the stable identifier.

---

## Task block format

Every task is one markdown block with the following fields, in this order:

```markdown
### T-001 — Short task title
- Status: approved
- Priority: P2
- Owner: unassigned
- Dependencies: none
- Acceptance criteria:
  - [ ] First testable, observable outcome
  - [ ] Second testable, observable outcome
- Notes: Optional free text, links, or context.
```

Field rules:

| Field | Required | Allowed values |
|-------|----------|----------------|
| Heading `### T-NNN — Title` | yes | ID + ` — ` + concise title |
| `Status` | yes | one of the statuses in "Status lifecycle" |
| `Priority` | yes | `P1`–`P4` (see "Priority levels") |
| `Owner` | yes | agent role, person, or `unassigned` |
| `Dependencies` | yes | `none` or comma-separated task IDs (see "Dependencies format") |
| `Blocked by` | only when `Status: blocked` | a concrete external blocker (see "Blocked-task format") |
| `Acceptance criteria` | yes | checkbox list (see "Acceptance criteria format") |
| `Notes` | optional | free text |

The `Blocked by` line is present only while a task is blocked; omit it
otherwise. A task block is **valid** only when every required field is present
and its value is in range. An invalid task must not be selected for work.

---

## Status lifecycle

Allowed statuses and their meaning:

| Status | Meaning |
|--------|---------|
| `backlog` | Captured but not yet approved for work. Default for new tasks. |
| `approved` | Approved by the Product Manager; eligible to be worked. |
| `in-progress` | Actively being implemented. |
| `blocked` | Started, but cannot proceed due to an external blocker (see "Blocked-task format"). Not used for waiting on task dependencies. |
| `in-review` | Implementation complete; under QA / review. |
| `done` | Meets the Definition of Done. Terminal. |
| `cancelled` | Abandoned and will not be done. Terminal. ID retired. |

### Allowed transitions

```
backlog ──► approved ──► in-progress ──► in-review ──► done
                │              │   ▲           │
                │              ▼   │           ▼
                │           blocked ──────► (back to in-progress)
                │
                └──► cancelled        (any non-terminal status ──► cancelled)
```

- `backlog → approved`: **only the Product Manager** sets `approved`. This is the
  single definition of "approved": a task whose `Status` field is `approved`,
  set by the PM after confirming priority and business value.
- `approved → in-progress`: allowed only when **all** dependencies are `done`
  (see "Dependencies format"). Set when work begins.
- `in-progress → blocked`: when work cannot continue because of an external
  blocker; a `Blocked by` reason is mandatory.
- `blocked → in-progress`: when the blocker is resolved; the `Blocked by` line is
  removed.
- `in-progress → in-review`: implementation finished, handed to QA.
- `in-review → done`: QA confirms the Definition of Done is met.
- `in-review → in-progress`: review found issues; work resumes.
- `any non-terminal → cancelled`: a task may be cancelled from any non-terminal
  state.
- `done` and `cancelled` are **terminal** — no transitions out.

Any transition not shown above is invalid. (Waiting on an unfinished dependency
is **not** a transition — such a task stays `approved`; see "Dependencies
format".)

---

## Priority levels

| Priority | Label | Meaning |
|----------|-------|---------|
| `P1` | Critical | Required for operation or launch; blocks delivery. |
| `P2` | High Value | Significant business or user impact. |
| `P3` | Improvement | Improves experience or efficiency; not urgent. |
| `P4` | Future | Not currently justified; revisit later. |

This section is the **single canonical source** for priority labels and their
meanings. Every other file uses these exact labels and does not define its own.
The Product Manager owns prioritization decisions (assigning P1–P4) and the
Business Analyst may recommend a priority, but both draw the labels and meanings
from here.

---

## Acceptance criteria format

- Written as a **checkbox list** under `Acceptance criteria:`.
- Each criterion must be **testable, observable, and independently verifiable** —
  something QA can mark pass/fail without interpretation.
- Phrase criteria as outcomes, not implementation steps.
- Optional Given/When/Then form is allowed for behavioural criteria:
  `- [ ] Given <state>, when <action>, then <observable result>`
- A task may not move to `in-review` until every acceptance-criteria box can be
  checked; it may not move to `done` until QA has checked them.

Example:

```markdown
- Acceptance criteria:
  - [ ] User can reset password from the login screen
  - [ ] Reset link expires after 30 minutes
  - [ ] Given an expired link, when opened, then an error message is shown
```

---

## Dependencies format

- `Dependencies:` is either `none` or a comma-separated list of task IDs:
  `Dependencies: T-003, T-007`.
- A dependency means "this task cannot start until that task is `done`."
- A task may not transition `approved → in-progress` while any dependency is not
  `done`. While waiting, it **stays `approved`** (it is simply not eligible for
  selection) — it is not marked `blocked`. `blocked` is reserved for external
  blockers (see "Blocked-task format").
- Dependencies must reference existing task IDs. Circular dependencies are
  invalid and must be resolved before either task is worked.

---

## Blocked-task format

`blocked` is for a concrete **external** blocker — something outside the task
system that stops a task already in progress (e.g. awaiting credentials, a
vendor, or an external decision). Waiting on another task in `tasks.md` is a
dependency, not a block (see "Dependencies format").

When `Status: blocked`, add a `Blocked by` line stating the blocker:

```markdown
- Status: blocked
- Blocked by: Awaiting API credentials from vendor (since 2026-06-01)
```

Rules:
- A blocked task names a concrete external blocker and, where useful, the date
  it became blocked.
- A blocked task is **not** eligible for selection.
- When unblocked, set `Status: in-progress` and remove the `Blocked by` line.

---

## Definition of Done

A task may move to `done` only when **all** of the following hold:

- [ ] Every acceptance criterion is checked (verified by QA).
- [ ] Build passes.
- [ ] Relevant tests pass; new behaviour has tests where applicable.
- [ ] No new critical or high-severity defects introduced.
- [ ] Affected documentation updated (`architecture.md`, `decisions.md`,
      `qa.md`, `CLAUDE.md` as relevant).
- [ ] Scope matches the task; no unrelated changes.
- [ ] Task `Status` set to `done` in `tasks.md`.

(Improvement 7 may later extract a standalone `definition-of-done.md` checklist;
until then, this section is the canonical definition.)

---

## Deterministic task selection

"Select the next task" resolves to a single, repeatable choice:

1. Consider only tasks with `Status: approved`.
2. Exclude any task whose dependencies are not all `done`.
3. Among the remainder, pick the **highest priority** (`P1` before `P2`, …).
4. Break ties by the **lowest task ID**.

If no task qualifies, there is no next task — stop and report why (e.g. all
remaining approved tasks have dependencies that are not yet `done`).

---

## Organization of `tasks.md`

- `tasks.md` is a single flat list of task blocks; the `Status` field is the
  **only** source of a task's state. There are no status-named sections that
  could disagree with it.
- List tasks in ascending ID order for readability. File order does not affect
  selection — "Deterministic task selection" sorts by priority then ID.
- New tasks are appended with the next free ID.
- Keep one blank line between task blocks.
