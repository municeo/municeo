# Run All Checks

Run the full quality check suite before committing.

## Steps
1. Run `php bin/phpunit` — all tests must pass
2. Run `vendor/bin/phpstan analyse` — level 8, no errors
3. Run `vendor/bin/php-cs-fixer fix --dry-run --diff` — no style violations
4. If any check fails, fix the issues before proceeding
5. Report results summary
