---
paths:
  - "src/Domain/*/Entity/*.php"
---

# Entities

- UUID v7 PK — never auto-increment
- State changes via named methods, not public setters
- Transitions validated inside entity — throw `InvalidTransitionException`
- Record domain events: `$domainEvents[]` array + `pullDomainEvents(): array`
- No Doctrine attributes — mapping in Infrastructure
