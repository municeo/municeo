---
paths:
  - "src/Domain/**/*.php"
---

# Domain Layer

ZERO framework imports. Only pure PHP.

## No Doctrine/Symfony in Domain

```php
// DO — pure PHP, domain interface
namespace App\Domain\Report\Repository;

interface ReportRepositoryInterface
{
    public function findById(string $id): Report;
    public function save(Report $report): void;
}

// DON'T — framework leaking into Domain
namespace App\Domain\Report\Repository;

use Doctrine\ORM\EntityManagerInterface; // FORBIDDEN

interface ReportRepositoryInterface
{
    public function getEntityManager(): EntityManagerInterface;
}
```

## No mapping attributes in Domain

```php
// DO — plain entity in Domain
namespace App\Domain\Report\Entity;

final class Report
{
    private ReportStatus $status;

    public function validate(string $agentId, string $photoPath, string $comment): void
    {
        // ...
    }
}

// DON'T — Doctrine attributes in Domain
namespace App\Domain\Report\Entity;

use Doctrine\ORM\Mapping as ORM; // FORBIDDEN

#[ORM\Entity]
#[ORM\Table(name: 'reports')]
class Report
{
    #[ORM\Id]
    #[ORM\Column(type: 'uuid')]
    private string $id;
}
```

## Repository interfaces here, implementations in Infrastructure

```php
// DO — interface in Domain
// src/Domain/User/Repository/UserRepositoryInterface.php
interface UserRepositoryInterface
{
    public function findById(string $id): User;
}

// Implementation in Infrastructure
// src/Infrastructure/Persistence/Doctrine/Repository/DoctrineUserRepository.php
final readonly class DoctrineUserRepository implements UserRepositoryInterface
{
    public function __construct(private EntityManagerInterface $em) {}
}

// DON'T — concrete repository in Domain
// src/Domain/User/Repository/UserRepository.php
class UserRepository
{
    public function __construct(private EntityManagerInterface $em) {} // FORBIDDEN
}
```
