---
title: 'Integrating Modules - Switching to @ApplicationModuleListener'
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

🎯 Objectives

👣 Changing the listener execution model

Replace the `@EventListener` annotation in both `InventoryManagement` and `EmailSender` with `@ApplicationEventListener`.

Re-run the test and inspect log output.

```
… main : Started OrderManagementIntegrationTests in 1.464 seconds (process running for 2.171)
… main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
… main : Opened new EntityManager [SessionImpl(1977568029<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@3bf41cd0]
… main : Found thread-bound EntityManager [SessionImpl(1977568029<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Finish order completion.
… main : Initiating transaction commit
… main : Committing JPA transaction on EntityManager [SessionImpl(1977568029<open>)]

… main : Found thread-bound EntityManager [SessionImpl(1977568029<open>)] for JPA transaction
… main : Suspending current transaction, creating new transaction with name [com.example.app.inventory.Inventory.on]
… main : Opened new EntityManager [SessionImpl(1074053050<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@c19bb2a]
… main : Found thread-bound EntityManager [SessionImpl(1074053050<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Found thread-bound EntityManager [SessionImpl(1074053050<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Updating stock for order 218cca0f-c89c-4342-a7af-a25c4c5740ee.
… main : Initiating transaction commit
… main : Committing JPA transaction on EntityManager [SessionImpl(1074053050<open>)]
… main : Closing JPA EntityManager [SessionImpl(1074053050<open>)] after transaction

… main : Resuming suspended transaction after completion of inner transaction
… main : Found thread-bound EntityManager [SessionImpl(1977568029<open>)] for JPA transaction
… main : Suspending current transaction, creating new transaction with name [com.example.app.order.EmailSender.on]
… main : Opened new EntityManager [SessionImpl(1394284408<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@ecfff32]
… main : Sending email for order 218cca0f-c89c-4342-a7af-a25c4c5740ee.
… main : Email sent for order 218cca0f-c89c-4342-a7af-a25c4c5740ee.
… main : Initiating transaction commit
… main : Committing JPA transaction on EntityManager [SessionImpl(1394284408<open>)]
… main : Closing JPA EntityManager [SessionImpl(1394284408<open>)] after transaction

… main : Resuming suspended transaction after completion of inner transaction
… main : Closing JPA EntityManager [SessionImpl(1977568029<open>)] after transaction
```

Our transactional execution arrangement got slightly more complicated. `OrderManagement.complete(…)` publishes events and they get registered for submission on transaction commit. The business method succeeds and the original transaction gets committed. During the transaction cleanup phase, the listener declared in `InventoryManagement` is triggered due to the implicit `@TransactionalEventListener`. A new transaction is created as `@ApplicationModuleListener` is meta-annotated with `@Transactional(propagation = REQUIRES_NEW)`. The original transaction however is suspended, but resources are kept alive (see the `EntityManager` instance 1977568029 and thus the connection backing it). Also, the listener is executed on the same (`main`) thread. The `@Async` annotation does not seem to be considered yet. The same applies to the second listener to send out emails. The original business transaction (`EntityManager` instance 1977568029) is closed eventually.

To get the asynchronous execution working, add `@EnableAsync` on the main application class:

```
@EnableAsync // <- add this
@SpringBootApplication
public class Application { /* … */ }
```

As we expect our listener to be executed on a separate thread, the call to `OrderManagement.complete()` will immediately return. To make sure that the test doesn’t quit before the listener has completed, let us add a `Thread.sleep()` to it for now. We will improve on that later.

```
@SpringBootTest
class OrderManagementIntegrationTests {

@Test
void publishesEventOnCompletion() throws InterruptedException {

    orders.complete(new Order());

    Thread.sleep(2000); // <- add this and that ^^
}
}
```

Re-run `OrderManagementIntegrationTests` and watch the log output.

```
…   main : Started OrderManagementIntegrationTests in 1.505 seconds (process running for 2.177)
…   main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
…   main : Opened new EntityManager [SessionImpl(1604949791<open>)] for JPA transaction
…   main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@377cbdae]
…   main : Found thread-bound EntityManager [SessionImpl(1604949791<open>)] for JPA transaction
…   main : Participating in existing transaction
…   main : Finish order completion.
…   main : Initiating transaction commit
…   main : Committing JPA transaction on EntityManager [SessionImpl(1604949791<open>)]

… task-1 : Creating new transaction with name [com.example.app.inventory.Inventory.on]: PROPAGATION_REQUIRES_NEW,ISOLATION_DEFAULT
… task-1 : Opened new EntityManager [SessionImpl(1062114679<open>)] for JPA transaction
… task-1 : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@31896cee]
… task-1 : Found thread-bound EntityManager [SessionImpl(1062114679<open>)] for JPA transaction
… task-1 : Participating in existing transaction
… task-2 : Creating new transaction with name [com.example.app.order.EmailSender.on]: PROPAGATION_REQUIRES_NEW,ISOLATION_DEFAULT
…   main : Closing JPA EntityManager [SessionImpl(1604949791<open>)] after transaction
… task-2 : Opened new EntityManager [SessionImpl(1942841355<open>)] for JPA transaction
… task-2 : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@7d0a8802]
… task-2 : Sending email for order 8fe72caf-3338-422d-b905-f017208839ba.
… task-1 : Found thread-bound EntityManager [SessionImpl(1062114679<open>)] for JPA transaction
… task-1 : Participating in existing transaction
… task-1 : Updating stock for order 8fe72caf-3338-422d-b905-f017208839ba.
… task-1 : Initiating transaction commit
… task-1 : Committing JPA transaction on EntityManager [SessionImpl(1062114679<open>)]
… task-1 : Closing JPA EntityManager [SessionImpl(1062114679<open>)] after transaction
… task-2 : Email sent for order 8fe72caf-3338-422d-b905-f017208839ba.
… task-2 : Initiating transaction commit
… task-2 : Committing JPA transaction on EntityManager [SessionImpl(1942841355<open>)]
… task-2 : Closing JPA EntityManager [SessionImpl(1942841355<open>)] after transaction
```

The invocation of our listener updating the inventory has been moved to a separate thread as we can see from the `task-1` thread name in the log output and gets an dedicated transaction started (1062114679). The same for the thread executing the email sending. The primary effect of that is that the original transaction does not need to be suspended anymore as the transaction created for the listener runs without an existing transaction in its execution context. This also means that the resources acquired by the original transaction can be freed early as evident from the interleaved log statement from the main thread.

To see how this arrangement reacts to the original business method failing eventually, throw a `RuntimeException` at the very end of it.

```
public class OrderManagement {

public void complete(Order order) {

    orders.save(order.complete());

    events.publishEvent(new OrderCompleted(order.getId()));

    log.info("Finish order completion.");

    throw new RuntimeException(); // <- add this
}
}
```

Re-run

```
… main : Started OrderManagementIntegrationTests in 1.494 seconds (process running for 2.258)
… main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
… main : Opened new EntityManager [SessionImpl(923439967<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@6cb417fc]
… main : Found thread-bound EntityManager [SessionImpl(923439967<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Finish order completion.
… main : Initiating transaction rollback
… main : Rolling back JPA transaction on EntityManager [SessionImpl(923439967<open>)]
… main : Closing JPA EntityManager [SessionImpl(923439967<open>)] after transaction
```

Note how the failed execution leads to a transaction rollback and the listeners _not_ being invoked, despite the event having been published. In other words, this scenario does not suffer from the premature email publication we have seen in 👣 A Failing Event Listener.

💡 Summary

We have switched to an integration mode in which the attached functionality is executed separately from the original unit of work. This allows the seamless integration of such functionality in a way that it does not negatively affect the primary use case. However, there are a couple of things to consider:

As the listeners are executed asynchronously waiting for the side effects to manifest requires low-level thread handling. This is something that could be nicer.

The asynchronous execution implies the question of what happens if the event listener fails.

Having to add `@EnableAsync` manually to make sure the listeners really get executed asynchronously feels a little cumbersome, too.