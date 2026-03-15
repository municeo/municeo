---
name: create-handler
description: Create a command + handler pair following CQRS conventions
argument-hint: <Context> <CommandName>
disable-model-invocation: true
---

Create command + handler for `$0/$1`:

1. `src/Application/$0/Command/$1.php` — readonly DTO with constructor promotion
2. `src/Application/$0/Handler/$1Handler.php` — single `__invoke($1 $command)` method
3. Inject domain repository interfaces (not Doctrine), thresholds from config
4. Handler flow: load aggregate → call domain methods → persist → dispatch events
5. For CreateReportHandler: verify blocked → rate limit → cooldown → duplicate → create
6. Create test `tests/Application/$0/Handler/$1HandlerTest.php` with mocked repos
7. Update TASKS.md — mark handler as `[x]`
