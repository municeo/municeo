# Security

## Email: never logged, decrypted only for sending

```php
// DO — decrypt at last possible moment
final readonly class SendResolutionEmailHandler
{
    public function __invoke(SendResolutionEmail $message): void
    {
        $plainEmail = $this->encryption->decrypt($user->encryptedEmail());
        $this->mailer->send(/* ... */);
        // $plainEmail goes out of scope — never stored
    }
}

// DON'T — log or persist decrypted email
$this->logger->info("Sending to {$plainEmail}"); // FORBIDDEN
$user->setPlainEmail($plainEmail);                // FORBIDDEN
```

## No user enumeration at registration

```php
// DO — generic message whether email exists or not
if ($this->users->emailExists($email)) {
    throw new RegistrationFailedException('Inscription impossible.');
}

// DON'T — reveal email existence
throw new \Exception("L'adresse {$email} est déjà utilisée.");
```

## Photo validation: whitelist MIME types

```php
// DO — strict whitelist
$allowed = ['image/jpeg', 'image/png', 'image/webp'];
if (!in_array($file->getMimeType(), $allowed, true)) {
    throw new InvalidPhotoException('Type de fichier non autorisé.');
}

// DON'T — blacklist or no check
if ($file->getMimeType() === 'application/x-executable') { /* block only this */ }
```

## Soft delete only

```php
// DO — set deleted_at, keep row for referential integrity
public function softDelete(): void
{
    $this->deletedAt = new \DateTimeImmutable();
}

// DON'T — hard delete user (orphans their reports)
$em->remove($user);
$em->flush();
```
