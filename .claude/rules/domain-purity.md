---
paths:
  - "src/Domain/**/*.php"
---

# Domain Layer

- ZERO framework imports — no `use Doctrine\...`, no `use Symfony\...`
- Only pure PHP: enums, readonly classes, interfaces, exceptions
- Repository interfaces here, implementations in Infrastructure
- No Doctrine mapping attributes — mapping lives in Infrastructure only
