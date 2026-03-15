# Wilson Score & Trust System

Applies to: `src/Domain/Report/Service/WilsonScoreCalculator.php`, `src/Domain/User/ValueObject/TrustScore.php`

Wilson Score formula (95% confidence, z=1.96):
```
p_hat = positive_votes / total_votes
wilson = (p_hat + z²/2n - z√(p̂(1-p̂)/n + z²/4n²)) / (1 + z²/n)
```

Thresholds (from config):
- `>= wilson_alert_threshold` (0.65) → alert agents (once per report)
- `>= 0.6` → author TrustScore +2
- `<= 0.3` → author TrustScore -1
- `<= 0.2` → author abuseCount +1

TrustScore levels:
- 0–4: Habitant (standard)
- 5–14: Citoyen (standard)
- 15–29: Citoyen Engagé (resolution vote weight x1.5)
- 30+: Pilier de Quartier (weight x1.5 + visible badge)

Abuse escalation:
- abuseCount < 3 → blocked 72h + email
- abuseCount >= 3 → soft delete + final email
