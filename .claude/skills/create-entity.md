# Create Domain Entity

Create a new domain entity following project conventions.

## Usage
`/create-entity <Context> <EntityName>`
Example: `/create-entity Report Report`

## Steps
1. Create `src/Domain/{Context}/Entity/{EntityName}.php`
2. Add `declare(strict_types=1);`
3. Use `readonly` properties where possible
4. Generate UUID v7 in constructor
5. Add domain event recording (`$domainEvents` array + `pullDomainEvents()`)
6. Add named methods for state changes (no public setters)
7. Validate state transitions inside the entity
8. Create corresponding test file `tests/Domain/{Context}/Entity/{EntityName}Test.php`
9. Update TASKS.md to mark the entity as done
