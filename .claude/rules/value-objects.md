---
paths:
  - "src/Domain/*/ValueObject/*.php"
---

# Value Objects

- `readonly class` with constructor promotion — no setters
- Validate in constructor, throw domain exception on invalid input
- `equals(self $other): bool` for comparison
- `WilsonScore` and `CitizenLevel`: computed at runtime, never persisted
- `TrustScore::getLevel(): CitizenLevel` derived from thresholds in specs
- `EncryptedEmail`: holds ciphertext only — decryption is Infrastructure
- `Coordinates`: validate lat (-90..90) and lng (-180..180)
