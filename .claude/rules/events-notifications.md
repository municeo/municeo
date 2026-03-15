---
paths:
  - "src/Domain/*/Event/*.php"
  - "src/Infrastructure/Notification/**/*.php"
  - "src/Infrastructure/Mercure/**/*.php"
  - "src/Infrastructure/Messenger/**/*.php"
---

# Events & Notifications

- Domain events: readonly DTOs (reportId, userId, timestamp)
- Mercure topics: `/users/{userId}/notifications`, `/agents/alerts`
- Emails via Messenger with +5min delay (resolution, agent alerts)
- Email decrypted only at send time, never logged
- One Wilson alert per report — track `alert_sent` flag
- Block emails: 1st informational, 2nd final warning, 3rd deletion notice
