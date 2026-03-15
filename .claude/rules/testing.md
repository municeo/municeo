---
paths:
  - "tests/**/*.php"
---

# Testing

## Mirror `src/` structure

```
tests/
├── Domain/
│   ├── Report/Entity/ReportTest.php
│   └── Report/ValueObject/CoordinatesTest.php
├── Application/
│   └── Report/Handler/CreateReportHandlerTest.php
└── Infrastructure/
    ├── Persistence/Doctrine/Repository/DoctrineReportRepositoryTest.php
    └── Http/Controller/Citizen/CreateReportControllerTest.php
```

## Domain tests: pure, no mocks

```php
// DO — test domain logic directly
final class ReportTest extends TestCase
{
    public function test_validate_from_pending_transitions_to_validated(): void
    {
        $report = ReportFixture::pending();

        $report->validate(agentId: 'agent-1', photoPath: '/photo.jpg', comment: 'Constaté');

        self::assertSame(ReportStatus::VALIDATED, $report->status());
    }

    public function test_validate_from_rejected_throws(): void
    {
        $report = ReportFixture::rejected();

        $this->expectException(InvalidTransitionException::class);

        $report->validate(agentId: 'agent-1', photoPath: '/photo.jpg', comment: 'Constaté');
    }
}

// DON'T — mock the entity itself
$report = $this->createMock(Report::class);
$report->method('status')->willReturn(ReportStatus::PENDING);
```

## Application tests: mock repository interfaces

```php
// DO — mock interface, verify handler behavior
final class CreateReportHandlerTest extends TestCase
{
    public function test_blocked_user_throws(): void
    {
        $users = $this->createMock(UserRepositoryInterface::class);
        $users->method('findById')->willReturn(UserFixture::blocked());

        $handler = new CreateReportHandler($this->reports, $users, 3, 30, 50);

        $this->expectException(UserBlockedException::class);

        ($handler)(new CreateReport(userId: 'user-1', /* ... */));
    }
}

// DON'T — use real database in unit test
$em = $kernel->getContainer()->get('doctrine.orm.entity_manager');
```

## Method names: test_behavior (snake_case)

```php
// DO
public function test_wilson_score_above_threshold_triggers_agent_alert(): void {}
public function test_duplicate_vote_throws_exception(): void {}

// DON'T
public function testWilson(): void {}
public function test1(): void {}
```

## Data providers for parameterized tests

```php
// DO
#[DataProvider('trustScoreLevelProvider')]
public function test_trust_score_returns_correct_level(int $score, CitizenLevel $expected): void
{
    self::assertSame($expected, (new TrustScore($score))->getLevel());
}

public static function trustScoreLevelProvider(): \Generator
{
    yield 'habitant'        => [0, CitizenLevel::HABITANT];
    yield 'citoyen'         => [5, CitizenLevel::CITOYEN];
    yield 'citoyen_engage'  => [15, CitizenLevel::CITOYEN_ENGAGE];
    yield 'pilier_quartier' => [30, CitizenLevel::PILIER_QUARTIER];
}

// DON'T — copy-paste test for each threshold
public function test_level_0(): void { /* ... */ }
public function test_level_5(): void { /* ... */ }
public function test_level_15(): void { /* ... */ }
```
