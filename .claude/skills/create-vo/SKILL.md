---
name: create-vo
description: Create an immutable domain value object with validation
argument-hint: <Context> <VOName>
disable-model-invocation: true
---

Create value object `src/Domain/$0/ValueObject/$1.php`:

1. `declare(strict_types=1);`, `readonly class` with constructor promotion
2. Validate in constructor — throw domain exception on invalid input
3. Add `equals(self $other): bool` method
4. No setters, no mutable state
5. No framework imports — pure PHP only
6. Create test `tests/Domain/$0/ValueObject/$1Test.php`
7. Update TASKS.md — mark VO as `[x]`
