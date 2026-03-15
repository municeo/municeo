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
