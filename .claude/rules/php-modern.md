---
paths:
  - "src/**/*.php"
  - "tests/**/*.php"
---

# PHP 8.5+ Modern Features

## Attributes over annotations

```php
// DO
#[ORM\Entity]
#[ORM\Table(name: 'reports')]
class Report {}

// DON'T
/** @ORM\Entity @ORM\Table(name="reports") */
class Report {}
```

## Enums over constants

```php
// DO
enum ReportStatus: string
{
    case PENDING = 'pending';
    case VALIDATED = 'validated';
}

// DON'T
class ReportStatus
{
    public const PENDING = 'pending';
    public const VALIDATED = 'validated';
}
```

## match over switch

```php
// DO
$label = match($status) {
    ReportStatus::PENDING => 'En attente',
    ReportStatus::VALIDATED => 'Validé',
    ReportStatus::RESOLVED => 'Résolu',
};

// DON'T
switch ($status) {
    case ReportStatus::PENDING:
        $label = 'En attente';
        break;
    case ReportStatus::VALIDATED:
        $label = 'Validé';
        break;
}
```

## Pipe operator for transformations (PHP 8.5)

```php
// DO
$result = $input
    |> trim(...)
    |> strtolower(...)
    |> ucfirst(...);

// DON'T
$result = ucfirst(strtolower(trim($input)));
```

## Constructor promotion

```php
// DO
final readonly class Coordinates
{
    public function __construct(
        public float $latitude,
        public float $longitude,
    ) {}
}

// DON'T
class Coordinates
{
    private float $latitude;
    private float $longitude;

    public function __construct(float $latitude, float $longitude)
    {
        $this->latitude = $latitude;
        $this->longitude = $longitude;
    }
}
```

## readonly classes for immutable data

```php
// DO
final readonly class CreateReport
{
    public function __construct(
        public string $userId,
        public string $category,
        public float $latitude,
        public float $longitude,
    ) {}
}

// DON'T — mutable command DTO
class CreateReport
{
    public string $userId;
    public string $category;
    // setters...
}
```

## Named arguments for clarity

```php
// DO
$this->reportRepository->findNear(
    latitude: $command->latitude,
    longitude: $command->longitude,
    radiusMeters: $this->duplicateRadius,
);

// DON'T
$this->reportRepository->findNear($command->latitude, $command->longitude, $this->duplicateRadius);
```

## Null coalescing and nullsafe operator

```php
// DO
$level = $user?->getTrustScore()?->getLevel() ?? CitizenLevel::HABITANT;

// DON'T
$level = CitizenLevel::HABITANT;
if ($user !== null) {
    $score = $user->getTrustScore();
    if ($score !== null) {
        $level = $score->getLevel();
    }
}
```

## First-class callables

```php
// DO
$emails = array_map($this->encryptionService->decrypt(...), $rawEmails);

// DON'T
$emails = array_map(function ($e) { return $this->encryptionService->decrypt($e); }, $rawEmails);
// DON'T
$emails = array_map([$this->encryptionService, 'decrypt'], $rawEmails);
```

## Fibers for non-blocking I/O (where applicable)

Use fibers only when orchestrating concurrent I/O (e.g., parallel Mercure publish + email dispatch). Do not use fibers for CPU-bound or simple sequential logic.

## Strict types everywhere

Every PHP file starts with:
```php
declare(strict_types=1);
```
No exceptions.
