# Create Command + Handler

Create a command/handler pair following CQRS conventions.

## Usage
`/create-handler <Context> <CommandName>`
Example: `/create-handler Report CreateReport`

## Steps
1. Create `src/Application/{Context}/Command/{CommandName}.php` — readonly DTO
2. Create `src/Application/{Context}/Handler/{CommandName}Handler.php`
3. Handler has single `__invoke({CommandName} $command)` method
4. Inject domain repository interfaces via constructor
5. Inject configurable thresholds as constructor parameters
6. Follow business rule verification order from specs
7. Dispatch domain events after persistence
8. Create test `tests/Application/{Context}/Handler/{CommandName}HandlerTest.php` with mocked repos
9. Update TASKS.md
