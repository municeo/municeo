---
name: create-entity
description: Create a domain entity with UUID v7, domain events, and state transitions
argument-hint: <Context> <EntityName>
disable-model-invocation: true
---

Create domain entity `src/Domain/$0/Entity/$1.php`:

1. Add `declare(strict_types=1);` and namespace
2. Use `readonly` properties where possible, UUID v7 as PK
3. Add `$domainEvents` array and `pullDomainEvents(): array` method
4. State changes through named methods — no public setters
5. Validate transitions, throw `InvalidTransitionException` on illegal ones
6. No Doctrine/Symfony imports — pure PHP only
7. Create test `tests/Domain/$0/Entity/$1Test.php`
8. Update TASKS.md — mark entity as `[x]`
