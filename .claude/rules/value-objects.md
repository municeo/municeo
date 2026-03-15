---
paths:
  - "src/Domain/*/ValueObject/*.php"
  - "src/Application/*/Command/*.php"
  - "src/Application/*/Query/*.php"
---

# Value Objects & DTOs

## Value Object vs DTO — when to use which

| | Value Object | DTO (Command/Query) |
|---|---|---|
| **Where** | `src/Domain/*/ValueObject/` | `src/Application/*/Command/`, `Query/` |
| **Purpose** | Domain concept with validation & behavior | Data transfer between layers |
| **Validation** | In constructor — always valid once created | In handler or Symfony Validator |
| **Behavior** | Has methods (`getLevel()`, `equals()`) | No behavior — pure data carrier |
| **Identity** | Compared by value (`equals()`) | Not compared — used once and discarded |

---

## Value Objects

### Always `readonly class`, always valid

```php
// DO — immutable, validated at construction, has behavior
declare(strict_types=1);

namespace App\Domain\Report\ValueObject;

final readonly class Coordinates
{
    public function __construct(
        public float $latitude,
        public float $longitude,
    ) {
        if ($latitude < -90.0 || $latitude > 90.0) {
            throw new InvalidCoordinatesException("Latitude out of range: {$latitude}");
        }
        if ($longitude < -180.0 || $longitude > 180.0) {
            throw new InvalidCoordinatesException("Longitude out of range: {$longitude}");
        }
    }

    public function equals(self $other): bool
    {
        return $this->latitude === $other->latitude
            && $this->longitude === $other->longitude;
    }
}

// DON'T — mutable, no validation, no equals
class Coordinates
{
    public float $latitude;
    public float $longitude;

    public function setLatitude(float $lat): void
    {
        $this->latitude = $lat;
    }
}
```

### Derived values as methods, not stored fields

```php
// DO — CitizenLevel computed from score, never persisted
final readonly class TrustScore
{
    public function __construct(
        public int $value,
    ) {}

    public function getLevel(): CitizenLevel
    {
        return match(true) {
            $this->value >= 30 => CitizenLevel::PILIER_QUARTIER,
            $this->value >= 15 => CitizenLevel::CITOYEN_ENGAGE,
            $this->value >= 5  => CitizenLevel::CITOYEN,
            default            => CitizenLevel::HABITANT,
        };
    }

    public function equals(self $other): bool
    {
        return $this->value === $other->value;
    }
}

// DON'T — store derived value
class TrustScore
{
    public int $value;
    public CitizenLevel $level; // redundant, will go stale
}
```

### Wrap primitives that carry domain meaning

```php
// DO — typed, self-documenting, impossible to mix up
public function findById(ReportId $id): Report;
public function findNear(Coordinates $location, int $radiusMeters): array;

// DON'T — primitive soup, easy to swap lat/lng by accident
public function findById(string $id): Report;
public function findNear(float $lat, float $lng, int $radius): array;
```

### Named constructors for alternative creation paths

```php
// DO — expressive factory methods
final readonly class ReportId
{
    private function __construct(
        public string $value,
    ) {}

    public static function generate(): self
    {
        return new self(uuid_create(UUID_TYPE_TIME));
    }

    public static function fromString(string $id): self
    {
        if (!uuid_is_valid($id)) {
            throw new InvalidReportIdException($id);
        }

        return new self($id);
    }

    public function equals(self $other): bool
    {
        return $this->value === $other->value;
    }
}

// DON'T — public constructor doing double duty
class ReportId
{
    public function __construct(public string $value = '')
    {
        if ($value === '') {
            $this->value = uuid_create(UUID_TYPE_TIME);
        }
    }
}
```

### Collections as VOs when they carry invariants

```php
// DO — collection VO with business rule
final readonly class VoteCollection
{
    /** @param list<ReportVote> $votes */
    public function __construct(
        private array $votes,
    ) {}

    public function wilsonScore(): WilsonScore
    {
        return WilsonScoreCalculator::calculate($this->votes);
    }

    public function hasVotedAlready(string $userId): bool
    {
        foreach ($this->votes as $vote) {
            if ($vote->userId() === $userId) {
                return true;
            }
        }

        return false;
    }
}

// DON'T — pass raw array everywhere, duplicate logic in multiple handlers
/** @param ReportVote[] $votes */
function calculateWilson(array $votes): float { /* ... */ }
```

---

## DTOs (Commands & Queries)

### Commands — readonly, no behavior, no validation

```php
// DO — pure data, validated by handler
declare(strict_types=1);

namespace App\Application\Report\Command;

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

### Commands carry raw input, handlers build VOs

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

### Queries — readonly, return type explicit

```php
// DO
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

### No inheritance on DTOs

```php
// DO — flat, explicit
final readonly class ValidateReport
{
    public function __construct(
        public string $reportId,
        public string $agentId,
        public string $photoPath,
        public string $comment,
    ) {}
}

// DON'T
abstract class BaseReportCommand
{
    public function __construct(
        public string $reportId,
        public string $agentId,
    ) {}
}

class ValidateReport extends BaseReportCommand { /* ... */ }
```
