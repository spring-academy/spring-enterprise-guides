---
title: Your First Step(s) With Spring Application Advisor
---

#### Sample Application

To discover the capabilities of *Spring Application Advisor*, we will use a well known application: [Spring Petclinic](https://github.com/spring-projects/spring-petclinic).
*Spring PetClinic* is a sample application designed to show how the Spring stack can be used to build simple, but powerful database-oriented applications. It demonstrates the use of Spring Boot with Spring MVC and Spring Data JPA.

*Spring PetClinic* is constantly upgraded to the latest versions, so we go back in time and check-out a version from around two years ago when it was still **based on Spring Boot 2.7 and Java 8**.

```execute
git clone {{< param  git_protocol >}}://{{< param  git_host >}}/spring-petclinic && cd spring-petclinic
```

```editor:open-file
file: ~/spring-petclinic/pom.xml
description: Open Maven POM to see used Spring Boot and Java version
line: 1
```
```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "<version>2.7.18</version>"
```
```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "<java.version>1.8</java.version>"
```

The Spring Boot migration from Spring Boot version 2.7 to 3.x (and Spring Framework 6) is challenging due to baseline changes to **Java 17+**, and **Jakarta EE 9+**.
Without a *VMware Spring Enterprise* subscription, [Spring Boot 2.7 is end of support](https://spring.io/projects/spring-boot#support) since 11/2023, which means that no new security fixes will be released as open-source.

Let's run *Spring PetClinic* to validate that it works before our upgrade.
```terminal:execute
command: cd spring-petclinic && ./mvnw spring-boot:run
session: 2
```

When the application has started, click here to open a new browser tab with the running application.
```dashboard:open-url
url: {{< param  ingress_protocol >}}://petclinic-{{< param  session_name >}}.{{< param  ingress_domain >}}
```

Kill the application.
```terminal:interrupt
session: 2
```

#### Exploring the advisor CLI

*Spring Application Advisor*'s native CLI is called **advisor** and is available for all common operating systems.

Let's start by exploring the available commands.
```execute
advisor --help
```

As you can see, it supports the `build-config`, `upgrade-plan`, `patch`, `mapping`, and `advice` commands. In this workshop, we will focus primarily on the patch and upgrade workflows.

#### Patching our application to the latest available versions

Before we start the (much bigger) journey of upgrading to a new Spring Boot minor or major version, let's get the **quickest win** first: applying the latest **patch versions** of all the dependencies our application already uses.

The `advisor patch apply` command calculates the latest patch versions for all the dependencies in the Software Bill of Materials (SBOM) of our application and applies them to the `pom.xml` (or `build.gradle`) files. It stays **within the same minor version**, so it is a low-risk change that:
- Updates explicit dependency versions
- Refreshes the parent project version
- Modifies managed dependencies and adds new managed dependencies when patch versions become available
- Updates imported SBOM dependency versions while removing redundant libraries

This is especially valuable for our sample application as *Spring Boot 2.7* reached its open-source end of support in 11/2023, so no new open-source patch releases are published for it. With a *VMware Spring Enterprise* subscription, our Maven repositories are configured to access the **Spring Enterprise Maven repository**, which provides commercial patch and hotfix versions with security fixes for those versions. That means we can close known vulnerabilities **today**, without waiting for the full Spring Boot 3.x upgrade to be finished.

{{< note >}}
In this workshop environment, the access to the Spring Enterprise Maven repository is already configured for you. In your own environment, you have to configure it in your Maven `settings.xml` or your Gradle build. For Gradle setups with internal-only repositories, the environment variables `ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY`, `ADVISOR_DEFAULT_OSS_PLUGINS_USERNAME`, and `ADVISOR_DEFAULT_OSS_PLUGINS_PASSWORD` have to be set as well.
{{< /note >}}

Let's look at the available options first.
```execute
advisor patch apply --help
```

Some important options to be aware of:
- `--push`: Automatically creates a remote branch, pushes the changes, and opens a pull request
- `--from-yml`: Reads the configuration from an `.advisor.yml` file in the repository root
- `--scm-host`: The hostname of a self-hosted Git server like GitLab or GitHub Enterprise

We will get back to `--push` and `--from-yml` in the section about continuous upgrades at the end of this workshop. For now, we run the patch locally.

Let's patch our application!
```execute
advisor patch apply
```

{{< note >}}
This command queries the Maven repositories for every single dependency of our application, which is why it usually takes a few minutes. This is another reason why it is a perfect fit for a scheduled CI/CD pipeline.
{{< /note >}}

Once it has finished, the CLI lists all the upgraded dependencies grouped by scope (compile, provided, runtime, test) with their version transitions and prints a summary like `🚀 Patch apply complete: 67 dependency(-ies) upgraded in 1 file(s).`

We can discover the changes made to our code base with the Git CLI.
```execute
git status
git --no-pager diff pom.xml
```

As an alternative, we can use the *Source Control* view of the Visual Studio Code editor in the workshop environment.
```editor:execute-command
command: workbench.view.scm
description: Open the "Source Control" view in editor
```

In the *Source Control* view, click on the files listed under *Changes* (in our case only `pom.xml`) to see the details.

Because patching stays within the same minor version, no source code changes are required. Let's still validate that our application works as expected by running the tests.
```terminal:execute
command: ./mvnw test
session: 2
```

Let's commit and push the changes before we move on to our upgrade plan.
To do this, enter a commit message like `Patch dependencies to the latest available versions` in the *Message* field, click on the down arrow on the right of the commit button and select *Commit & Push*.
