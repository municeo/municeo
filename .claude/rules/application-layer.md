---
paths:
  - "src/Application/**/*.php"
---

# Application Layer

- One Command (readonly DTO) + one Handler (`__invoke`) per use case
- Handlers depend on domain interfaces, not Doctrine implementations
- Flow: load aggregate → domain methods → persist → dispatch events
- `CreateReportHandler` order: blocked → rate limit → cooldown → duplicate → create
- Thresholds injected via constructor from `services.yaml`
- No HTTP/Response concerns — return domain objects or void
