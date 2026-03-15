---
paths:
  - "src/Infrastructure/Http/Controller/**/*.php"
  - "templates/**/*.twig"
---

# Controllers

- ADR pattern: Action-Domain-Responder (one action per controller method)
- Controllers are thin: validate input → dispatch command → return response
- Three areas: `Controller/Citizen/`, `Controller/Agent/`, `Controller/Admin/`
- Security enforced via Symfony attributes: `#[IsGranted('ROLE_CITIZEN')]`, etc.
- CSRF protection on all forms
- Error responses: 403 blocked, 429 rate limit/cooldown, 409 duplicate
- Photo upload: validate MIME type, max size, store via Storage service
- Routes match spec: `/register`, `/carte`, `/signalement/{id}`, `/agent/...`, `/admin/...`
