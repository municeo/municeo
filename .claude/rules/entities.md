---
paths:
  - "src/Domain/*/Entity/*.php"
---

# Entities

## UUID v7 PK — never auto-increment

```php
// DO
final class Report
{
    private readonly string $id;

    public function __construct()
    {
        $this->id = uuid_create(UUID_TYPE_TIME);
    }
}

// DON'T
#[ORM\Id]
#[ORM\GeneratedValue]  // auto-increment forbidden
#[ORM\Column(type: 'integer')]
private int $id;
```

## State changes via named methods

```php
// DO — entity owns its transitions
final class Report
{
    public function validate(string $agentId, string $photoPath, string $comment): void
    {
        if ($this->status !== ReportStatus::PENDING) {
            throw new InvalidTransitionException($this->status, ReportStatus::VALIDATED);
        }

        $this->status = ReportStatus::VALIDATED;
        $this->domainEvents[] = new ReportValidated($this->id, $agentId);
    }

    public function reject(string $agentId, string $motif): void
    {
        if ($this->status !== ReportStatus::PENDING) {
            throw new InvalidTransitionException($this->status, ReportStatus::REJECTED);
        }

        $this->status = ReportStatus::REJECTED;
        $this->domainEvents[] = new ReportRejected($this->id, $agentId, $motif);
    }
}

// DON'T — public setters, no transition guard
class Report
{
    public function setStatus(ReportStatus $status): void
    {
        $this->status = $status; // no validation, no event
    }
}
```

## Record domain events

```php
// DO — collect events, pull after persistence
final class Report
{
    /** @var list<object> */
    private array $domainEvents = [];

    public function pullDomainEvents(): array
    {
        $events = $this->domainEvents;
        $this->domainEvents = [];

        return $events;
    }
}

// DON'T — dispatch events from inside entity
class Report
{
    public function __construct(private EventDispatcherInterface $dispatcher) {} // FORBIDDEN
}
```

## No Doctrine attributes — mapping in Infrastructure

```php
// DO — plain class in src/Domain/
final class User
{
    private string $id;
    private string $username;
    private string $email;
}

// Mapping in src/Infrastructure/Persistence/Doctrine/Mapping/
// or via separate PHP attribute class in Infrastructure

// DON'T
#[ORM\Entity(repositoryClass: DoctrineUserRepository::class)]
class User { /* ... */ }
```
