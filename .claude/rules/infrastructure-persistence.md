---
paths:
  - "src/Infrastructure/Persistence/**/*.php"
  - "migrations/**/*.php"
---

# Persistence

- Doctrine repos implement domain interfaces
- PostGIS: `ST_DWithin` with `::geography` cast for meters
- Doctrine PHP 8 attributes for mapping — only here, never in Domain
- UUID v7 and PostGIS Point as custom Doctrine types
- Migrations via `doctrine:migrations:diff` only
- `EncryptionService`: AES-256-GCM for email
- `UsernameGenerator`: French adjective + noun + 4 digits
