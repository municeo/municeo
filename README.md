# Municeo

Outil participatif open source permettant aux habitants d'une commune de signaler des incivilités et problèmes du quotidien (dépôts sauvages, voirie dégradée, éclairage défectueux…) directement à leur municipalité.

## Objectifs

- Redonner de la voix aux habitants via un outil communautaire sain
- Pas de commentaires libres entre citoyens, score de confiance transparent, mécanismes de vote simples
- Librement déployable par toute commune, ouvert aux contributions, non commercial

## Stack technique

| Couche | Choix |
|---|---|
| Langage | PHP 8.5+ |
| Framework | Symfony 8.0+ |
| Serveur | FrankenPHP (mode worker) |
| Frontend | Twig + Symfony UX (Stimulus, Turbo) |
| Base de données | PostgreSQL 18+ / PostGIS 3.6+ |
| Temps réel | Mercure (SSE) |
| Tests | PHPUnit |

## Architecture

Trois couches avec dépendance stricte : **Domain** ← Application ← Infrastructure.

```
src/
├── Domain/          # Entités, ValueObjects, Events, Exceptions, Interfaces
├── Application/     # Commands, Handlers, Queries
└── Infrastructure/  # Doctrine, Controllers, Mercure, Mailer, Messenger
```

## Fonctionnalités MVP

- **Signalements** — Création avec photo + géolocalisation, catégories (déchets, voirie, éclairage, autre)
- **Votes communautaires** — +1/-1 avec Wilson Score pour priorisation automatique
- **Résolution citoyenne** — Vote de résolution pondéré par niveau de confiance
- **Validation terrain** — Agents municipaux constatent et clôturent avec preuve photo
- **Anti-abus** — Rate limiting, cooldown, sanctions automatiques progressives
- **Notifications** — Mercure temps réel + email différé via Messenger
- **Anonymat** — Email chiffré AES, username généré, aucune donnée exposée

## Documentation

- [Spécifications complètes](docs/specifications.md)
- [Plan de développement](PLAN.md)
- [Tâches détaillées](TASKS.md)

## Démarrage rapide

> *À venir — le projet est en phase de développement initial.*

## Contribuer

Voir [CONTRIBUTING.md](CONTRIBUTING.md) *(à venir)*.

## Licence

[AGPL-3.0](LICENSE) — Toute version modifiée déployée comme service doit publier ses modifications.
