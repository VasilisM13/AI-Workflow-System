# Initialize Project

## Objective

Set up a new software project so Claude Code can work on it using the AI Workflow System.

## Prerequisite

The framework files must already be present in the project (`.claude/`,
`agents/`, `prompts/`, `checklists/`, `docs/task-schema.md`). If they are not,
copy them in first — see `docs/adoption.md`. This command generates the
project's working docs; it assumes the framework files are in place so that
generated references resolve.

## Instructions

Read the project folder and initialize the standard AI workflow files.

## Required Files

Create or update:

* CLAUDE.md
* tasks.md
* roadmap.md
* architecture.md
* decisions.md
* qa.md
* README.md

## Process

### 1. Project Discovery

* Inspect the folder structure
* Identify the technology stack
* Detect the actual toolchain — do not assume any specific stack (e.g. npm).
  Determine the real install, run, test, build, and lint commands from the
  project itself (e.g. package.json, pyproject.toml/requirements.txt, go.mod,
  Cargo.toml, Makefile, Gemfile, build files, CI config).
* Identify existing documentation
* Identify git status

### 2. Project Rules

Create or update CLAUDE.md with:

* Project purpose
* Tech stack
* Commands (the detected install / run / test / build / lint commands — fill
  the Commands section; never assume npm or any other default)
* Coding conventions
* Documentation rules
* Commit rules

Also fill the Setup placeholders in README.md (`<install command>`,
`<run command>`, `<test command>`) with the detected commands. If a command
cannot be determined, leave the placeholder and note that it is unknown.

### 3. Roadmap

Create or update roadmap.md with:

* Product vision
* Current objectives
* Short-term priorities
* Future opportunities

### 4. Architecture

Create or update architecture.md with:

* System overview
* Main components
* Data flow
* External integrations
* Important constraints

### 5. Decisions

Create or update decisions.md with:

* Existing architectural decisions
* Technology choices
* Known tradeoffs

### 6. QA

Create or update qa.md with:

* Test strategy
* Build validation
* Known risks
* Manual testing checklist

### 7. Tasks

Create or update tasks.md with:

* Immediate setup tasks
* Missing documentation tasks
* High-priority implementation tasks
* QA tasks

## Rules

* Do not change application code
* Do not delete existing documentation
* Do not commit unless asked
* Ask before making assumptions that affect architecture
* Do not assume a specific stack or default commands; detect and record the
  project's actual commands
* Keep all generated files practical and project-specific

## Deliverables

* Updated AI workflow files
* Summary of detected tech stack
* Summary of available commands
* Recommended next task