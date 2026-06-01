# QA Log

## Test Results

### QA-001 — T-001 Shorten a URL (2026-05-21)

- Build: pass
- Tests: pass (6 passed)
- Acceptance criteria: all three verified
- Edge cases checked: empty body, malformed URL, duplicate URL (stable code),
  very long URL
- Result: **PASS** — Definition of Done met.

## Known Issues

- Low: URLs longer than 2048 characters are accepted without a max-length check.
  Logged as low severity; candidate for a future task.

## Risks

- No rate limiting yet; abuse is possible once the service is public.

## Recommendations

- Add input length validation and rate limiting before a public launch.
