---
name: run-checks
description: Run the full quality check suite (tests, static analysis, code style)
disable-model-invocation: true
---

Run all checks in order, stop on first failure:

1. `php bin/phpunit` — all tests must pass
2. `vendor/bin/phpstan analyse` — level 8, no errors
3. `vendor/bin/php-cs-fixer fix --dry-run --diff` — no style violations

If any check fails, fix the issues before proceeding. Report a summary of results.
