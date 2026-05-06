---
title: Verifiying the CLI Install
---
# Verifying the CLI Install

> **Note:**
> Spring Application Advisor uses commercial recipes that are to perform upgrades. These recipes used to be accessed through a Maven repository and require alterations to the ~/.m2/settings.xml configuration file to access via a Token, but that has changed as of version 1.6 of the CLI.  You now no longer need to alter your Maven settings for Advisor.  You may have other environment restrictions that require a specialized Maven configurations (Maven repository mirrors, private artifact repositories, etc).  Configuring these settings is out of scope for this lab, but refer to [https://maven.apache.org/settings.html] for information about Maven settings.

## Verify the CLI

Let's verify that the CLI is working by running the advisor against a small test application.  We've already extracted on for you under the ~/hello-spring-boot-1-5 directory.  If you want to use this sample app for testing in your own environment, you can grab it from https://github.com/dashaun/hello-spring-boot-1-5.

Navigate to the test application:

```execute
cd ~/hello-spring-boot-1-5
```

This is a simple Spring Boot 1.5 application - perfect for testing that everything is configured correctly.

First, let's see what version of Spring Boot it's currently using:

```execute
grep -A5 '<parent>' pom.xml
```

Now, generate the build configuration:

```execute
advisor build-config get
```

You should see output showing the advisor analyzing the project's dependencies and build tools.

Next, get the upgrade plan:

```execute
advisor upgrade-plan get
```

This shows the step-by-step upgrade path from Spring Boot 1.5 to the latest version.

Finally, apply the first upgrade step to verify the recipes work:

```execute
advisor upgrade-plan apply
```

If this command completes successfully, it means:
- The CLI is installed correctly
- Maven can access the recipe repository
- The commercial recipes can be resolved and executed

Let's verify the upgrade was applied:

```execute
grep -A5 '<parent>' pom.xml
```

You should see the Spring Boot version has been upgraded.

Congratulations! Your Spring Application Advisor installation is complete and verified. The CLI can download and execute the commercial upgrade recipes.
