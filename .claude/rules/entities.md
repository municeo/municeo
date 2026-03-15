---
paths:
  - "src/Domain/*/Entity/*.php"
---

# Entities

- UUID v7 as PK on all entities — never auto-increment
- Entity state changes through named methods (not public setters)
- Status transitions validated inside the entity (`Report::validate()`, `Report::reject()`, etc.)
- Throw `InvalidTransitionException` on illegal state changes
- Record domain events via `$this->domainEvents[]` array and `pullDomainEvents(): array` method
- `User`: `blocked_until` nullable, `deleted_at` nullable (soft delete)
- No Doctrine attributes here — mapping is in Infrastructure (XML or separate PHP attributes)
