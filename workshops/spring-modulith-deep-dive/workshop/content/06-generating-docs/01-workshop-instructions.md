---
title: 'Generating Docs - Generating application module documentation'
---

```terminal:execute-all
command: cd ~/exercises/60-documentation/initial
autostart: true
hidden: true
```

```editor:open-file
file: ~/exercises/60-documentation/initial/src/main/java/com/example/app/Application.java
autostart: true
hidden: true
```

🎯 Objectives

👣 Documentation

Create an instance of `Documenter` by handing the `ApplicationModules` instance you have just created into its constructor.

On that `Documenter` instance, call `createDocumentation()`.

Run `ApplicationModularityTests`.

👣 Documenting Spring Boot Configuration Properties

Add Spring Boot configuration properties type to project

```
Unresolved directive in ../../../60-documentation/60-documentation.adoc - include::complete/src/main/java/com/acme/sample/inventory/InventoryProperties.java[]
```

Add configuration properties processor to project

Re-run `ApplicationModularityTests` and see how