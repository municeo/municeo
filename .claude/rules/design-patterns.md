---
paths:
  - "src/**/*.php"
---

# Design Principles & Patterns

## SRP — Single Responsibility

One class, one reason to change. One handler, one use case.

```php
// DO — each handler handles one command
final readonly class CreateReportHandler
{
    public function __invoke(CreateReport $command): void { /* ... */ }
}

final readonly class RejectReportHandler
{
    public function __invoke(RejectReport $command): void { /* ... */ }
}

// DON'T — god handler
class ReportHandler
{
    public function create(CreateReport $command): void { /* ... */ }
    public function reject(RejectReport $command): void { /* ... */ }
    public function validate(ValidateReport $command): void { /* ... */ }
    public function resolve(ResolveReport $command): void { /* ... */ }
}
```

## OCP — Open/Closed

Extend behavior without modifying existing code. Use events and interfaces.

```php
// DO — new behavior via event listener, no existing code modified
final readonly class NotifyAgentsOnWilsonAlert
{
    public function __invoke(ReportVoted $event): void
    {
        if ($event->wilsonScore >= $this->alertThreshold) {
            $this->mercure->publish('/agents/alerts', $event->reportId);
        }
    }
}

// DON'T — modifying the vote handler every time you add a side-effect
class VoteHandler
{
    public function __invoke(VoteReport $cmd): void
    {
        // vote logic...
        // send email...
        // push mercure...
        // update trust score...
        // check abuse...
    }
}
```

## LSP — Liskov Substitution

Implementations must honor their interface contracts.

```php
// DO — both implementations honor the same contract
interface ReportRepositoryInterface
{
    /** @throws ReportNotFoundException */
    public function findById(string $id): Report;
}

// DON'T — implementation returns null when interface promises Report
class DoctrineReportRepository implements ReportRepositoryInterface
{
    public function findById(string $id): ?Report { /* ... */ }
}
```

## ISP — Interface Segregation

Small, focused interfaces. Clients depend only on what they use.

```php
// DO — separate read and write
interface ReportReaderInterface
{
    public function findById(string $id): Report;
    public function findNear(float $lat, float $lng, int $radius): array;
}

interface ReportWriterInterface
{
    public function save(Report $report): void;
}

// DON'T — one fat interface
interface ReportRepositoryInterface
{
    public function findById(string $id): Report;
    public function findNear(float $lat, float $lng, int $radius): array;
    public function save(Report $report): void;
    public function delete(Report $report): void;
    public function countByUser(string $userId): int;
    public function export(array $filters): array;
}
```

## DIP — Dependency Inversion

Depend on abstractions. Handlers use domain interfaces, not Doctrine.

```php
// DO — handler depends on domain interface
final readonly class CreateReportHandler
{
    public function __construct(
        private ReportRepositoryInterface $reports,
        private EventDispatcherInterface $events,
    ) {}
}

// DON'T — handler depends on infrastructure
final readonly class CreateReportHandler
{
    public function __construct(
        private DoctrineReportRepository $reports,
        private EntityManagerInterface $em,
    ) {}
}
```

## KISS — Keep It Simple

The simplest solution that works. No abstractions for one-time logic.

```php
// DO — direct, readable
public function isBlocked(): bool
{
    return $this->blockedUntil !== null && $this->blockedUntil > new \DateTimeImmutable();
}

// DON'T — unnecessary abstraction
public function isBlocked(): bool
{
    return (new BlockStatusSpecification(new DateTimeProvider()))->isSatisfiedBy($this);
}
```

## Specification Pattern — for complex domain queries

Use Specification only when business rules compose or are reused across contexts.

```php
// DO — composable specification for query filtering
final readonly class ActiveReportsNearLocation
{
    public function __construct(
        private Coordinates $center,
        private int $radiusMeters,
    ) {}

    public function toCriteria(): Criteria
    {
        // compose: status in [PENDING, VALIDATED] AND within radius
    }
}

// DON'T — specification for trivial single-use check
class IsNotNullSpecification
{
    public function isSatisfiedBy(mixed $value): bool
    {
        return $value !== null;
    }
}
```

## Tell, Don't Ask

Objects perform actions, callers don't extract state and decide.

```php
// DO — entity owns its transition logic
$report->validate(agentId: $agentId, photoPath: $path, comment: $comment);

// DON'T — caller pulls state and decides
if ($report->getStatus() === ReportStatus::PENDING) {
    $report->setStatus(ReportStatus::VALIDATED);
    $report->setValidatedBy($agentId);
}
```

## Fail Fast

Validate early. Throw immediately on invalid state.

```php
// DO — validate at construction
final readonly class Coordinates
{
    public function __construct(
        public float $latitude,
        public float $longitude,
    ) {
        if ($latitude < -90.0 || $latitude > 90.0) {
            throw new InvalidCoordinatesException("Latitude must be between -90 and 90, got {$latitude}");
        }
        if ($longitude < -180.0 || $longitude > 180.0) {
            throw new InvalidCoordinatesException("Longitude must be between -180 and 180, got {$longitude}");
        }
    }
}

// DON'T — defer validation
class Coordinates
{
    public float $latitude;
    public float $longitude;

    public function isValid(): bool
    {
        return $this->latitude >= -90 && $this->latitude <= 90;
    }
}
```

## Composition over Inheritance

Inject behavior, don't extend base classes.

```php
// DO — compose via constructor injection
final readonly class TrustScoreCalculator
{
    public function __construct(
        private UserRepositoryInterface $users,
    ) {}
}

// DON'T — inheritance chain
class TrustScoreCalculator extends AbstractScoreCalculator
{
    // overrides parent methods...
}
```

## No Primitive Obsession

Wrap domain concepts in value objects.

```php
// DO
public function __construct(
    private ReportId $id,
    private Coordinates $location,
    private TrustScore $trustScore,
) {}

// DON'T
public function __construct(
    private string $id,
    private float $latitude,
    private float $longitude,
    private int $trustScore,
) {}
```
