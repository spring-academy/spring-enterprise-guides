---
title: 'Integrating Modules - Event Publication Registry'
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

To prevent event publications from being lost when listeners fail, Spring Modulith provides integration with Spring’s application event bus. It tracks the publications and decorates listeners to mark successfully handled event publications as completed.

🎯 Objectives

You will learn
- how to make use of Spring Modulith’s Event Publication Registry to keep track of outstanding event publications.
- how that in place prevents event publications from getting lost in case of listener failures.

👣 Add Spring Modulith’s Event Publication Registry

To make use of the Event Publication Registry add the Spring Modulith JPA starter to the `pom.xml`.

```
<dependency>
  <groupId>org.springframework.modulith</groupId>
  <artifactId>spring-modulith-starter-jpa</artifactId>
</dependency>
```

The starter pulls in the general registry infrastructure and Spring Boot auto-configuration to automatically hook into Spring’s `ApplicationEventMulticaster` to keep track of the publications and decorate transactional event listeners to mark the publications as completed on listener success.

To see this working, simply re-run `OrderManagementIntegrationTests.completesOrder()` and inspect the log output.

```
…     main : Started OrderManagementIntegrationTests in 1.911 seconds (process running for 2.648)
…     main : Registering publication of com.example.app.order.OrderCompleted for com.example.app.inventory.Inventory.on(com.example.app.order.OrderCompleted).
…     main : Registering publication of com.example.app.order.OrderCompleted for com.example.app.order.EmailSender.on(com.example.app.order.OrderCompleted).
…     main : Finish order completion.
…   task-2 : Sending email for order 1f1221e4-c748-43b4-a627-6556b1132b08.
…   task-1 : Updating stock for order 1f1221e4-c748-43b4-a627-6556b1132b08.
…   task-1 : Marking publication of event com.example.app.order.OrderCompleted to listener com.example.app.inventory.Inventory.on(com.example.app.order.OrderCompleted) completed.
…   task-2 : Email sent for order 1f1221e4-c748-43b4-a627-6556b1132b08.
…   task-2 : Marking publication of event com.example.app.order.OrderCompleted to listener com.example.app.order.EmailSender.on(com.example.app.order.OrderCompleted) completed.
… downHook : No publications outstanding!
```

Note how, during the execution of the primary business method, the publication of the event triggers the registration of event publications with the registry. As both listeners complete successfully, the publication is marked completed on the corresponding threads. The test concludes by reporting that no publications are outstanding.

Tweak the `Inventory` to fail during the processing of the order by re-adding the `RuntimeException`.

```
public class Inventory {

public void updateStockFor(Order order) {

    log.info("Updating stock for order {}.", order.getId());

    throw new RuntimeException(); // <- add this
}
}
```

Re-run the integration tests and inspect the log output.

```
…     main : Started OrderManagementIntegrationTests in 1.859 seconds (process running for 2.576)
…     main : Registering publication of com.example.app.order.OrderCompleted for com.example.app.inventory.Inventory.on(com.example.app.order.OrderCompleted).
…     main : Registering publication of com.example.app.order.OrderCompleted for com.example.app.order.EmailSender.on(com.example.app.order.OrderCompleted).
…     main : Finish order completion.
…   task-2 : Sending email for order 6dc323ab-926e-42f7-9a85-3614c4cb9888.
…   task-1 : Updating stock for order 6dc323ab-926e-42f7-9a85-3614c4cb9888.
…   task-1 : Invocation of listener void com.example.app.inventory.Inventory.on(com.example.app.order.OrderCompleted) failed. Leaving event publication uncompleted.

java.lang.RuntimeException: null
at com.example.app.inventory.Inventory.updateStockFor(Inventory.java:49)
at com.example.app.inventory.Inventory.on(Inventory.java:42)
…

…   task-2 : Email sent for order 6dc323ab-926e-42f7-9a85-3614c4cb9888.
…   task-2 : Marking publication of event com.example.app.order.OrderCompleted to listener com.example.app.order.EmailSender.on(com.example.app.order.OrderCompleted) completed.
… downHook : Shutting down with the following publications left unfinished:
… downHook : └─ com.example.app.order.OrderCompleted - com.example.app.inventory.Inventory.on(com.example.app.order.OrderCompleted)
```

The publications get registered as before, the `Inventory` listener fails as can be seen by the reported exception stack trace leaving the publication uncompleted. This is also reported in the eventual shutdown of the application context.

💡 Summary