---
title: 'Integrating Modules - Integrating Modules Via Spring Application Events'
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

You’ll learn
- how to replace the direct Spring bean invocation to trigger transitive functionality with a Spring event listener.
- about the effect that switch has on how the code is executed and how it affects the consistency model of the overall arrangement.

👣 Integrating via @EventListener

In this section we are going to refactor the interaction between `OrderManagement` and `InventoryManagement` to use Spring’s `ApplicationEventPublisher` and explore how the event publication is executed.

Add a record `OrderCompleted` in the order package:

public record OrderCompleted() {}

In `OrderManagement` remove the dependencies to the `EmailSender` and the `Inventory`. Add a dependency to `ApplicationEventPublisher` instead and use it in a method named `complete()` to publish an instance of `OrderCompleted` instead of actively invoking methods on the just removed dependencies.

```
private final ApplicationEventPublisher events;

void complete(Order order) {

    orders.save(order.complete());
    
    events.publishEvent(new OrderCompleted());
    
    log.info("Finish order completion.");
}
```

In `InventoryManagement`, a method annotated with `@EventListener` to receive `OrderCompleted` events and delegate to the already existing `updateStockFor(…)` method. Use the reference to `OrderManagement` to look up the order to be processed by using the identifier contained in the event.

```
@EventListener
void on(OrderCompleted event) {
updateStockFor(orders.findById(event.orderIdentifier()));
}
```

Similarly, add an event listener method in `EmailSender`.

```
@EventListener
void on(OrderCompleted event) {
sendEmailFor(event.orderIdentifier());
}
```

Run the `completesOrder()` in `OrderManagementIntegrationTests` and observe the log output.

```
… main : Started OrderManagementIntegrationTests in 1.481 seconds (process running for 2.198)
… main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
… main : Opened new EntityManager [SessionImpl(403583920<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@151d216e]
… main : Found thread-bound EntityManager [SessionImpl(403583920<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Found thread-bound EntityManager [SessionImpl(403583920<open>)] for JPA transaction
… main : Participating in existing transaction
… main : Updating stock for 1cef9451-e851-48d1-a750-9739b279b51c.
… main : Sending email for order 1cef9451-e851-48d1-a750-9739b279b51c.
… main : Email sent for order 1cef9451-e851-48d1-a750-9739b279b51c.
… main : Finish order completion.
… main : Initiating transaction commit
… main : Committing JPA transaction on EntityManager [SessionImpl(403583920<open>)]
```

Note how a transaction is created for the execution of `OrderManagement.complete(…)`. We then see the log output for the inventory update and the email sending all happening on the main thread. You should also see the email sending taking roundabout one second, which means that we block the original transaction and cannot return the connection before that is completed although the primary business transaction only takes a couple of milliseconds.

👣 A Failing Event Listener

Let us move on investigating what happens in case one of the listeners fails:

Change the processing of the in `Inventory` to throw a `RuntimeException`.

```
public void updateStockFor(Order order) {
log.info("Updating stock for order {}.", order.getId());
throw new RuntimeException(); // <- add this
}
```

Re-run `OrderManagementIntegrationTests.completesOrder()` and see how the test now fails and the log output changes to this:

```
… main : Started OrderManagementIntegrationTests in 1.479 seconds (process running for 2.174)
… main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
… main : Opened new EntityManager [SessionImpl(1617891184<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@7e36d508]
… main : Found thread-bound EntityManager [SessionImpl(1617891184<open>)] for JPA transaction
… main : Participating in existing transaction
…
… main : Updating stock for order dcb6593e-b362-4d67-adfa-665c84f0baf0.
… main : Participating transaction failed - marking existing transaction as rollback-only
… main : Setting JPA transaction on EntityManager [SessionImpl(1617891184<open>)] rollback-only
… main : Initiating transaction rollback
… main : Rolling back JPA transaction on EntityManager [SessionImpl(1617891184<open>)]
… main : Closing JPA EntityManager [SessionImpl(1617891184<open>)] after transaction
```

Note how the stock update fails, causes the email sending to be skipped entirely and the exception causing the transaction to be rolled back.

Remove the code throwing the `RuntimeException` from `InventoryManagement` and rather move the failure to the very end of `OrderManagement.complete(…)`. This way, we simulate an error occurring _after_ the event listeners have been executed. Re-run `OrderManagementIntegrationTests.completesOrder()` and look at the log output:

```
… main : Started OrderManagementIntegrationTests in 1.463 seconds (process running for 2.262)
… main : Creating new transaction with name [com.example.app.order.OrderManagement.complete]: PROPAGATION_REQUIRED,ISOLATION_DEFAULT
… main : Opened new EntityManager [SessionImpl(1505756962<open>)] for JPA transaction
… main : Exposing JPA transaction as JDBC [org.springframework.orm.jpa.vendor.HibernateJpaDialect$HibernateConnectionHandle@4f1f2f84]
… main : Found thread-bound EntityManager [SessionImpl(1505756962<open>)] for JPA transaction
… main : Participating in existing transaction
…
… main : Updating stock for order 44b235f9-cd9a-4c52-a843-fc8dca34b62a.
… main : Sending email for order 44b235f9-cd9a-4c52-a843-fc8dca34b62a.
… main : Email sent for order 44b235f9-cd9a-4c52-a843-fc8dca34b62a.
… main : Finish order completion.
… main : Initiating transaction rollback
… main : Rolling back JPA transaction on EntityManager [SessionImpl(1505756962<open>)]
… main : Closing JPA EntityManager [SessionImpl(1505756962<open>)] after transaction
```

Note how the stock update is performed and the email is sent out. Due to the `RuntimeException` we throw at the very end of `OrderManagement.complete()` the transaction is rolled back eventually, leaving the email sent out for an uncompleted order. We would actually like to avoid that.

💡 Summary

In this lab we have seen how to replace direct Spring bean invocations by using Spring’s application event bus. This allows us to avoid the dependencies from the order module to break the cycle we had previously introduced accidentally.