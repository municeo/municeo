# Municeo — Agent Guidelines

## Project

Municeo is a civic participation platform (PHP 8.5+ / Symfony 8.0+ / PostgreSQL 18+ / PostGIS).
Specs: `docs/specifications.md` | Plan: `PLAN.md` | Tasks: `TASKS.md`

## Architecture

Three layers — never bypass:
- **Domain** (`src/Domain/`) — Pure PHP. No framework imports. Entities, VOs, Events, Exceptions, Repository interfaces.
- **Application** (`src/Application/`) — Commands, Handlers, Queries. Depends on Domain only.
- **Infrastructure** (`src/Infrastructure/`) — Doctrine, Controllers, Mercure, Mailer, Messenger. Implements Domain interfaces.

Dependency rule: Domain ← Application ← Infrastructure. Never the reverse.

## Golden Rules

1. **Domain purity** — No Symfony/Doctrine annotations in Domain. Use PHP 8 attributes for mapping only in Infrastructure.
2. **UUID v7** — All entity PKs use UUID v7 (`uuid_create(UUID_TYPE_TIME)`). Never auto-increment.
3. **Enums as backed enums** — All enums are `string` or `int` backed. Use native PHP 8.1+ enums.
4. **ValueObjects are immutable** — All VOs are `readonly class` or have only getters. No setters.
5. **Events over direct coupling** — Cross-bounded-context communication via domain events.
6. **WilsonScore & CitizenLevel never persisted** — Always computed at runtime.
7. **Email always encrypted** — AES at rest, decrypted only at send time, never logged in clear.
8. **One handler per command** — No god handlers. Each handler does one thing.
9. **Configurable thresholds** — All magic numbers come from `services.yaml` parameters, injected via constructor.
10. **French domain terms** — Code in English, but domain concepts keep French names where specified (CitizenLevel values, route paths).

## Code Standards

- PHP 8.5+ features: readonly classes, enums, match expressions, named arguments, fibers where applicable
- Strict types: `declare(strict_types=1);` in every file
- PSR-12 coding style
- PHPStan level 8
- No `@var` docblocks when types are inferrable
- Final classes by default (except entities needing Doctrine proxies)
- Constructor promotion for all services and VOs

## Testing

- Domain: pure unit tests, no mocks needed
- Application: unit tests with mocked repository interfaces
- Infrastructure: integration tests with test database
- Controllers: functional tests (WebTestCase)
- No test pollution: each test is independent

## File Naming

- Entities: `src/Domain/{Context}/Entity/{Name}.php`
- VOs: `src/Domain/{Context}/ValueObject/{Name}.php`
- Events: `src/Domain/{Context}/Event/{Name}.php`
- Commands: `src/Application/{Context}/Command/{Name}.php`
- Handlers: `src/Application/{Context}/Handler/{Name}Handler.php`
- Controllers: `src/Infrastructure/Http/Controller/{Area}/{Name}Controller.php`
- Repositories: `src/Infrastructure/Persistence/Doctrine/Repository/Doctrine{Name}Repository.php`

## Before Committing

- Run `php bin/phpunit` — all tests must pass
- Run `vendor/bin/phpstan analyse` — no errors at level 8
- Run `vendor/bin/php-cs-fixer fix --dry-run` — no style violations
- Update `TASKS.md` — mark completed tasks with `[x]`
