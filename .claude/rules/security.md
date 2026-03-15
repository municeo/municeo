# Security

- Email: AES-256-GCM at rest, decrypted only for sending, never logged
- Password: argon2id via Symfony PasswordHasher
- No user enumeration: generic error on duplicate email at registration
- Photo validation: MIME whitelist (image/jpeg, image/png, image/webp), max size
- Soft delete only: `deleted_at`, never hard delete users
