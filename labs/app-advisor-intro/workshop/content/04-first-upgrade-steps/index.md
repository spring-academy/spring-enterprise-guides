---
title: Running our First Upgrade Steps
---

Patching keeps us on the latest patch versions, but our application is still based on *Spring Boot 2.7* and *Java 8*. To move to a supported open-source version, we have to run the **upgrade plan**.

#### Produce a build configuration
The first step in the upgrade process is to produce a **build configuration** for *Spring Application Advisor* using the `build-config get` command. This generates a file containing the dependency tree (in CycloneDX format), the Java version required to compile the sources, and the build tool versions.
```execute
advisor build-config get --help
```
You may have already noticed that our sample application contains configurations and wrappers for both Maven and Gradle. With the `--build-tool` option, you can select your preferred one for the upgrade. In our case, the default `mvnw` (Maven wrapper) works fine since we are already in the root of our sample application.
```execute
advisor build-config get
```

Let's have a look at the generated build configuration.
```editor:open-file
file: ~/spring-petclinic/target/.advisor/build-config.json
```

The `build-config get` command is optional. The `upgrade-plan` commands automatically run it behind the scenes if the build configuration is missing or outdated.

#### Analyze an upgrade plan

With the information in the generated build configuration, *Spring Application Advisor* can compute the **upgrade plan**. 

Optionally, you can review the upgrade plan to see which dependencies require upgrading and the exact sequence to follow.
```execute
advisor upgrade-plan get
```

The output has three parts:
- **Projects discovered** lists every project *Application Advisor* recognized in our dependency tree, with its current version and the latest one it knows about (e.g., `apache-commons-lang: 3.18.x -> 3.20.x`).
- The **steps** are the plan itself. Each step lists the projects that have to be upgraded *together*. `advisor upgrade-plan apply` always executes the first one, which is why upgrading is an iterative process.
- **Blockers and warnings** at the bottom report dependencies that could not be aligned, and version inconsistencies that look like configuration mistakes. We will come back to them in the section about custom upgrade mappings.

#### Why a step contains what it contains

Four rules decide which projects share a step:

- **Dependencies alignment** Every version of a project is built for specific versions of the projects it depends on, and those versions have to move together. Because Spring Boot 4.0.x expects Spring Framework 7.0.x, upgrading to it pulls Spring Framework into the same step.
- **Available recipes** They define which target versions are reachable at all. If the only recipe jumps from v1 straight to v3, the plan never offers you v2. You mostly see this with your own custom recipes.
- **The Spring Boot SBOM** The more projects an application uses, the more likely it is that two of them cannot be aligned. For everything managed by `spring-boot-dependencies`, conflicts are resolved from the `spring-boot` mappings, because the Spring team already tested which versions work together at runtime.
- **Semantic versioning** For Spring projects only, a new *minor* version is considered safe enough to upgrade to even if your other projects lag behind, a new *major* version is not. An internal starter that is still a few versions behind therefore never blocks a Spring Boot minor upgrade, and as soon as it is released and mapped, its own upgrade is picked up automatically.

All of this knowledge comes from the **upgrade mappings**, which we will customize later in this workshop.

#### Apply an upgrade plan from your local machine
Now it's time to run our first upgrade step with the `advisor upgrade-plan apply` command.
Let's look at the available options first.
```execute
advisor upgrade-plan apply --help
```

Some important options to be aware of:
- `--after-upgrade-cmd`: Automatically runs a Maven goal or Gradle task after the upgrade (we will use this later)
- `--build-tool-jvm-args` and `--build-tool-options`: Allow tweaking the JVM and build tools for larger code bases (e.g., increasing memory limits)
- `--push`: Automatically creates a remote branch, pushes the changes, and opens a pull request
- `--squash`: Combines multiple upgrade steps into one (we will explore this later)
- `--force`: Executes the full upgrade plan in one go
- `--from-yml`: References a `.spring-app-advisor.yml` file for enabling continuous upgrades in CI/CD

For now, we will run the steps locally without the `--push` option, as pull requests require a Git provider like GitHub, GitLab, or Bitbucket.

The first step of our upgrade plan is to **upgrade Java from 8 to 11**.
Since some of the latest recipes require Java 17 to be executed, let's set it for the terminal where we run the advisor CLI.
```terminal:execute
command: sdk use java $(sdk list java | grep -E 'installed|local only' | grep '17.*[0-9]-librca' | awk '{print $NF}' | head -n 1)
session: 1
```

Let's run the upgrade!
```execute
advisor upgrade-plan apply
```

We can discover the changes made to our code base with the Git CLI.
```execute
git status
git --no-pager diff pom.xml
```

Or use the *Source Control* view of the Visual Studio Code editor as an alternative.
```editor:execute-command
command: workbench.view.scm
description: Open the "Source Control" view in editor
```

Let's commit and push the changes before we move on with our upgrade plan.
```terminal:execute
description: Commit and push changes in terminal
command: git add . && git commit -m "Upgrading Java 8 to 11" && git push
session: 1
```

#### Checking the next upgrade step

Let's check the next step in the upgrade plan.
```execute
advisor upgrade-plan get
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
