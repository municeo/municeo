---
paths:
  - "src/Application/*/Command/*.php"
  - "src/Application/*/Query/*.php"
---

# DTOs (Commands & Queries)

## Commands — readonly, no behavior, no validation

```php
// DO — pure data carrier, validated by handler
final readonly class CreateReport
{
    public function __construct(
        public string $userId,
        public string $category,
        public string $photoPath,
        public float $latitude,
        public float $longitude,
        public ?string $description = null,
    ) {}
}

// DON'T — DTO with behavior or self-validation
class CreateReport
{
    // ...
    public function validate(): array { /* returns errors */ }
    public function toEntity(): Report { /* builds entity */ }
}
```

## Commands carry raw input, handlers build VOs

```php
// DO — handler converts raw input to domain types
final readonly class CreateReportHandler
{
    public function __invoke(CreateReport $command): void
    {
        $coordinates = new Coordinates($command->latitude, $command->longitude);
        $reportId = ReportId::generate();
        // ... domain logic with VOs
    }
}

// DON'T — command carries VOs (couples Application to Domain construction)
final readonly class CreateReport
{
    public function __construct(
        public Coordinates $location,  // VO in DTO
        public ReportId $id,           // VO in DTO
    ) {}
}
```

## Queries — readonly, typed properties

```php
// DO — explicit typed fields
final readonly class GetReportsNearLocation
{
    public function __construct(
        public float $latitude,
        public float $longitude,
        public int $radiusMeters,
        public ?ReportStatus $status = null,
    ) {}
}

// DON'T — generic array bag
class GetReports
{
    public function __construct(
        public array $filters,  // untyped, unclear contract
    ) {}
}
```

## No inheritance on DTOs

```php
// DO — flat, explicit, final
final readonly class ValidateReport
{
    public function __construct(
        public string $reportId,
        public string $agentId,
        public string $photoPath,
        public string $comment,
    ) {}
}

// DON'T — abstract base DTO
abstract class BaseReportCommand
{
    public function __construct(
        public string $reportId,
        public string $agentId,
    ) {}
}

class ValidateReport extends BaseReportCommand { /* ... */ }
```
