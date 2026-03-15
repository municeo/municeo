---
paths:
  - "src/Infrastructure/Http/Controller/**/*.php"
  - "templates/**/*.twig"
---

# Controllers

- Thin ADR: validate input → dispatch command → return response
- Areas: `Controller/Citizen/`, `Controller/Agent/`, `Controller/Admin/`
- `#[IsGranted('ROLE_...')]` per area
- CSRF on all mutating forms
- HTTP errors: 403 blocked, 429 rate limit/cooldown, 409 duplicate
- Routes: `/register`, `/carte`, `/signalement/{id}`, `/agent/...`, `/admin/...`
