# Events & Notifications

Applies to: `src/Domain/*/Event/*.php`, `src/Infrastructure/Notification/**/*.php`, `src/Infrastructure/Mercure/**/*.php`

- Domain events are simple readonly DTOs (reportId, userId, timestamp)
- Events dispatched via Symfony EventDispatcher (wired in Infrastructure)
- Mercure topics: `/users/{userId}/notifications`, `/agents/alerts`
- Email sent via Messenger with delay: `+5 minutes` for resolution and agent alerts
- Email decrypted only at send time — never logged in clear
- One alert per report for Wilson threshold — track `alert_sent` flag
- Blocking emails: 1st = informational, 2nd = final warning, 3rd = deletion notice
