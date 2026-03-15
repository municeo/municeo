---
paths:
  - "src/Domain/**/*.php"
---

# Domain Purity

- No Symfony, Doctrine, or any framework import
- No `use Doctrine\...` or `use Symfony\...`
- Only pure PHP: enums, readonly classes, interfaces, exceptions
- Repository interfaces defined here, implementations in Infrastructure
- Domain services depend only on domain interfaces
- All classes: `declare(strict_types=1);`
