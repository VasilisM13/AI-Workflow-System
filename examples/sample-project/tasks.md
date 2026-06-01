# Tasks

Task format, statuses, priorities, dependencies, and the Definition of Done are
defined in the canonical schema: see `docs/task-schema.md`. The `Status` field
is the only source of a task's state. Tasks are listed in ascending ID order.

---

### T-001 — Shorten a URL
- Status: done
- Priority: P1
- Owner: developer
- Dependencies: none
- Acceptance criteria:
  - [x] `POST /shorten` accepts a long URL and returns a short code
  - [x] The same long URL returns a stable short code on repeat requests
  - [x] Given a malformed or missing URL, when posted, then a 400 error is returned
- Notes: Taken end-to-end through the canonical workflow — PM confirmed P1
  value, BA refined criteria, Architect recorded D-001 (decisions.md), Developer
  implemented, QA verified in QA-001 (qa.md). Definition of Done met.

### T-002 — Redirect short code to original URL
- Status: approved
- Priority: P1
- Owner: unassigned
- Dependencies: T-001
- Acceptance criteria:
  - [ ] `GET /{code}` returns an HTTP 302 redirect to the original URL
  - [ ] Given an unknown code, when requested, then a 404 is returned
- Notes: T-001 is `done`, so this task's only dependency is satisfied. It is
  `approved` and the highest-priority eligible task — the one the selection
  logic in `docs/task-schema.md` ("Deterministic task selection") picks next.

### T-003 — Custom alias support
- Status: backlog
- Priority: P3
- Owner: unassigned
- Dependencies: none
- Acceptance criteria:
  - [ ] User can request a custom alias instead of a generated code
  - [ ] Given an alias already in use, when requested, then a 409 conflict is returned
- Notes: Improvement-level. Not yet approved — awaiting Product Manager
  prioritization before it becomes eligible for work.
