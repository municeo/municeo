---
paths:
  - "src/Infrastructure/Http/Controller/**/*.php"
  - "templates/**/*.twig"
---

# Controllers

## Thin ADR: validate → dispatch → respond

```php
// DO — controller delegates everything to handler
#[Route('/signalement/nouveau', name: 'report_create', methods: ['POST'])]
#[IsGranted('ROLE_CITIZEN')]
public function __invoke(Request $request): Response
{
    $command = new CreateReport(
        userId: $this->getUser()->getId(),
        category: $request->request->getString('category'),
        photoPath: $this->storage->store($request->files->get('photo')),
        latitude: $request->request->getFloat('latitude'),
        longitude: $request->request->getFloat('longitude'),
        description: $request->request->get('description'),
    );

    try {
        ($this->handler)($command);
    } catch (UserBlockedException $e) {
        throw new AccessDeniedHttpException($e->getMessage());
    } catch (ReportDailyLimitExceededException|ReportCooldownException) {
        throw new TooManyRequestsHttpException();
    } catch (DuplicateReportException $e) {
        throw new ConflictHttpException($e->getMessage());
    }

    return $this->redirectToRoute('report_show', ['id' => $command->reportId]);
}

// DON'T — business logic in controller
public function __invoke(Request $request): Response
{
    $user = $this->userRepo->find($this->getUser()->getId());
    if ($user->isBlocked()) { /* ... */ }
    $count = $this->reportRepo->countTodayByUser($user);
    if ($count >= 3) { /* ... */ }
    // ... 50 lines of domain logic
}
```

## CSRF on all mutating forms

```php
// DO — in Twig form
<input type="hidden" name="_token" value="{{ csrf_token('report_create') }}">

// DO — in controller
#[IsCsrfTokenValid('report_create', '_token')]

// DON'T — no CSRF protection on POST
#[Route('/signalement/{id}/vote', methods: ['POST'])]
public function vote(string $id): Response { /* no token check */ }
```

## Error mapping

```php
// DO — domain exceptions mapped to HTTP codes
// 403 → UserBlockedException
// 429 → DailyLimitExceededException, CooldownException
// 409 → DuplicateReportException, DuplicateVoteException

// DON'T — generic 500 for everything
catch (\Exception $e) {
    return new Response('Error', 500);
}
```
