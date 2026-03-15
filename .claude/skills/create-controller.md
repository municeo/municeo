# Create Controller

Create a Symfony controller following ADR pattern.

## Usage
`/create-controller <Area> <Name>`
Example: `/create-controller Agent ValidateReport`

## Steps
1. Create `src/Infrastructure/Http/Controller/{Area}/{Name}Controller.php`
2. Add `#[IsGranted('ROLE_...')]` matching the area (Citizen/Agent/Admin)
3. Add CSRF protection on mutating actions
4. Controller is thin: validate → dispatch command → respond
5. Map HTTP errors: 403, 409, 429 per spec
6. Create Twig template in `templates/{area}/{action}.html.twig`
7. Create functional test `tests/Infrastructure/Http/Controller/{Area}/{Name}ControllerTest.php`
8. Update TASKS.md
