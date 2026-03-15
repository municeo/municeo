---
paths:
  - "src/Domain/*/Event/*.php"
  - "src/Infrastructure/Notification/**/*.php"
  - "src/Infrastructure/Mercure/**/*.php"
  - "src/Infrastructure/Messenger/**/*.php"
---

# Events & Notifications

## Domain events: readonly DTOs

```php
// DO — simple, immutable, no behavior
final readonly class ReportValidated
{
    public function __construct(
        public string $reportId,
        public string $agentId,
        public \DateTimeImmutable $occurredAt = new \DateTimeImmutable(),
    ) {}
}

// DON'T — event with logic or framework dependency
class ReportValidated
{
    public function notify(): void { /* ... */ } // behavior in event
    public function __construct(private MailerInterface $mailer) {} // framework dep
}
```

## Mercure: push to topic, not to individual connections

```php
// DO — publish to user-specific topic
$this->mercure->publish(
    new Update(
        topic: "/users/{$userId}/notifications",
        data: json_encode(['type' => 'report_resolved', 'reportId' => $reportId]),
    ),
);

// DON'T — broadcast to all
$this->mercure->publish(new Update(topic: '/global', data: $payload));
```

## Email via Messenger with delay

```php
// DO — dispatch with delay stamp
$this->bus->dispatch(
    new SendResolutionEmail($reportId, $authorId),
    [new DelayStamp(5 * 60 * 1000)], // +5 minutes
);

// DON'T — send email synchronously in listener
$this->mailer->send($email); // blocks the request
```

## One Wilson alert per report

```php
// DO — check flag before alerting
if ($wilsonScore >= $this->alertThreshold && !$report->isAlertSent()) {
    $report->markAlertSent();
    $this->mercure->publish(/* /agents/alerts */);
}

// DON'T — alert every time Wilson crosses threshold
if ($wilsonScore >= $this->alertThreshold) {
    $this->mercure->publish(/* spam on every vote */);
}
```
