---
name: create-controller
description: Create a Symfony controller following ADR pattern
argument-hint: <Area> <Name>
disable-model-invocation: true
---

Create controller `src/Infrastructure/Http/Controller/$0/$1Controller.php`:

1. Add `#[IsGranted('ROLE_...')]` matching area (Citizen→ROLE_CITIZEN, Agent→ROLE_AGENT, Admin→ROLE_ADMIN)
2. Thin controller: validate input → dispatch command → return response
3. CSRF protection on mutating actions
4. Error mapping: 403 blocked, 429 rate limit/cooldown, 409 duplicate
5. Create template `templates/$0/$1.html.twig` (lowercase area)
6. Create test `tests/Infrastructure/Http/Controller/$0/$1ControllerTest.php`
7. Update TASKS.md — mark controller as `[x]`
