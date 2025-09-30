---
title: 'Designing Modules - Establishing relationships between modules'
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

You’ll learn how to
- establish relationships between modules via Spring bean references
- detect invalid dependencies via a JUnit-based architectural fitness function

👣 Managing type relationships

Introduce inventory

Create Inventory

Add constructor argument of type OrderManagement

add verify()

Run test → green

Change constructor argument to OrderRepository → red as it’s an internal component