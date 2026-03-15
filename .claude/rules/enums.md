---
paths:
  - "src/Domain/*/ValueObject/*.php"
---

# Enums

- Use PHP 8.1+ native backed enums (`string` or `int`)
- `ReportStatus: string` — pending, validated, resolved, rejected, archived
- `CitizenLevel: string` — habitant, citoyen, citoyen_engage, pilier_quartier
- `VoteValue: int` — UP=1, DOWN=-1
- `AbuseReason: string` — rate_limit_exceeded, cooldown_bypassed, negative_wilson_score
- `UserRole: string` — ROLE_CITIZEN, ROLE_AGENT, ROLE_ADMIN
- No business logic in enums — keep them as pure data carriers
