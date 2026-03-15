# Municeo

Civic participation platform. Specs: @docs/specifications.md | Tasks: @TASKS.md

## Architecture — strict layered dependency

- **Domain** (`src/Domain/`) → pure PHP only. No Symfony/Doctrine imports. Ever.
- **Application** (`src/Application/`) → depends on Domain only.
- **Infrastructure** (`src/Infrastructure/`) → implements Domain interfaces.

Dependency: Domain ← Application ← Infrastructure. Never the reverse.

## Language — English everywhere

IMPORTANT: all code, comments, commit messages, documentation, variable names, class names, and PR descriptions must be written in English. No exception.

All user-facing strings (UI labels, error messages, emails) go through Symfony Translator — never hardcoded in templates or controllers. Translation keys in English, translation files provide localized values. Routes are localized via Symfony's `{_locale}` prefix. The app is multi-tenant and locale-aware.

## Non-obvious rules

- UUID v7 for all entity PKs — never auto-increment
- WilsonScore & CitizenLevel: computed at runtime, never persisted
- Email: AES-256-GCM encrypted at rest, decrypted only at send time, never logged
- All business thresholds from `config/services.yaml` (`municeo.*` parameters), injected via constructor
- `CreateReportHandler` verification order: blocked → rate limit → cooldown → duplicate → create

## Commands

- Tests: `php bin/phpunit`
- Static analysis: `vendor/bin/phpstan analyse` (level 8)
- Code style: `vendor/bin/php-cs-fixer fix`
- Single test: `php bin/phpunit --filter TestClassName`

## Workflow

- After implementing code, run tests and phpstan before considering done
- Update TASKS.md after completing tasks — `[ ]` → `[x]`

## When compacting, preserve

- List of modified files and their paths
- Current phase from PLAN.md
- Any failing test names and error messages
