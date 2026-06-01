# Architecture Decision Log

## Decision Template

Date:
Decision:
Reason:
Impact:

---

## D-001 — Use SQLite for storage

Date: 2026-05-20
Decision: Store URL mappings in a single SQLite database file.
Reason: The service is small and single-node; SQLite removes operational
overhead and is sufficient for the expected volume.
Impact: No separate database service to run. A later move to Postgres is
isolated behind the storage module, so it would not affect the API layer.
Recorded during the Architecture phase of T-001.
