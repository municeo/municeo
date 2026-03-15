---
name: audit-architecture
description: Audit the codebase for architecture and pattern violations — layer dependencies, SOLID, domain purity, DTOs
context: fork
agent: Explore
---

Audit the codebase for architecture and pattern compliance. Reference rules in `.claude/rules/`.

## Checks to perform

### Layer dependencies
- `src/Domain/**/*.php` must NOT import `Doctrine\*`, `Symfony\*`, or `Infrastructure\*`
- `src/Application/**/*.php` must NOT import `Infrastructure\*`, `Doctrine\*`, or `Symfony\Component\HttpFoundation\*`
- Only `src/Infrastructure/` may import framework classes

### Domain purity
- Entities in `src/Domain/*/Entity/` must NOT have Doctrine ORM attributes
- Value objects must be `readonly class` with `equals()` method
- Enums must be backed (`string` or `int`)
- Domain events must be `readonly class` with no behavior methods

### DTO purity
- Commands in `src/Application/*/Command/` must have only `__construct`
- Queries in `src/Application/*/Query/` must have only `__construct`
- No inheritance on DTOs — all must be `final readonly class`
- DTOs must not carry Value Objects — only primitives

### SOLID violations
- **SRP**: Flag handlers with more than one public method (besides `__invoke`)
- **DIP**: Flag Application handlers that depend on concrete Infrastructure classes
- **OCP**: Flag handlers that contain notification/email logic directly instead of via events

### Code standards
- Every PHP file in `src/` and `tests/` has `declare(strict_types=1);`
- No hardcoded magic numbers in handlers (thresholds must come from constructor params)
- Controllers are thin — flag any with business logic (repository calls, status checks)

### Entity patterns
- State transitions via named methods, not public setters
- Domain events recorded via `pullDomainEvents()` pattern
- UUID v7 for PKs — no auto-increment

## Output

Report findings grouped by category with severity (error/warning). For each:
- File path and line number
- Rule violated (with reference to `.claude/rules/` file)
- How to fix it

If fully compliant, confirm with a summary of files checked.
