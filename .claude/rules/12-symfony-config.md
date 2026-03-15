# Symfony Configuration

Applies to: `config/**/*.yaml`, `composer.json`

- All business thresholds in `config/services.yaml` under `parameters:` with `municeo.` prefix
- FrankenPHP: worker mode, Caddyfile config, `dunglas/frankenphp` Docker image
- Messenger: async transport for delayed emails (resolution +5min, alerts +5min)
- Scheduler: `ArchiveExpiredReports` command registered for daily 02h00
- Mercure: hub URL in `.env`, publisher/subscriber configured in `mercure.yaml`
- Doctrine: custom types for UUID v7 and PostGIS Point
- Three security firewalls matching route patterns
- PHPStan: level 8, `phpstan.neon` at root
- PHP-CS-Fixer: PSR-12 + Symfony ruleset, `.php-cs-fixer.dist.php` at root
