---
paths:
  - "src/Domain/*/ValueObject/*.php"
---

# Value Objects

## Always `readonly class`, always valid

```php
// DO — immutable, validated at construction, has behavior
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

## Derived values as methods, not stored fields

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

## Wrap primitives that carry domain meaning

```php
// DO — typed, self-documenting, impossible to mix up
public function findById(ReportId $id): Report;
public function findNear(Coordinates $location, int $radiusMeters): array;

// DON'T — primitive soup, easy to swap lat/lng by accident
public function findById(string $id): Report;
public function findNear(float $lat, float $lng, int $radius): array;
```

## Named constructors for alternative creation paths

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

## Collections as VOs when they carry invariants

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
