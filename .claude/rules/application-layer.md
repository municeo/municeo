---
paths:
  - "src/Application/**/*.php"
---

# Application Layer

## One Command + one Handler per use case

```php
// DO — single __invoke, single responsibility
final readonly class CreateReportHandler
{
    public function __construct(
        private ReportRepositoryInterface $reports,
        private UserRepositoryInterface $users,
        private int $dailyLimit,
        private int $cooldownMinutes,
        private int $duplicateRadius,
    ) {}

    public function __invoke(CreateReport $command): void
    {
        $user = $this->users->findById($command->userId);
        // blocked → rate limit → cooldown → duplicate → create
    }
}

// DON'T — multiple methods, god handler
class ReportHandler
{
    public function handleCreate(CreateReport $cmd): void { /* ... */ }
    public function handleVote(VoteReport $cmd): void { /* ... */ }
    public function handleReject(RejectReport $cmd): void { /* ... */ }
}
```

## Handlers depend on domain interfaces

```php
// DO
public function __construct(
    private ReportRepositoryInterface $reports,
    private EventDispatcherInterface $events,
) {}

// DON'T — depends on infrastructure
public function __construct(
    private EntityManagerInterface $em,
    private DoctrineReportRepository $reports,
) {}
```

## Handler flow: load → domain logic → persist → dispatch

```php
// DO — clear flow
public function __invoke(RejectReport $command): void
{
    $report = $this->reports->findById($command->reportId);

    $report->reject(agentId: $command->agentId, motif: $command->motif);

    $this->reports->save($report);

    foreach ($report->pullDomainEvents() as $event) {
        $this->events->dispatch($event);
    }
}

// DON'T — mixed concerns, inline SQL, direct entity manipulation
public function __invoke(RejectReport $command): void
{
    $this->em->createQuery('UPDATE Report r SET r.status = :s WHERE r.id = :id')
        ->execute(['s' => 'rejected', 'id' => $command->reportId]);
    $this->mailer->send(/* ... */); // notification in handler
}
```

## Thresholds injected from config, not hardcoded

```php
// DO
public function __construct(
    private int $dailyLimit,       // from municeo.report_daily_limit
    private int $cooldownMinutes,  // from municeo.report_cooldown_minutes
) {}

// DON'T
private const DAILY_LIMIT = 3;     // hardcoded magic number
private const COOLDOWN = 30;
```

## No HTTP concerns — return domain objects or void

```php
// DO
public function __invoke(CreateReport $command): Report
{
    // ... returns domain entity
}

// DON'T
public function __invoke(CreateReport $command): JsonResponse
{
    // ... returns HTTP response
}
```
