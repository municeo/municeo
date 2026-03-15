# Municeo — Plan de développement MVP

**Version** : 1.0
**Référence** : [docs/specifications.md](docs/specifications.md)

---

## Phase 1 — Domain Layer

Fondations métier pures, sans dépendance framework.

1. **ValueObjects & Enums** — `ReportStatus`, `CitizenLevel`, `VoteValue`, `AbuseReason`, `Coordinates`, `ReportId`, `TrustScore`, `WilsonScore`, `EncryptedEmail`
2. **Entités** — `Report`, `ReportVote`, `AgentValidation`, `User`
3. **Domain Events** — `ReportCreated`, `ReportVoted`, `ReportValidated`, `ReportResolved`, `ReportRejected`, `ReportArchived`, `UserBlocked`, `UserDeleted`
4. **Domain Exceptions** — `DuplicateReport`, `DailyLimit`, `Cooldown`, `DuplicateVote`, `InvalidTransition`, `UserBlockedException`
5. **Domain Services** — `WilsonScoreCalculator`, `TrustScoreCalculatorInterface`
6. **Repository Interfaces** — `ReportRepositoryInterface`, `UserRepositoryInterface`

## Phase 2 — Application Layer

Commands, Handlers, Queries (CQRS-like).

1. **Report Commands & Handlers** — `CreateReport`, `VoteReport`, `VoteReportResolved`, `ValidateReport`, `ResolveReport`, `RejectReport`, `ArchiveExpiredReports`
2. **User Commands & Handlers** — `RegisterAnonymousUser`
3. **Queries** — `GetReportsNearLocation`, `GetReportsByStatus`

## Phase 3 — Infrastructure Persistence

Doctrine + PostGIS, implémentations concrètes.

1. **Doctrine Mapping** — Entités, types custom (PostGIS Point, UUID)
2. **Repository Implementations** — `DoctrineReportRepository`, `DoctrineUserRepository`
3. **Migrations** — Schema initial PostgreSQL + PostGIS
4. **Encryption Service** — AES pour emails

## Phase 4 — Infrastructure Notification

Mercure, Mailer, Messenger.

1. **Mercure Publisher** — Push SSE (`/users/{id}/notifications`, `/agents/alerts`)
2. **Event Listeners** — `NotifyAuthorOnResolution`, `NotifyAgentsOnWilsonAlert`
3. **Messenger Messages** — `SendResolutionEmail`, `SendAgentAlertEmail`, `SendBlockEmail`
4. **Scheduler** — `ArchiveExpiredReportsCommand` (quotidien 02h00)

## Phase 5 — Infrastructure Http (Frontend citoyen)

Controllers ADR, Twig, Stimulus.

1. **Controllers** — `RegisterController`, `CreateReportController`, `VoteController`, `ResolveController`, `ReportViewController`
2. **Twig Templates** — Carte (Leaflet/MapLibre), formulaire signalement, fiche détaillée
3. **Stimulus Controllers** — GPS (`navigator.geolocation`), caméra (`capture="environment"`)
4. **Turbo** — Navigation SPA-like, mises à jour temps réel

## Phase 6 — Backoffice Agent

Dashboard terrain.

1. **Agent Controllers** — `ValidateController`, `ResolveController`, `RejectController`, `DashboardController`
2. **Templates** — Liste/carte signalements, fiche avec actions, filtres
3. **Mercure** — Réception alertes temps réel

## Phase 7 — Backoffice Admin

Gestion et supervision.

1. **Admin Controllers** — `UserManagementController`, `ExportController`, `ConfigController`
2. **Templates** — Gestion agents, vue citoyens, export CSV, configuration paramètres

## Phase 8 — PWA & Finalisation

1. **PWA** — `manifest.json`, Service Worker minimal
2. **Tests** — PHPUnit (unitaires domain, intégration handlers, fonctionnels controllers)
3. **CI/CD** — GitHub Actions (lint, tests, build)
4. **Documentation** — CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md

---

## Principes transversaux

- **Pas de sur-ingénierie** — Minimum viable, itérer ensuite
- **Domain first** — Logique métier pure, testable sans framework
- **Events over coupling** — Communication inter-couches par événements
- **Paramètres configurables** — Tous les seuils dans `services.yaml`
- **Sécurité dès le départ** — Email chiffré, argon2, CSRF, rate limiting
