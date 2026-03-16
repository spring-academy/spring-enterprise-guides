---
title: Upgrading to Spring Boot 4
---

We have arrived at the final milestone of our upgrade journey -- **Spring Boot 4**!

Our application has come a long way: from Spring Boot 2.7 with Java 8, through the Jakarta EE migration, through multiple minor version upgrades, and now we are ready for the latest major version.

Let's check the current upgrade plan.
```execute
advisor build-config get && advisor upgrade-plan get
```

The upgrade plan should show the step to upgrade to **Spring Boot 4.0**. Let's apply it!
```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

Let's review the changes that *Application Advisor* has made for this major version upgrade.
```execute
git --no-pager diff --stat
```

```editor:execute-command
command: workbench.view.scm
description: Open the Source Control view in editor to review changes
```

Now let's verify that our application still runs correctly on Spring Boot 4.
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

Our application has been successfully upgraded from **Spring Boot 2.7 / Java 8** all the way to **Spring Boot 4**!

Commit and push the final upgrade.
```terminal:execute
description: Commit and push the Spring Boot 4 upgrade
command: git add . && git commit -m "Upgrading to Spring Boot 4" && git push
session: 1
```

#### Recap of the upgrade journey

Throughout this workshop, we performed the following upgrades:
1. **Java 8 to 11** -- Incremental Java upgrade
2. **Java 11 to 17** -- Required baseline for Spring Boot 3.x
3. **Spring Boot 2.7 to 3.0** -- Major upgrade with Jakarta EE migration
4. **Spring Boot 3.0 to 3.1** -- Step-by-step minor upgrade with `--debug`
5. **Spring Boot 3.1 to 3.3** -- Using `--squash=2` to combine two steps
6. **Spring Boot 3.3 to 3.5** -- Completing the remaining minor upgrades
7. **Added htmx-spring-boot** -- Learned custom mappings and `--force` for handling unmapped libraries
8. **Spring Boot 3.5 to 4.0** -- The final major upgrade

Each step was handled automatically by *Spring Application Advisor*, from simple dependency version bumps to complex API migrations and namespace changes.
