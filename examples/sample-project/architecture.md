# Architecture

## Overview

Linkly is a minimal URL shortener: a small HTTP API backed by a single-file
database. One service, no external dependencies.

## Components

- **API layer** (FastAPI) — handles `POST /shorten` and `GET /{code}`.
- **Short-code generator** — produces a stable short code for a given URL.
- **Storage module** — reads/writes URL mappings; backed by SQLite.

## Data Flow

1. Client posts a long URL to `/shorten`.
2. The generator returns a short code; the mapping is saved via the storage module.
3. Client requests `/{code}`; the storage module resolves the original URL and
   the API redirects to it.

## Integrations

None.

## Constraints

- Single-node deployment.
- Storage choice and its trade-offs are recorded in decisions.md (D-001).
