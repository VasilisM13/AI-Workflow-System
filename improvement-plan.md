# AI-Workflow-System — Improvement Plan

## Purpose

This plan converts the AI-Workflow-System from a collection of static markdown
files into a practical, reusable Claude Code workflow system.

It is derived directly from the independent review of the repository. The work
is **sequenced, not simultaneous** — each item lists an explicit implementation
order so improvements land in a dependency-safe sequence.

### Guiding principles

- **Schema before process.** Nothing else is deterministic until the task
  format and lifecycle are defined, so that lands first.
- **Single source of truth.** Every concept (pipeline, priorities, task states)
  is defined in exactly one file; everything else links to it.
- **Wire into the real tool.** Prefer Claude Code's native primitives
  (`.claude/agents/`, `.claude/commands/`, hooks) over inert prose.
- **Stay lean.** Remove ceremony and dead promises rather than adding more roles
  or documents.

### Current baseline (for reference)

```
agents/        architect, business-analyst, developer,
               orchestrator, product-manager, qa-tester
checklists/    code-review, feature, release
prompts/       analyze-competitors, create-roadmap,
               full-agent-workflow, implement-next-task, initialize-project
templates/     project-template/{README,CLAUDE,architecture,
               decisions,qa,roadmap,tasks}.md
examples/      sample-project/   (EMPTY)
README.md
```

Known facts that shape this plan: the repo is **not** a git repository, the
`examples/sample-project` directory is **empty**, and the template hardcodes an
npm/Node toolchain.

---

## Improvement 1 — Task Schema and Task Lifecycle

**Problem**
`templates/project-template/tasks.md` is just `Backlog` / `Completed` with a
single `- [ ] Example task`. There is no defined task structure (ID, priority,
status, acceptance criteria, dependencies, owner) and no status lifecycle. Yet
the entire workflow depends on it: the Orchestrator must "select the next
**approved** task," the BA writes acceptance criteria "into tasks," and the
Developer "reads the next task." The term *approved* is never defined.

**Why it matters**
This is the keystone defect. Without a defined schema and state machine, "select
the next approved task" is interpretation-dependent — different runs pick
different work, and quality gates have nothing concrete to check against. Every
other improvement assumes this structure exists.

**Proposed solution**
- Create `docs/task-schema.md` (new canonical spec) defining:
  - **Fields:** `id`, `title`, `priority` (P1–P4, linked to Improvement 3),
    `status`, `owner`, `dependencies`, `acceptance_criteria`, `notes`.
  - **Status lifecycle (state machine):**
    `backlog → approved → in-progress → blocked → in-review → done`
    (plus `cancelled`), with explicit entry/exit rules for each transition and
    a clear definition of who/what sets `approved`.
- Rewrite `templates/project-template/tasks.md` to demonstrate the schema with
  one fully worked example task and section headers per status.
- Add a short "Task conventions" pointer in the template `CLAUDE.md`.

**Files likely affected**
- `docs/task-schema.md` (new)
- `templates/project-template/tasks.md`
- `templates/project-template/CLAUDE.md`
- `agents/orchestrator.md`, `agents/business-analyst.md`, `agents/developer.md`
  (reference the schema instead of restating ad-hoc)

**Priority:** 🔴 Critical

**Implementation order:** 1 (first — everything depends on it)

---

## Improvement 2 — Single Source of Truth for the Workflow

**Problem**
The same pipeline is described in four places — `README.md`,
`agents/orchestrator.md`, `prompts/full-agent-workflow.md`, and partially in
`prompts/implement-next-task.md`. They already disagree (commit/summary ordering
differs; `implement-next-task.md` silently skips the PM and BA phases).

**Why it matters**
Four representations of one process guarantee drift. A change to the pipeline
today requires editing 3–4 files and reconciling them — exactly the maintenance
trap that produces inconsistent behavior over time.

**Proposed solution**
- Designate `prompts/full-agent-workflow.md` as the **single canonical
  pipeline** (it is already the most complete).
- Reduce `agents/orchestrator.md` and `README.md` to a short summary plus a link
  to the canonical file — no duplicated phase lists.
- Convert `prompts/implement-next-task.md` into a thin alias that invokes the
  canonical flow (or its fast-path variant from Improvement 7) rather than a
  divergent mini-pipeline.

**Files likely affected**
- `prompts/full-agent-workflow.md` (becomes canonical)
- `agents/orchestrator.md`
- `prompts/implement-next-task.md`
- `README.md`

**Priority:** 🔴 Critical

**Implementation order:** 2

---

## Improvement 3 — Unified Priority Framework

**Problem**
Two agents define the priority scale differently:
- Product Manager: P1 *Critical* / P2 *High Value* / P3 *Improvement* / P4 *Future*
- Business Analyst: P1 *Critical* / P2 *High Value* / P3 *Nice to Have* / P4 *Future Consideration*

Same scale, two wordings, two owners, no single source.

**Why it matters**
A shared vocabulary that disagrees with itself on day one corrupts
prioritization — the PM and BA literally label the same priority differently,
and `tasks.md` priorities become ambiguous.

**Proposed solution**
- Define the priority framework once in `docs/priority-framework.md` (or a
  clearly-owned section of the PM agent file) as the authority.
- Have `agents/business-analyst.md` and the task schema **reference** it rather
  than restate it.
- Assign explicit ownership: PM owns the framework and `roadmap.md`; BA applies
  it. This also resolves the PM/BA overlap flagged in the review.

**Files likely affected**
- `docs/priority-framework.md` (new) — or a canonical section in `agents/product-manager.md`
- `agents/business-analyst.md`
- `docs/task-schema.md` (priority field references this)

**Priority:** 🔴 Critical

**Implementation order:** 3

---

## Improvement 4 — Claude Code `.claude` Integration

**Problem**
Claude Code natively loads **subagents** from `.claude/agents/`, **slash
commands** from `.claude/commands/`, and **hooks** from `.claude/settings.json`.
This framework's agents and prompts map almost perfectly onto those primitives
but live in custom folders Claude Code never loads — so everything must be
manually pasted, and quality gates ("never commit failing code") are
honor-system prose with no enforcement.

**Why it matters**
This is the single change that converts inert documentation into an actually
runnable system. It also lets QA/build gates run as real hooks instead of
relying on the model to self-police.

**Proposed solution**
- Add a `.claude/` directory:
  - `.claude/agents/*.md` — adapt the six agent files into proper subagent
    definitions (with frontmatter: name, description, tools).
  - `.claude/commands/*.md` — expose the prompts as slash commands
    (e.g. `/initialize-project`, `/next-task`, `/create-roadmap`).
  - `.claude/settings.json` — optional hooks for test/build gates and
    commit-message standards.
- Keep `agents/` and `prompts/` as human-readable source, OR make `.claude/`
  the source and have the docs link into it — decide one direction to avoid
  re-introducing duplication (ties back to Improvement 2).
- Document the wiring in `README.md`.

**Files likely affected**
- `.claude/agents/*.md` (new, 6 files)
- `.claude/commands/*.md` (new)
- `.claude/settings.json` (new)
- `README.md`
- existing `agents/` and `prompts/` (de-duplicated or relocated)

**Priority:** 🟠 High

**Implementation order:** 4 (after the canonical workflow exists to adapt from)

---

## Improvement 5 — Stack-Agnostic Project Initialization

**Problem**
`templates/project-template/README.md` hardcodes `npm install` / `npm run dev` /
`npm test`, silently assuming a Node/JS project. `prompts/initialize-project.md`
also leans on this. Python, Go, Rust, and monorepo users get wrong commands.

**Why it matters**
The framework markets itself as universal and reusable "across all future
projects," but a non-Node project is broken out of the box. This directly
undercuts the reusability claim.

**Proposed solution**
- Make the template `README.md` stack-agnostic with placeholder command slots
  (`<install>`, `<run>`, `<test>`).
- Strengthen `prompts/initialize-project.md` to **detect** the toolchain during
  discovery (package manager, build/test/run commands) and fill those slots,
  rather than assuming npm.
- Record detected commands in the generated `CLAUDE.md`.

**Files likely affected**
- `templates/project-template/README.md`
- `prompts/initialize-project.md`
- `templates/project-template/CLAUDE.md`

**Priority:** 🟠 High

**Implementation order:** 5

---

## Improvement 6 — Example Project (Populate or Remove)

**Problem**
`examples/sample-project/` is an **empty directory**, yet the README advertises
an `examples` folder. An advertised-but-empty example is a broken promise and a
real onboarding hole.

**Why it matters**
A worked example is the fastest way to teach a workflow system. An empty folder
is worse than none — it signals incompleteness and erodes trust in the rest of
the framework.

**Proposed solution**
- **Preferred:** populate `examples/sample-project/` with a small, realistic,
  stack-agnostic example — a filled `tasks.md` (using the new schema), a
  `decisions.md` with at least one real entry, a `qa.md` with sample results,
  and one task taken through the full pipeline end to end.
- **Fallback (if no time):** delete `examples/sample-project/` and remove the
  `examples` reference from `README.md` so nothing dangles.

**Files likely affected**
- `examples/sample-project/*` (new content) — or directory removal
- `README.md`

**Priority:** 🟡 Medium

**Implementation order:** 6 (depends on the task schema from Improvement 1)

---

## Improvement 7 — Missing Checklists and Fast-Path Workflows

**Problem**
- The full 7-phase pipeline (PM strategy → BA requirements → ... ) runs for
  *every* task, including one-line bug fixes — pure ceremony tax.
- There is no bug/hotfix/incident flow; the pipeline is feature-only.
- Checklists are missing: no **security**, **testing strategy**,
  **definition-of-done**, or **commit/PR standard**.
- `checklists/release-checklist.md` has no owning agent (a Release/DevOps gap).

**Why it matters**
The system is simultaneously over-ceremonied for small work and under-specified
for quality. A fast-path removes waste; the missing checklists close real
quality and security gaps; assigning the release checklist gives every gate an
accountable owner.

**Proposed solution**
- Add a **fast-path workflow** (`prompts/quick-task.md`):
  Architect → Developer → QA only, for bugs/chores/refactors. Define when it
  applies vs. the full pipeline.
- Add missing checklists:
  - `checklists/security-checklist.md`
  - `checklists/testing-strategy.md` (unit/integration/e2e, coverage targets)
  - `checklists/definition-of-done.md`
  - `checklists/commit-pr-standard.md`
- Assign the existing `release-checklist.md` to an owner — either extend an
  agent with Release/DevOps responsibility or note ownership explicitly.

**Files likely affected**
- `prompts/quick-task.md` (new)
- `checklists/security-checklist.md` (new)
- `checklists/testing-strategy.md` (new)
- `checklists/definition-of-done.md` (new)
- `checklists/commit-pr-standard.md` (new)
- `prompts/full-agent-workflow.md` (reference the fast-path branch)
- an agent file (release ownership)

**Priority:** 🟡 Medium

**Implementation order:** 7

---

## Consolidated Implementation Order

| Order | Improvement | Priority | Blocks / Depends on |
|-------|-------------|----------|---------------------|
| 1 | Task schema & lifecycle | 🔴 Critical | Foundation for #3, #6, #7 |
| 2 | Single source of truth for workflow | 🔴 Critical | Prerequisite for #4 |
| 3 | Unified priority framework | 🔴 Critical | Uses task schema (#1) |
| 4 | `.claude` integration | 🟠 High | Adapts canonical workflow (#2) |
| 5 | Stack-agnostic initialization | 🟠 High | Independent |
| 6 | Example project (populate/remove) | 🟡 Medium | Uses task schema (#1) |
| 7 | Checklists & fast-path workflows | 🟡 Medium | References workflow (#2) |

### Suggested phasing

- **Phase A (Critical foundation):** Improvements 1 → 2 → 3.
  Makes the workflow deterministic and internally consistent.
- **Phase B (Make it runnable & portable):** Improvements 4 → 5.
  Turns docs into a real Claude Code system and restores the "universal" claim.
- **Phase C (Completeness & polish):** Improvements 6 → 7.
  Closes the example gap and fills missing quality/fast-path paths.

---

## Out of scope for this plan (deliberately deferred)

- Adding new agent roles beyond the existing six until the current ones are
  wired up and proven (avoid more ceremony, not less).
- The "Future Integrations" list (Notion, Linear, n8n) — keep as roadmap only;
  no code is implied yet.
- Log-rotation/archival for `qa.md` and `decisions.md` — worth doing later, but
  not on the critical path.
- `git init` of this repo and a root `CLAUDE.md` — recommended hygiene, tracked
  separately from the seven prioritized improvements above.
