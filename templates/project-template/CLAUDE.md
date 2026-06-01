# Project Rules

## Principles

- Simplicity first
- One task at a time
- Test before commit
- Update documentation

## Commands

The project's actual commands, detected during `initialize-project`. No stack is
assumed; fill these with whatever this project really uses. Leave a placeholder
and note it if a command does not apply.

- Install: <install command>
- Run: <run command>
- Test: <test command>
- Build: <build command, if any>
- Lint: <lint command, if any>

## Workflow

Follow the canonical workflow in `prompts/full-agent-workflow.md`. It is the
single source of truth for the delivery process; do not redefine the phases
elsewhere.

## Documentation

Maintain:

- roadmap.md
- architecture.md
- decisions.md
- qa.md
- tasks.md

## Task Conventions

Tasks in `tasks.md` follow the canonical task schema and lifecycle defined in
`docs/task-schema.md`: task ID format, statuses, priority levels, acceptance
criteria, dependencies, blocked-task format, the Definition of Done, and how the
next task is selected. A task is "approved" when its `Status` field is
`approved` (set by the Product Manager). Defer to that file for all task rules.

## Quality

- No failing builds
- No failing tests
- No undocumented architecture changes