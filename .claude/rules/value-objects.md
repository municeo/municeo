---
paths:
  - "src/Domain/*/ValueObject/*.php"
---

# Value Objects

- Always `readonly class` — no setters, no mutable state
- Constructor validation: throw domain exception on invalid input
- Implement `equals()` method for comparison
- Use constructor promotion
- `WilsonScore` and `CitizenLevel` are computed, never persisted
- `TrustScore` has a `getLevel(): CitizenLevel` method based on thresholds
- `EncryptedEmail` holds ciphertext only — decryption is Infrastructure concern
- `Coordinates` validates latitude (-90..90) and longitude (-180..180)
