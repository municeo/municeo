---
paths:
  - "src/Infrastructure/Persistence/**/*.php"
  - "migrations/**/*.php"
---

# Persistence

## Doctrine repos implement domain interfaces

```php
// DO
final readonly class DoctrineReportRepository implements ReportRepositoryInterface
{
    public function __construct(
        private EntityManagerInterface $em,
    ) {}

    public function findById(string $id): Report
    {
        return $this->em->find(Report::class, $id)
            ?? throw new ReportNotFoundException($id);
    }

    public function save(Report $report): void
    {
        $this->em->persist($report);
        $this->em->flush();
    }
}

// DON'T — extend ServiceEntityRepository, expose QueryBuilder
class DoctrineReportRepository extends ServiceEntityRepository
{
    public function getQueryBuilder(): QueryBuilder { /* ... */ }
}
```

## PostGIS: ST_DWithin with geography cast

```php
// DO — geography cast for meters
$qb->andWhere("ST_DWithin(r.location, ST_Point(:lng, :lat)::geography, :radius)")
    ->setParameter('lng', $longitude)
    ->setParameter('lat', $latitude)
    ->setParameter('radius', $radiusMeters);

// DON'T — geometry (degrees, not meters)
$qb->andWhere("ST_DWithin(r.location, ST_Point(:lng, :lat), :radius)");
```

## Mapping attributes only in Infrastructure

```php
// DO — mapping in Infrastructure entity wrapper or XML
// src/Infrastructure/Persistence/Doctrine/Mapping/Report.orm.xml
// or PHP attributes on a Doctrine-specific proxy

// DON'T — ORM attributes in Domain entity
// src/Domain/Report/Entity/Report.php
#[ORM\Entity] // FORBIDDEN in Domain
class Report {}
```

## Migrations generated, never hand-written

```bash
# DO
php bin/console doctrine:migrations:diff

# DON'T — hand-write migration SQL
```

## EncryptionService: AES-256-GCM

```php
// DO — encrypt/decrypt with authenticated encryption
final readonly class EncryptionService
{
    public function encrypt(string $plaintext): string
    {
        $nonce = random_bytes(SODIUM_CRYPTO_AEAD_AES256GCM_NPUBBYTES);
        $ciphertext = sodium_crypto_aead_aes256gcm_encrypt($plaintext, '', $nonce, $this->key);

        return base64_encode($nonce . $ciphertext);
    }
}

// DON'T — ECB mode, no authentication
openssl_encrypt($plaintext, 'aes-256-ecb', $key);
```
