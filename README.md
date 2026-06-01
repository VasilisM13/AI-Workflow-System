# AI Workflow System

## Overview

The AI Workflow System is a reusable framework for managing software projects with AI agents.

Its purpose is to provide a consistent structure, documentation standard, workflow, and execution model that can be reused across all future projects.

The system is designed to work with Claude Code and other AI tools.

---

## Quickstart

To use this framework in your own project:

1. **Copy the framework files** (`.claude/`, `agents/`, `prompts/`,
   `checklists/`, `docs/task-schema.md`) into your project root, preserving the
   layout so all references resolve.
2. Open the project in Claude Code and run **`/initialize-project`** to generate
   the project's working docs (CLAUDE.md, tasks.md, roadmap.md, …).
3. Run **`/next-task`** or **`/workflow`** to start delivering tasks.

Full copy commands and details are in
[docs/adoption.md](docs/adoption.md).

---

## Objectives

* Standardize project setup
* Standardize documentation
* Standardize task execution
* Improve code quality
* Improve maintainability
* Reduce project startup time
* Enable autonomous AI workflows

---

## Agent Roles

### Product Manager

Responsible for:

* Product strategy
* Roadmap management
* Prioritization
* Business value assessment

### Business Analyst

Responsible for:

* Requirements gathering
* Competitor analysis
* User stories
* Acceptance criteria

### Architect

Responsible for:

* System design
* Technical decisions
* Architecture governance

### Developer

Responsible for:

* Implementation
* Testing
* Documentation updates
* Commits

### QA Tester

Responsible for:

* Validation
* Regression testing
* Quality assurance

### Orchestrator

Responsible for:

* Coordinating all agents
* Managing workflow execution
* Ensuring successful delivery

---

## Folder Structure

AI-Workflow-System

* .claude (Claude Code integration: agents + slash commands)
* agents
* checklists
* docs
* examples
* prompts
* templates
* README.md

---

## Agents

The agents folder contains reusable agent definitions.

* product-manager.md
* business-analyst.md
* architect.md
* developer.md
* qa-tester.md
* orchestrator.md

---

## Prompts

The prompts folder contains reusable workflows.

* initialize-project.md
* create-roadmap.md
* analyze-competitors.md
* implement-next-task.md
* full-agent-workflow.md — **canonical workflow** (single source of truth for the delivery process)

---

## Checklists

The checklists folder contains quality-control standards.

* feature-checklist.md
* code-review-checklist.md
* release-checklist.md

---

## Task Schema

The docs folder contains the canonical task definition.

* docs/task-schema.md — task ID format, statuses, priority levels, acceptance
  criteria, dependencies, blocked-task format, Definition of Done, and
  deterministic next-task selection. All files that mention tasks defer to it.

---

## Claude Code Integration

The `.claude` folder makes this framework usable directly in Claude Code — no
copy/paste required. Open the repository (or copy `.claude` into a project) and
Claude Code automatically loads:

**Subagents** (`.claude/agents/`) — one per role:

* product-manager
* business-analyst
* architect
* developer
* qa-tester
* orchestrator

**Slash commands** (`.claude/commands/`):

* `/workflow` — run the canonical end-to-end delivery workflow
* `/next-task` — select and implement the next approved task
* `/initialize-project` — set up the standard workflow files in a project
* `/create-roadmap` — create or update the roadmap
* `/analyze-competitors` — competitor analysis into new tasks

These files are **thin adapters**: each one points to the canonical source it
wraps (`agents/*.md`, `prompts/*.md`, `docs/task-schema.md`) rather than copying
its content, so there is still a single source of truth. Edit the source files;
the `.claude` wrappers follow automatically.

Quality-gate hooks (e.g. "block commit if tests fail") are intentionally **not**
configured here — they are project-specific (this framework repo has no build or
tests to gate). Add them in a concrete project's own `.claude/settings.json`.

---

## Example

A worked example lives in `examples/sample-project` — a minimal URL shortener
("Linkly") showing the standard files and one task (`T-001`) carried through the
full workflow to `done`, with the next task (`T-002`) approved and a backlog
task (`T-003`). Read it to see the task schema, decision log, and QA log in use
on a real (non-Node) stack.

---

## Project Template

Every project should begin from the project-template folder.

Required project files:

* README.md
* CLAUDE.md
* roadmap.md
* architecture.md
* decisions.md
* qa.md
* tasks.md

---

## Standard Workflow

At a glance: Product Manager → Business Analyst → Architect → Developer →
QA Tester → Delivery, coordinated by the Orchestrator.

The full phase-by-phase process is defined in one place — the canonical
workflow at [prompts/full-agent-workflow.md](prompts/full-agent-workflow.md).
This summary is intentionally high-level; do not duplicate the phase details
here.

---

## Core Principles

* One task at a time
* Test before commit
* Update documentation continuously
* Record architectural decisions
* Maintain project memory
* Never commit failing code
* Prefer simple solutions
* Minimize technical debt

---

## Typical Project Lifecycle

This is the coarse project-level arc. Per-task execution (steps 5–8) is carried
out by the canonical workflow in
[prompts/full-agent-workflow.md](prompts/full-agent-workflow.md), not redefined
here.

1. Initialize project
2. Create roadmap
3. Analyze requirements
4. Create tasks
5. Implement features
6. Test changes
7. Update documentation
8. Commit changes
9. Release

---

## Future Integrations

* Claude Code
* GitHub
* MCP Servers
* Notion
* Linear
* n8n

---

## Goal

Create a repeatable AI-powered software delivery system that can be reused across all future projects.
