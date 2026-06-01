# Final Architecture Review — AI-Workflow-System

*Fresh review of the repository as it exists today. The original review and
improvement plan are intentionally set aside; this judges the current state on
its own merits.*

---

## Snapshot of the current system

```
.claude/agents/      6 thin subagent wrappers  → point to agents/*.md
.claude/commands/    5 thin command wrappers    → point to prompts/*.md
agents/              6 canonical role definitions
prompts/             5 prompts (full-agent-workflow.md is canonical)
checklists/          3 (feature, code-review, release)
docs/task-schema.md  canonical task schema + lifecycle + selection
templates/           project-template/ (7 standard files)
examples/            sample-project/ "Linkly" (7 files, one task run end-to-end)
README.md            framework overview (257 lines)
improvement-plan.md  completed historical plan (328 lines)
```

This is a real, usable system now — not a pile of prose. The structural spine
(canonical task schema, one canonical workflow, unified priorities, `.claude`
integration, a worked example, stack-agnostic init) is sound.

---

## Assessment by focus area

**Practicality — strong.** It runs in Claude Code via `/workflow`, `/next-task`,
etc. A worked example demonstrates the artifacts. The main practical gap is
*distribution*: a brand-new external project can't easily obtain the schema,
workflow, and agents (see "Missing capabilities").

**Simplicity — good, with creeping repetition.** The core docs are lean. But the
README now lists the six agents in **three** places (Folder Structure, Agents
section, Claude Code Integration) and restates each role's responsibilities,
duplicating `agents/*.md`. There are also three ways to express orchestration
(the orchestrator agent, the orchestrator subagent, and the `/workflow` command).

**Reusability — good.** Template + `.claude` + stack-agnostic init make reuse
realistic. The thin-wrapper path dependency is the one fragility (copying
`.claude/` alone breaks the pointers).

**Claude Code usability — much improved.** Subagents and commands register
natively. Cost: every wrapper adds an indirection hop ("read `agents/X.md` and
follow it"), which relies on the model actually opening the pointed-to file and
on those files being present at the repo root.

**Long-term maintainability — improved, single sources of truth now exist.**
Remaining drift surfaces: README role text vs `agents/`; agent set listed 3×;
the Definition of Done living in both `docs/task-schema.md` and
`feature-checklist.md`; the schema, template, and example must change in lockstep.

**Documentation quality — clear but the README is bloated.** `docs/task-schema.md`
is excellent (precise, complete, well-anchored). The example is well
cross-referenced. The README, at 257 lines with overlapping sections, is the
weakest doc. Two prompts (`create-roadmap.md`, `analyze-competitors.md`) are so
thin they add little over their command wrappers.

**Workflow quality — solid core, one real weakness.** `full-agent-workflow.md`
is a clean 8-phase canonical pipeline. The weakness: it is the *only* path, so a
one-line bug fix still nominally runs PM strategy and BA requirements phases.
That ceremony tax is the biggest remaining workflow issue.

**Agent design — clean roles, one vestigial.** PM/BA/Architect/Developer/QA are
well-scoped and no longer overlap. The **Orchestrator** is awkward under Claude
Code: subagents can't dispatch other subagents, so the orchestrator subagent
can't actually orchestrate — `/workflow` on the main thread is the real
orchestrator. The orchestrator role is partly redundant.

**Project initialization experience — good.** `/initialize-project` is
stack-agnostic, detection-driven, and fills the README/CLAUDE command slots.
Gap: it generates a project's docs but those docs reference framework files
(`full-agent-workflow.md`, `docs/task-schema.md`) that won't exist in an
external project unless the framework is vendored in.

**Example project quality — good and lean.** "Linkly" shows the lifecycle
(`done` → `approved`-with-satisfied-dependency → `backlog`), a real decision
record, and a QA record, on a non-Node stack. It is illustrative, not runnable
(acceptable, and stated). Its `CLAUDE.md` references framework files that don't
resolve from the example directory — the same vendoring question in miniature.

---

## Remaining weaknesses

1. **Distribution story is undefined** — the highest-impact gap. Nothing explains
   how an external project gets the schema/workflow/agents so its generated
   `CLAUDE.md` references resolve.
2. **README bloat and triple agent listing**, with role responsibilities
   duplicated from `agents/` (drift risk).
3. **`improvement-plan.md` is stale history at the repo root** — the largest file
   after the README, describing already-completed work; misleads newcomers into
   thinking work is pending.
4. **Single-path workflow** — no lightweight track for small/bug tasks.
5. **No enforcement** — "never commit failing code" / "tests pass" remain
   honor-system; the model self-polices.
6. **Definition of Done duplicated** (schema vs `feature-checklist.md`).
7. **"Critical" is overloaded** — P1 task priority vs QA defect severity.
8. **No root `CLAUDE.md` for the framework itself**, and the repo is not a git
   repo though every workflow ends in "commit."

## Overengineering

- **Three representations of orchestration** (orchestrator agent + orchestrator
  subagent + `/workflow`). One is enough.
- **Three lists of the same six agents** in the README.
- **8-phase pipeline applied uniformly**, including to trivial changes.
- Two near-empty prompts (`create-roadmap.md`, `analyze-competitors.md`) sitting
  between the agent definitions and the command wrappers.

## Redundant files

- `improvement-plan.md` (completed; belongs in history, not the active root).
- `prompts/create-roadmap.md` and `prompts/analyze-competitors.md` — thin enough
  to fold into the PM/BA agents, with commands pointing straight there.
- The orchestrator **subagent** (`.claude/agents/orchestrator.md`) — cannot
  orchestrate; `/workflow` covers the real need.

## Missing capabilities

- **Adoption/vendoring path + a quickstart** ("how do I use this on my project?").
- **Fast-path workflow** for bugs/chores.
- **Project-level quality-gate scaffolding** (a template `.claude/settings.json`
  with hooks a real project can fill in).
- A standalone, de-duplicated **Definition of Done** and possibly a
  **security/testing-strategy** checklist — but only if a real need appears
  (see Q4; resist doc sprawl).
- A **root `CLAUDE.md`** so the framework dogfoods its own convention.

## Remaining risks

- **Path indirection** in `.claude` wrappers breaks if `.claude/` is copied
  without `agents/`, `prompts/`, `docs/`.
- **Drift** between README role text and `agents/`.
- **Unverified gates** — quality depends on the model honestly running and
  reading test/build output.
- **Lockstep maintenance** of schema ↔ template ↔ example.

---

## Answers to the five questions

### 1. What would you remove?

- **`improvement-plan.md` from the active root** — archive it (e.g. move to
  `docs/history/`) or delete it. It is completed history and currently the
  second-largest file, implying pending work that doesn't exist.
- **The orchestrator subagent** (`.claude/agents/orchestrator.md`) — it can't
  dispatch other subagents, so it misrepresents how orchestration works.
  Keep `/workflow` as the orchestration entry point.
- **The README's redundant agent listings** — collapse three lists into one.
- *(Candidate, not mandatory)* fold `create-roadmap.md` and
  `analyze-competitors.md` into the PM/BA agents.

### 2. What would you simplify?

- **The README** — collapse to one agent list, replace the per-role
  responsibility blocks with a pointer to `agents/`, and trim overlapping
  sections. Target a much shorter overview.
- **The orchestration model** — designate `/workflow` as the one orchestration
  path; demote the orchestrator from "agent that invokes agents" to a conceptual
  note inside the canonical workflow.
- **Definition of Done** — make `feature-checklist.md` reference the schema's DoD
  rather than restate it.

### 3. What would you keep unchanged?

- **`docs/task-schema.md`** — the strongest artifact in the repo; precise,
  complete, well-anchored. Do not touch.
- **`prompts/full-agent-workflow.md`** as the single canonical workflow.
- **The `.claude` thin-wrapper pattern** — the right balance of native usability
  and single source of truth.
- **The example project** — lean, coherent, correctly cross-referenced.
- **Stack-agnostic initialization** and the **unified priority framework**.

### 4. Is Improvement 7 still necessary?

**Partially — split it.**
- **Fast-path workflow: yes, do it.** It addresses the single biggest remaining
  workflow weakness (uniform heavy ceremony). High value, low risk.
- **The pile of new checklists (security, testing-strategy, commit/PR, standalone
  DoD): mostly no / defer.** Adding more checklists now risks the exact
  doc-sprawl this review flags. Do only the **DoD consolidation** (remove
  duplication) and add a security/testing checklist *only when a concrete project
  needs it*. Don't add them speculatively.

So Improvement 7 is necessary only in its fast-path half; its checklist half
should be trimmed to "consolidate DoD" and otherwise deferred.

### 5. What should be the next highest-value improvement?

**Define the adoption / distribution path (with a quickstart).** This is the top
practical blocker to the framework's stated goal of being reusable "across all
future projects." Today a generated project's `CLAUDE.md` points at framework
files that won't exist outside this repo. Concretely:

- Make `/initialize-project` **vendor the needed framework files** into the
  target project (at minimum `docs/task-schema.md`, `prompts/full-agent-workflow.md`,
  and a `.claude/` set), or have the generated references point at an
  installed/known location.
- Add a short **Quickstart** ("clone/copy this, run `/initialize-project`, then
  `/next-task`") to the README.

Rank: **(1) Distribution + quickstart**, **(2) Fast-path workflow** (the useful
half of Improvement 7), **(3) README/orchestration simplification**.

---

## Overall verdict

The system has moved from "documentation that describes a workflow" to "a
workflow Claude Code can actually run," with clean single sources of truth and a
teaching example. It is genuinely good now. The remaining work is mostly
**subtractive** (trim README, remove stale plan, drop the redundant orchestrator
path) plus **one additive** essential — a real adoption story so the framework
works *outside its own repo*. Avoid adding more documents; the next wins come
from making what exists thinner and portable, not from more checklists.
