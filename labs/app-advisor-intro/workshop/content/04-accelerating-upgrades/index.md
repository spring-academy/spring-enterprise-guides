---
title: Accelerating Upgrades with Advanced Flags
---

Now that we have completed the major Spring Boot 2.7 to 3.0 upgrade, the remaining steps are incremental minor version upgrades. Let's first do one more step-by-step upgrade, and then learn how to **accelerate** the process.

#### Step-by-step: Spring Boot 3.0 to 3.1

By adding the `--debug` option to `advisor build-config get` and `advisor upgrade-plan apply`, we can get a better understanding of what's happening underneath -- for example, which OpenRewrite recipes are being applied.
```terminal:execute
command: |
  advisor build-config get --debug
  advisor upgrade-plan get
  advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply --debug
```

After reviewing the changes, **commit and push them**.
```terminal:execute
description: Show, commit and push changes in terminal
command: git --no-pager diff && git add . && git commit -m "Upgrading Spring Boot 3.0 to 3.1" && git push
session: 1
```

#### Squashing multiple upgrade steps with `--squash`

So far, we have been running one upgrade step at a time. This is **by design and recommended** — upgrading incrementally lets you follow the changes introduced by each specific version and reduces the cognitive load of reviewing and understanding what changed. However, if you are several minor versions behind and want to move faster, the `--squash` flag allows you to **combine multiple upgrade steps into a single step**.

The `--squash=<N>` option takes a number that specifies how many steps of the original upgrade plan should be squashed together as the first step. Let's see this in action.

First, let's check what the current upgrade plan looks like.
```execute
advisor build-config get && advisor upgrade-plan get
```

You should see multiple remaining steps (3.1 to 3.2, 3.2 to 3.3, etc.). Instead of executing them one by one, let's **squash 3 steps** into one, which will combine the 3.1->3.2, 3.2->3.3, and 3.3->3.4 upgrades.
```execute
advisor upgrade-plan apply --squash=3 --after-upgrade-cmd=spring-javaformat:apply
```

Notice how *Application Advisor* combined three upgrade steps and applied all the necessary recipe changes at once. Let's verify the changes and commit them.
```execute
git --no-pager diff --stat
```

```terminal:execute
description: Commit and push the squashed upgrade
command: git add . && git commit -m "Upgrading Spring Boot 3.1 to 3.4 (squashed)" && git push
session: 1
```

Let's verify the application still runs correctly after all the upgrades.
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

#### Handling dependency conflicts with `--accept-no-alignment`

In some cases, *Application Advisor* may report that dependencies have conflicting versions and cannot be aligned. By default, it will not proceed with the upgrade in this situation.

The `--accept-no-alignment` flag allows you to override this behavior and apply the first step of the upgrade plan even when dependencies are not aligned. This can be useful in cases where you know the misalignment is acceptable or temporary.

Note that using `--accept-no-alignment` means the code might not compile successfully if there are genuine incompatibilities. Always verify your application after using this flag.
