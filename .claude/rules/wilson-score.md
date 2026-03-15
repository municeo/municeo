---
paths:
  - "src/Domain/Report/Service/WilsonScoreCalculator.php"
  - "src/Domain/User/ValueObject/TrustScore.php"
  - "src/Application/Report/Handler/*Vote*Handler*.php"
---

# Wilson Score & Trust System

Formula (95% confidence, z=1.96):
```
p_hat = positive / total
wilson = (p_hat + z²/2n - z√(p̂(1-p̂)/n + z²/4n²)) / (1 + z²/n)
```

Wilson thresholds → effects (all configurable via `municeo.*` params):
- `>= 0.65` → alert agents (once per report)
- `>= 0.6` → author TrustScore +2
- `<= 0.3` → author TrustScore -1
- `<= 0.2` → author abuseCount +1

TrustScore → CitizenLevel (never persisted):
- 0–4 Habitant | 5–14 Citoyen | 15–29 Citoyen Engagé (vote x1.5) | 30+ Pilier (x1.5 + badge)

Abuse: <3 → blocked 72h | >=3 → soft delete

## Calculator implementation

```php
// DO — pure function, no side effects, thresholds injected
final readonly class WilsonScoreCalculator
{
    private const Z = 1.96;

    public function calculate(int $positive, int $total): WilsonScore
    {
        if ($total === 0) {
            return new WilsonScore(0.0);
        }

        $pHat = $positive / $total;
        $z2 = self::Z ** 2;
        $n = $total;

        $score = ($pHat + $z2 / (2 * $n)
            - self::Z * sqrt(($pHat * (1 - $pHat) + $z2 / (4 * $n)) / $n))
            / (1 + $z2 / $n);

        return new WilsonScore($score);
    }
}

// DON'T — persist score, fetch from DB, hardcode Z value per-method
class WilsonHelper
{
    public function getScore(int $reportId): float
    {
        return $this->em->createQuery('SELECT w.score FROM wilson_scores w WHERE ...')
            ->getSingleScalarResult();
    }
}
```

## Applying thresholds in handler

```php
// DO — check thresholds in order, apply effects
$wilson = $this->calculator->calculate($positiveCount, $totalCount);

if ($wilson->value() >= $this->alertThreshold && !$report->isAlertSent()) {
    $report->markAlertSent();
    $events[] = new AgentAlertTriggered($report->id());
}

match(true) {
    $wilson->value() >= $this->positiveThreshold => $author->adjustTrustScore(+2),
    $wilson->value() <= $this->negativeThreshold => $author->adjustTrustScore(-1),
    default => null,
};

// DON'T — hardcoded thresholds, nested ifs
if ($wilson > 0.65) { /* ... */ }
if ($wilson > 0.6) { /* ... */ }
if ($wilson < 0.3) { /* ... */ }
```
