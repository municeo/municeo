# Entities

Applies to: `src/Domain/*/Entity/*.php`

- UUID v7 as PK on all entities — never auto-increment
- Entity state changes through named methods (not public setters)
- Status transitions validated inside the entity (`Report::validate()`, `Report::reject()`, etc.)
- Throw `InvalidTransitionException` on illegal state changes
- Record domain events via `$this->domainEvents[]` array and `pullDomainEvents(): array` method
- `Report`: unique constraint on `(user_id, report_id)` for votes is declared but enforced at persistence level
- `User`: `blocked_until` nullable, `deleted_at` nullable (soft delete)
- No Doctrine attributes here — mapping is in Infrastructure (XML or separate PHP attributes)
