# Create Value Object

Create a new domain value object following project conventions.

## Usage
`/create-vo <Context> <VOName>`
Example: `/create-vo Report Coordinates`

## Steps
1. Create `src/Domain/{Context}/ValueObject/{VOName}.php`
2. Add `declare(strict_types=1);`
3. Make it a `readonly class` with constructor promotion
4. Add validation in constructor (throw domain exception on invalid input)
5. Add `equals(self $other): bool` method
6. No setters — immutability enforced
7. Create test file `tests/Domain/{Context}/ValueObject/{VOName}Test.php`
8. Update TASKS.md
