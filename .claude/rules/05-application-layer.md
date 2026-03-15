# Application Layer

Applies to: `src/Application/**/*.php`

- One Command class per use case — immutable DTO with `readonly` properties
- One Handler per Command — single `__invoke(CommandName $command)` method
- Handlers depend on Domain repository interfaces (not Doctrine implementations)
- Handlers orchestrate: load aggregate → call domain methods → persist → dispatch events
- `CreateReportHandler` verification order: blocked → rate limit → cooldown → duplicate → create
- All thresholds injected as constructor parameters (from `services.yaml`)
- No direct HTTP/Response concerns — return domain objects or void
- Queries are read-only — never modify state
