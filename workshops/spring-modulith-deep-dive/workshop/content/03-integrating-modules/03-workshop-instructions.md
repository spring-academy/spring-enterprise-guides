---
title: 'Integrating Modules - Consistency'
---

```terminal:execute-all
command: cd ~/exercises/30-event-based-integration/initial
autostart: true
hidden: true
```

```dashboard:open-dashboard
name: Editor
autostart: true
hidden: true
```

📖 Consistency

- Simple `@EventListeners` are triggered synchronously which means that they run inside the primary business transaction.

- Challenges:

  - Do we really want transitive functionality located in other modules allow to break the original business transaction?

  - The transaction has not committed yet. What if the functionality in the listener (sending out an email, for example) expects it to be completely done.

  - Interacting with infrastructure except the database (such as a message broker or email server) is usually expensive. If we execute that code within the original transaction, it will significantly expand the resource allocation and might, for example, saturate the connection pool.

- Solution: an alternative event handling mode that triggers listeners both on transaction commit `@TransactionalEventListener` and asynchronously `@Async`.
