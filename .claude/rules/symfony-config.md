---
paths:
  - "config/**/*.yaml"
  - "composer.json"
  - "Dockerfile"
  - "Caddyfile"
---

# Symfony Configuration

## Business thresholds in services.yaml with municeo.* prefix

```yaml
# DO — all magic numbers configurable
parameters:
    municeo.report_daily_limit: 3
    municeo.report_cooldown_minutes: 30
    municeo.duplicate_radius_meters: 50
    municeo.wilson_alert_threshold: 0.65

services:
    App\Application\Report\Handler\CreateReportHandler:
        arguments:
            $dailyLimit: '%municeo.report_daily_limit%'
            $cooldownMinutes: '%municeo.report_cooldown_minutes%'

# DON'T — hardcoded in PHP or scattered across files
# private const DAILY_LIMIT = 3; // in handler
```

## Messenger: async transport with delay

```yaml
# DO — async transport for deferred emails
framework:
    messenger:
        transports:
            async: '%env(MESSENGER_TRANSPORT_DSN)%'
        routing:
            'App\Infrastructure\Messenger\Message\SendResolutionEmail': async
            'App\Infrastructure\Messenger\Message\SendAgentAlertEmail': async

# DON'T — sync transport (blocks HTTP request)
# routing:
#     'App\Infrastructure\Messenger\Message\SendResolutionEmail': sync
```

## Three firewalls matching route patterns

```yaml
# DO
security:
    firewalls:
        admin:
            pattern: ^/admin
            # ROLE_ADMIN
        agent:
            pattern: ^/agent
            # ROLE_AGENT
        main:
            pattern: ^/
            # ROLE_CITIZEN

# DON'T — single firewall, role checks scattered in controllers
```
