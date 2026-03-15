---
paths:
  - "tests/**/*.php"
---

# Testing

- Mirror `src/` structure: `tests/Domain/`, `tests/Application/`, `tests/Infrastructure/`
- Domain: pure unit tests — no mocks, no database
- Application: mock repository interfaces
- Infrastructure: integration with real PostgreSQL + PostGIS
- Controllers: WebTestCase
- Method names: `test_<behavior>` (snake_case)
- Use data providers for thresholds, levels, transitions
