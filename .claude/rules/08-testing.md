# Testing

Applies to: `tests/**/*.php`

- Mirror `src/` structure: `tests/Domain/`, `tests/Application/`, `tests/Infrastructure/`
- Domain tests: pure unit tests, no mocks, no database
- Application tests: mock repository interfaces, test handler logic
- Infrastructure tests: integration tests with real PostgreSQL + PostGIS test database
- Controller tests: Symfony WebTestCase, test HTTP status codes and redirects
- Each test class extends `PHPUnit\Framework\TestCase` (or `WebTestCase` for functional)
- Test method names: `test_<behavior_description>` (snake_case)
- One assertion concept per test method
- Use data providers for parameterized tests (thresholds, levels, transitions)
