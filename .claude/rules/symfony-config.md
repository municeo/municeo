---
paths:
  - "config/**/*.yaml"
  - "composer.json"
  - "Dockerfile"
  - "Caddyfile"
---

# Symfony Configuration

- Business thresholds in `config/services.yaml` under `parameters:` with `municeo.` prefix
- FrankenPHP worker mode, `dunglas/frankenphp` Docker image
- Messenger: async transport for delayed emails (+5min)
- Scheduler: `ArchiveExpiredReports` daily at 02h00
- Doctrine: custom types for UUID v7 and PostGIS Point
- Three firewalls: `admin` (^/admin), `agent` (^/agent), `main` (^/)
