# Infrastructure Persistence

Applies to: `src/Infrastructure/Persistence/**/*.php`

- Doctrine repositories implement domain repository interfaces
- PostGIS: use `ST_DWithin` with `::geography` cast for distance in meters
- Doctrine mapping via PHP 8 attributes (ORM\Entity, ORM\Column, etc.) — only here, never in Domain
- UUID v7 type registered as custom Doctrine type
- PostGIS Point type via `jsor/doctrine-postgis`
- Migrations in `migrations/` — always generated via `doctrine:migrations:diff`
- `EncryptionService` implements AES-256-GCM for email encryption
- `UsernameGenerator`: random adjective + noun + 4 digits (French words)
