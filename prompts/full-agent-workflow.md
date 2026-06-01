# Full Agent Workflow

> **This is the canonical workflow definition.** It is the single source of
> truth for the phase-by-phase delivery process. All other files (README.md,
> the Orchestrator agent, other prompts, project templates) reference this file
> rather than restating the phases, so the process is defined in exactly one
> place.

## Objective

Execute the next approved task using the complete AI delivery workflow.

## Process

> Task records, statuses, the meaning of "approved", priority levels,
> acceptance criteria, dependencies, blocked tasks, the Definition of Done, and
> next-task selection are all defined in `docs/task-schema.md`. This workflow
> operates on tasks as defined there.

### Phase 0 - Product Management

Act as Product Manager.

- Read roadmap.md
- Read tasks.md
- Confirm task priority
- Confirm business value
- Confirm the task is worth executing now
- Stop if the task is not approved or not valuable

### Phase 1 - Business Analysis

Act as Business Analyst.

- Verify requirements
- Verify acceptance criteria
- Refine requirements if necessary
- Identify missing user-facing details
- Confirm the task is implementation-ready

### Phase 2 - Architecture

Act as Architect.

- Review architecture.md
- Review decisions.md
- Evaluate implementation impact
- Identify affected components
- Update architecture.md if required
- Update decisions.md if required

### Phase 3 - Development

Act as Developer.

- Read CLAUDE.md
- Implement only the selected task
- Follow project conventions
- Keep changes minimal and maintainable
- Do not expand scope

### Phase 4 - Quality Assurance

Act as QA Tester.

- Execute relevant tests
- Execute build validation
- Check acceptance criteria
- Check regressions
- Check edge cases
- Record findings in qa.md

### Phase 5 - Documentation

Update if required:

- CLAUDE.md
- roadmap.md
- architecture.md
- decisions.md
- qa.md
- tasks.md

### Phase 6 - Delivery

Produce:

- Summary of changes
- Files modified
- Test results
- Documentation updates
- Risks identified
- Recommended next task

### Phase 7 - Commit

If successful:

- Mark task completed in tasks.md
- Create clear commit message
- Commit changes

## Rules

- One task per execution
- Never skip testing
- Never skip documentation updates
- Never commit failing code
- Never expand scope without approval
- Stop if blocked and explain why