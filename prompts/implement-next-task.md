# Implement Next Task

Read tasks.md.

Select the next approved unfinished task using the deterministic selection
logic in docs/task-schema.md (the "Deterministic task selection" section):
among tasks with Status `approved` whose dependencies are all `done`, pick the
highest priority, breaking ties by lowest task ID. If none qualify, stop and
explain why.

Then execute that task using the canonical workflow in
prompts/full-agent-workflow.md. Do not use a separate or reduced set of phases.

> Note: a lighter fast-path for small tasks (e.g. Architect → Developer → QA
> only) is planned in Improvement 7. Until it exists, this command runs the full
> canonical workflow.
