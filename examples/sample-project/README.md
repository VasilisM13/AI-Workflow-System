# Linkly (Example Project)

> **Illustrative sample for the AI Workflow System.** It shows the standard
> project files and one task (`T-001`) carried through the full workflow from
> approval to `done`. It is a teaching example, not a runnable application.

## Overview

Linkly is a minimal URL shortener: shorten a long URL to a short code, then
redirect that code back to the original URL.

## Goals

- Shorten long URLs to short codes
- Redirect short codes to the original URL
- Stay simple and self-hostable

## Technology Stack

- Frontend: none (HTTP API only)
- Backend: Python (FastAPI)
- Database: SQLite
- Infrastructure: single-node

## Architecture

See architecture.md for detailed system design.

## Setup

> These are filled in (not placeholders) to show what a project looks like after
> `initialize-project` detects the toolchain.

### Install

pip install -r requirements.txt

### Run

uvicorn app.main:app --reload

### Test

pytest

## Documentation

- CLAUDE.md
- roadmap.md
- architecture.md
- decisions.md
- qa.md
- tasks.md

## Development Workflow

At a glance: Product Manager → Business Analyst → Architect → Developer →
QA Tester. The full process is the canonical workflow,
`prompts/full-agent-workflow.md`.

## Current Status

`T-001` (shorten a URL) is **done**. `T-002` (redirect) is **approved** and is
the next task selection would pick.

## Roadmap

See roadmap.md.

## Tasks

See tasks.md.
