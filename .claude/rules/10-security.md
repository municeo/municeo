# Security

Applies to: all code

- `declare(strict_types=1);` in every PHP file
- Email: AES-256-GCM encrypted at rest, never logged in clear, decrypted only for sending
- Password: argon2id via Symfony PasswordHasher
- Three firewalls: `admin` (^/admin), `agent` (^/agent), `main` (^/)
- CSRF tokens on all mutating forms
- Rate limiting: configurable daily limit + cooldown between reports
- No user enumeration: generic error on duplicate email registration
- Photo validation: MIME type whitelist (image/jpeg, image/png, image/webp), max size
- No SQL injection: always use Doctrine DQL/QueryBuilder with parameters
- Input validation: Symfony Validator constraints on all DTOs
- Soft delete: `deleted_at` field, never hard delete users (referential integrity)
