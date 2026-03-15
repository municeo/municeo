# Municeo — Tâches MVP

Référence : [PLAN.md](PLAN.md) | [docs/specifications.md](docs/specifications.md)

Légende : `[ ]` à faire · `[~]` en cours · `[x]` terminé

---

## Phase 1 — Domain Layer

### 1.1 ValueObjects & Enums

- [ ] `src/Domain/Report/ValueObject/ReportStatus.php` — Enum (`PENDING`, `VALIDATED`, `RESOLVED`, `REJECTED`, `ARCHIVED`)
- [ ] `src/Domain/Report/ValueObject/ReportId.php` — UUID v7 wrapper
- [ ] `src/Domain/Report/ValueObject/Coordinates.php` — VO (latitude, longitude) avec validation
- [ ] `src/Domain/Report/ValueObject/VoteValue.php` — Enum (+1, -1)
- [ ] `src/Domain/Report/ValueObject/WilsonScore.php` — VO calculé (formule z=1.96)
- [ ] `src/Domain/Report/Service/WilsonScoreCalculator.php` — Service de calcul
- [ ] `src/Domain/User/ValueObject/TrustScore.php` — VO avec `getLevel(): CitizenLevel`
- [ ] `src/Domain/User/ValueObject/CitizenLevel.php` — Enum (Habitant, Citoyen, Citoyen Engagé, Pilier)
- [ ] `src/Domain/User/ValueObject/UserRole.php` — Enum (CITIZEN, AGENT, ADMIN)
- [ ] `src/Domain/User/ValueObject/AbuseReason.php` — Enum
- [ ] `src/Domain/User/ValueObject/EncryptedEmail.php` — VO chiffré AES

### 1.2 Entités

- [ ] `src/Domain/Report/Entity/Report.php` — id, user, category, description, photo_path, location, status, created_at, archived_at
- [ ] `src/Domain/Report/Entity/ReportVote.php` — id, report, user, value, created_at
- [ ] `src/Domain/Report/Entity/AgentValidation.php` — id, report, agent, photo_path, taken_at, comment, is_public, created_at
- [ ] `src/Domain/User/Entity/User.php` — id, username, email, password, roles, trust_score, abuse_count, blocked_until, deleted_at, created_at

### 1.3 Domain Events

- [ ] `src/Domain/Report/Event/ReportCreated.php`
- [ ] `src/Domain/Report/Event/ReportVoted.php`
- [ ] `src/Domain/Report/Event/ReportValidated.php`
- [ ] `src/Domain/Report/Event/ReportResolved.php`
- [ ] `src/Domain/Report/Event/ReportRejected.php`
- [ ] `src/Domain/Report/Event/ReportArchived.php`
- [ ] `src/Domain/User/Event/UserBlocked.php`
- [ ] `src/Domain/User/Event/UserDeleted.php`

### 1.4 Domain Exceptions

- [ ] `src/Domain/Report/Exception/DuplicateReportException.php`
- [ ] `src/Domain/Report/Exception/ReportDailyLimitExceededException.php`
- [ ] `src/Domain/Report/Exception/ReportCooldownException.php`
- [ ] `src/Domain/Report/Exception/DuplicateVoteException.php`
- [ ] `src/Domain/Report/Exception/InvalidTransitionException.php`
- [ ] `src/Domain/User/Exception/UserBlockedException.php`

### 1.5 Repository Interfaces

- [ ] `src/Domain/Report/Repository/ReportRepositoryInterface.php`
- [ ] `src/Domain/User/Repository/UserRepositoryInterface.php`

### 1.6 Tests Domain

- [ ] Tests unitaires ValueObjects (TrustScore niveaux, WilsonScore formule, Coordinates validation)
- [ ] Tests unitaires Entités (transitions statut Report, contraintes)
- [ ] Tests WilsonScoreCalculator

---

## Phase 2 — Application Layer

### 2.1 Report Commands & Handlers

- [ ] `CreateReport` / `CreateReportHandler` — Vérifie blocage → rate limit → cooldown → doublon → crée PENDING
- [ ] `VoteReport` / `VoteReportHandler` — Vote +1/-1, recalcul Wilson, effets seuils
- [ ] `VoteReportResolved` / `VoteReportResolvedHandler` — Vote résolution pondéré par niveau
- [ ] `ValidateReport` / `ValidateReportHandler` — Agent valide terrain (photo + commentaire)
- [ ] `ResolveReport` / `ResolveReportHandler` — Agent clôture
- [ ] `RejectReport` / `RejectReportHandler` — Agent rejette (motif interne)
- [ ] `ArchiveExpiredReports` / `ArchiveExpiredReportsHandler` — PENDING > 30j → ARCHIVED

### 2.2 User Commands & Handlers

- [ ] `RegisterAnonymousUser` / `RegisterAnonymousUserHandler` — Inscription email + mdp, username généré

### 2.3 Queries

- [ ] `GetReportsNearLocation` — Signalements proches (PostGIS ST_DWithin)
- [ ] `GetReportsByStatus` — Filtrage par statut

### 2.4 Tests Application

- [ ] Tests handlers avec mocks repositories
- [ ] Tests règles métier (ordre vérifications CreateReport, seuils Wilson, pondération votes)

---

## Phase 3 — Infrastructure Persistence

- [ ] Configuration Doctrine + `jsor/doctrine-postgis`
- [ ] Types custom : PostGIS Point, UUID v7
- [ ] `DoctrineReportRepository` implements `ReportRepositoryInterface`
- [ ] `DoctrineUserRepository` implements `UserRepositoryInterface`
- [ ] Migration initiale (tables + index + contrainte unique vote)
- [ ] `EncryptionService` — AES encrypt/decrypt email
- [ ] `UsernameGenerator` — adjectif + nom + 4 chiffres
- [ ] Tests intégration repositories (base test PostgreSQL)

---

## Phase 4 — Infrastructure Notification

- [ ] `MercurePublisher` — Publication SSE
- [ ] `NotifyAuthorOnResolutionListener` — Mercure push + email différé
- [ ] `NotifyAgentsOnWilsonAlertListener` — Mercure push + email différé
- [ ] `BlockedUserListener` — Email blocage/avertissement/suppression
- [ ] Messages Messenger : `SendResolutionEmail`, `SendAgentAlertEmail`, `SendBlockEmail`
- [ ] `ArchiveExpiredReportsScheduler` — Cron quotidien 02h00
- [ ] Templates email (blocage 1er, blocage 2e, suppression, résolution, alerte agent)

---

## Phase 5 — Infrastructure Http (Frontend citoyen)

- [ ] `RegisterController` — GET/POST `/register`
- [ ] `LoginController` — GET/POST `/login`
- [ ] `MapController` — GET `/carte` (page principale)
- [ ] `CreateReportController` — GET/POST `/signalement/nouveau`
- [ ] `ReportViewController` — GET `/signalement/{id}`
- [ ] `VoteController` — POST `/signalement/{id}/vote`
- [ ] `ResolveVoteController` — POST `/signalement/{id}/resolu`
- [ ] Templates Twig : layout, carte (Leaflet/MapLibre), formulaire, fiche signalement
- [ ] Stimulus : `gps_controller.js`, `camera_controller.js`
- [ ] Turbo Frames : mise à jour fiche après vote
- [ ] Security : firewall `main` pattern `^/`, `ROLE_CITIZEN`

---

## Phase 6 — Backoffice Agent

- [ ] `AgentDashboardController` — GET `/agent` (liste + carte)
- [ ] `ValidateReportController` — POST `/agent/signalement/{id}/valider`
- [ ] `ResolveReportController` — POST `/agent/signalement/{id}/cloturer`
- [ ] `RejectReportController` — POST `/agent/signalement/{id}/rejeter`
- [ ] Templates : dashboard agent, fiche avec actions, filtres
- [ ] Mercure : abonnement `/agents/alerts`
- [ ] Security : firewall `agent` pattern `^/agent`, `ROLE_AGENT`

---

## Phase 7 — Backoffice Admin

- [ ] `AdminDashboardController` — GET `/admin`
- [ ] `AgentManagementController` — CRUD comptes agents
- [ ] `CitizenViewController` — Liste citoyens (username, niveau, trust_score, abuse_count)
- [ ] `ExportController` — GET `/admin/export` (CSV)
- [ ] `ConfigController` — GET/POST `/admin/config`
- [ ] Templates : dashboard admin, gestion agents, export, config
- [ ] Security : firewall `admin` pattern `^/admin`, `ROLE_ADMIN`

---

## Phase 8 — PWA & Finalisation

- [ ] `public/manifest.json`
- [ ] `public/sw.js` — Service Worker minimal
- [ ] Tests fonctionnels controllers (WebTestCase)
- [ ] GitHub Actions : `.github/workflows/ci.yml` (PHPStan, PHPUnit, CS-Fixer)
- [ ] `CONTRIBUTING.md`
- [ ] `SECURITY.md`
- [ ] `CODE_OF_CONDUCT.md`
