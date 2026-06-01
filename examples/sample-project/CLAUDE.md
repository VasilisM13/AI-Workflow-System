# Project Rules

## Principles

- Simplicity first
- One task at a time
- Test before commit
- Update documentation

## Commands

The project's actual commands (detected during initialization).

- Install: pip install -r requirements.txt
- Run: uvicorn app.main:app --reload
- Test: pytest
- Build: (none — interpreted)
- Lint: ruff check .

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
`docs/task-schema.md`. A task is "approved" when its `Status` field is
`approved` (set by the Product Manager). Defer to that file for all task rules.

## Coding Conventions

- Python; formatted and linted with ruff.
- Type hints on public functions.

## Quality

- No failing builds
- No failing tests
- No undocumented architecture changes
