---
title: Spring Boot 2.7 to 3.0 Upgrade
---

Now it's time for the most impactful upgrade of our journey -- the migration from **Spring Boot 2.7 to 3.0**. This is where *Spring Application Advisor* really shines.

The Spring Boot 3.0 upgrade involves significant changes:
- **Jakarta EE 9+ migration**: All `javax.*` package imports are replaced with `jakarta.*` (e.g., `javax.persistence` becomes `jakarta.persistence`)
- **Spring Framework 6**: New baseline with updated APIs and deprecation removals

Let's get the latest upgrade plan.
```execute
advisor build-config get && advisor upgrade-plan get
```

Now let's run the Spring Boot 2.7 to 3.0 upgrade.
```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

By switching to the *Source Control* view in the embedded editor, you can have a closer look at all the changes applied to our code base.
```editor:execute-command
command: workbench.view.scm
description: Open the Source Control view in editor
```

Pay special attention to the Java source files -- you will, for example, see the `javax` to `jakarta` namespace migration that *Application Advisor* handled automatically.

Without *Spring Application Advisor*, this migration would require manually updating dozens of files.

After reviewing all the changes, **commit and push them**.

(Optional) View, commit, and push changes via the terminal
```terminal:execute
description: Show, commit and push changes in terminal
command: git add . && git commit -m "Upgrading Spring Boot 2.7 to 3.0" && git push
session: 1
```

Let's verify the application still works after this major upgrade.
```terminal:execute
command: ./mvnw spring-boot:run
session: 2
```
```dashboard:open-url
url: {{< param  ingress_protocol >}}://petclinic-{{< param  session_name >}}.{{< param  ingress_domain >}}
```

```terminal:interrupt
session: 2
```
