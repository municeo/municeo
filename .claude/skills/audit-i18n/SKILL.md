---
name: audit-i18n
description: Audit the codebase for internationalization violations — hardcoded strings, missing translations, route issues
context: fork
agent: Explore
---

Audit the codebase for i18n compliance. Reference: `.claude/rules/i18n.md`

## Checks to perform

1. **Twig templates** — Scan `templates/**/*.twig` for user-facing text not wrapped in `|trans` or `trans()`. Flag any raw French or English strings in HTML content areas (not in Twig tags, attributes, or comments).

2. **PHP controllers** — Scan `src/Infrastructure/Http/Controller/**/*.php` for:
   - `addFlash()` calls with hardcoded strings instead of translation keys
   - `Response` / `JsonResponse` with hardcoded user-facing messages
   - Exception messages meant for users that aren't translated at the edge

3. **Email templates** — Scan `templates/emails/**/*.twig` for hardcoded subjects or body text not using translator.

4. **Translation files** — Check `translations/` for:
   - Keys present in one locale but missing in another
   - Empty translation values
   - Inconsistent key naming (should be dot-separated English)

5. **Routes** — Check controllers for:
   - Hardcoded French route paths (should use English paths + route translation)
   - Missing `{_locale}` prefix in route configuration

6. **Domain layer** — Verify `src/Domain/**/*.php` exception messages are in English (not French).

## Output

Report findings grouped by category. For each violation:
- File path and line number
- What's wrong
- How to fix it (specific code suggestion)

If no violations found, confirm compliance.
