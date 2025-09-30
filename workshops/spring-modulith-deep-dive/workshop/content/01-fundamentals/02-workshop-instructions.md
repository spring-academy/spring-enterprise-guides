---
title: 'Fundamentals - Creating Application Modules'
---

🎯 Objectives

You’ll learn how to
- create an application module within the application.

👣 Preparations

Create a test class in the application’s root package in `src/test/java` named `ApplicationModularityTests`.

```terminal:execute
command: mkdir -p src/test/java/com/example/app
```

```editor:append-lines-to-file
file: ~/exercises/10-fundamentals/initial/src/test/java/com/example/app/ApplicationModularityTests.java
text: |
    package com.example.app;
    
    class ApplicationModularityTests {
    }
```

Within that class, create a test case to create a new instance of `ApplicationModules` pointing to the root Spring Boot application class.
```editor:select-matching-text
file: ~/exercises/10-fundamentals/initial/src/test/java/com/example/app/ApplicationModularityTests.java
text: "class ApplicationModularityTests {"
before: 0
after: 1
```

```editor:replace-text-selection
file: ~/exercises/10-fundamentals/initial/src/test/java/com/example/app/ApplicationModularityTests.java
text: |

    import org.junit.jupiter.api.Test;
    import org.springframework.modulith.core.ApplicationModules;

    class ApplicationModularityTests {
    
        @Test
        void bootstrapsApplicationModules() {
    
            var modules = ApplicationModules.of(Application.class);
    
            System.out.println(modules);
        }
    }
```

Print the result of `ApplicationModularityTests.toString()` to the console.

[//]: # (```terminal:execute)

[//]: # (command: ./mvnw -f ~/exercises/10-fundamentals/initial test)

[//]: # (```)

[//]: # (OR)
```terminal:execute
command: mvnw test
```

Note how it stays empty at first.
```
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.app.ApplicationModularityTests
16:20:25.394 [main] INFO com.tngtech.archunit.core.PluginLoader -- Detected Java version 17.0.7
```

👣 Adding a Module

Create a package `order`.
```terminal:execute
command: mkdir -p src/main/java/com/example/app/order
```

Add a public type `OrderManagement` in that package.
```editor:append-lines-to-file
file: ~/exercises/10-fundamentals/initial/src/main/java/com/example/app/order/OrderManagement.java
text: |
    package com.example.app.order;
    
    import org.springframework.stereotype.Component;
    
    @Component
    public class OrderManagement {}
```

Re-run the test case.

[//]: # (```terminal:execute)

[//]: # (command: ./mvnw -f ~/exercises/10-fundamentals/initial test)

[//]: # (```)

[//]: # ()
[//]: # (OR)
```terminal:execute
command: mvnw test
```

Note that an application module named `Order` is listed, as well as `OrderManagement` as public component.
``` 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.example.app.ApplicationModularityTests
16:20:37.029 [main] INFO com.tngtech.archunit.core.PluginLoader -- Detected Java version 17.0.7
# Order
> Logical name: order
> Base package: com.example.app.order
> Direct module dependencies: none
> Spring beans:
  + ….OrderManagement
```

💡 Further ideas

- What happens if you add sibling packages to `order` containing Spring bean classes in them?
- How does changing the visibility modifier of the types in the packages change the test output?
- How does the test output change if you introduce a dependency between components in different modules?