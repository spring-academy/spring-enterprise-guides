---
title: 'Designing Modules - Using Application Modules to control visibility'
---

```terminal:execute-all
command: cd ~/exercises/20-designing-application-modules/initial
autostart: true
hidden: true
```

```dashboard:open-dashboard
name: Editor
autostart: true
hidden: true
```

🎯 Objectives

You’ll learn how to…
- add components and events to the module and control their visibility
- verify foreign application modules cannot access internal components

👣 Hiding application module internals by using the package scope

Add an `OrderRepository` class in default scope to the `order` package
```editor:append-lines-to-file
file: ~/exercises/20-designing-application-modules/initial/src/main/java/com/example/app/order/OrderRepository.java
text: |
    package com.example.app.order;
    
    import org.springframework.stereotype.Repository;
    
    @Repository
    class OrderRepository {}
```

Create a Spring bean reference to the `OrderRepository` in `OrderManagement`.
```editor:select-matching-text
file: ~/exercises/20-designing-application-modules/initial/src/main/java/com/example/app/order/OrderManagement.java
text: "public class OrderManagement {}"
before: 2
after: 0
```

```editor:replace-text-selection
file: ~/exercises/20-designing-application-modules/initial/src/main/java/com/example/app/order/OrderManagement.java
text: |
    import lombok.RequiredArgsConstructor;
    
    @Component
    @RequiredArgsConstructor
    public class OrderManagement {
    
        private final OrderRepository repository;
    }
```

Re-run `ApplicationModularityTests`.

[//]: # (```terminal:execute)

[//]: # (command: ./mvnw -f ~/exercises/20-designing-application-modules/initial test)

[//]: # (```)

[//]: # ()
[//]: # (OR)
```terminal:execute
command: mvnw test
```

See how the output shows that `OrderRepository` is detected as internal module component (the `o` in front of the type name).
```
# Order
> Logical name: order
> Base package: com.example.app.order
> Direct module dependencies: none
> Spring beans:
  + ….OrderManagement
  o ….OrderRepository
```

Try to add a reference to `OrderRepository` from `ApplicationModularityTests`.

**TO-DO: VERIFY WITH OLLIE THAT THE BELOW IS OK**

```editor:select-matching-text
file: ~/exercises/20-designing-application-modules/initial/src/test/java/com/example/app/ApplicationModularityTests.java

text: "class ApplicationModularityTests {"
before: 0
after: 0
```

```editor:replace-text-selection
file: ~/exercises/20-designing-application-modules/initial/src/test/java/com/example/app/ApplicationModularityTests.java
text: |
    import com.example.app.order.OrderRepository;
    
    class ApplicationModularityTests {
    
        OrderRepository orderRepository;
```

See how the compiler prevents that.
```terminal:execute
command: ./mvnw -f ~/exercises/20-designing-application-modules/initial test
```

```
[INFO] -------------------------------------------------------------
[ERROR] COMPILATION ERROR : 
[INFO] -------------------------------------------------------------
[ERROR] /home/eduk8s/exercises/20-designing-application-modules/initial/src/test/java/com/example/app/ApplicationModularityTests.java:[24,29] com.example.app.order.OrderRepository is not public in com.example.app.order; cannot be accessed from outside package
```

**TO-DO: EXPLAIN THAT THIS IS BECAUSE THE CLASS IS NOT PUBLIC? EXPLAIN THIS MORE TO CUE UP THE NEXT  **

👣 Hiding components in nested packages

Introduce a package named `order.persistence` and move `OrderRepository` to that package. 
```terminal:execute
command: |
    mkdir -p src/main/java/com/example/app/order/persistence
    m src/main/java/com/example/app/order/persistence/OrderRepository.java
    sed -i "s/package com\.example\.app\.order;/package com\.example\.app\.order\.persistence;/ src/main/java/com/example/app/order/persistence/OrderRepository.java
    sed -i "s/import com\.example\.app\.order.\OrderRepository;/import com\.example\.app\.order\.persistence.\OrderRepository;/ src/test/java/com/example/app/ApplicationModularityTests.java
```

To resolve the compiler error this creates in `OrderManagement`, change the visibility of the repository type to `public`.
```editor:select-matching-text
file: ~/exercises/20-designing-application-modules/initial/src/main/java/com/example/app/order/persistence/OrderRepository.java
text: class OrderRepository
```

```editor:replace-text-selection
file: ~/exercises/20-designing-application-modules/initial/src/main/java/com/example/app/order/persistence/OrderRepository.java
text: public class OrderRepository
```

Re-run `ApplicationModularityTests`.
```terminal:execute
command: ./mvnw -f ~/exercises/20-designing-application-modules/initial test
```

See how the output shows that `OrderRepository` is still considered an internal component (the leading o in front of it) as it does not reside in the API package.
```
…
# Order
> Logical name: order
> Base package: com.example.app.order
> Direct module dependencies: none
> Spring beans:
+ ….OrderManagement
  o ….persistence.OrderRepository
```
