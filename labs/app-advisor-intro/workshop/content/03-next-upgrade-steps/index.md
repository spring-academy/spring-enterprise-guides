---
title: Next Upgrade Step and Configuration Options
---

After each upgrade step, we need to regenerate the build configuration and check the next step in the upgrade plan.
```execute
advisor build-config get && advisor upgrade-plan get
```

If the first upgrade step was successfully applied, you should now see that the next step is the **Java 11 to 17 upgrade**. Java 17 is required because Spring Boot 3.x and Spring Framework 6 have a baseline requirement of Java 17.

#### Preserving your coding style

**Spring Application Advisor preserves your coding style** by making the minimum required changes to the source files. However, it does not take Maven or Gradle formatters configured in your projects into account.

Our sample application uses the `spring-javaformat` Maven plugin, which enforces a specific code formatting style.
```editor:open-file
file: ~/spring-petclinic/pom.xml
description: Open Maven POM to see the configured formatter
line: 115
```

Fortunately, we can use the `--after-upgrade-cmd` option of the `advisor upgrade-plan apply` command to automatically execute the `spring-javaformat:apply` Maven goal after applying the upgrade. This ensures the upgraded code still passes the formatter check.
```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

Let's validate that everything works as expected by compiling and running our application.
Since we upgraded our source code to Java 17, we need to switch the Java runtime in our environment as well.
```terminal:execute
command: sdk use java $(sdk list java | grep -E 'installed|local only' | grep '17.*[0-9]-librca' | awk '{print $NF}' | head -n 1)
session: 2
```
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

You can either switch to the *Source Control* view of the embedded editor to **commit and push the changes** or use the terminal command below.

```editor:execute-command
command: workbench.view.scm
description: Open the "Source Control" view in editor
```
Don't forget to enter a commit message. Otherwise, you will need to add it to the file that opens in the editor and close the file.

(Optional) View, commit, and push changes via the terminal
```terminal:execute
description: Show, commit and push changes in terminal
command: git --no-pager diff && git add . && git commit -m "Upgrading Java 11 to 17" && git push
session: 1
```
