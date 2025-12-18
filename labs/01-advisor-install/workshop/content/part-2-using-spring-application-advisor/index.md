---
title: Using Spring Application Advisor
---
# Using Spring Application Advisor

Now let's use the CLI to analyze and upgrade a Spring Boot project!


## Step 1: Get a local copy of your Project source

In our example, we're using Git to manage source for our project.  Git is not a strict requirement for advisor, it simply operates on whatever source code you give it.  Please check with your IT staff to learn how source code is managed in your organization.

Let's clone our application (Spring Pet Clinic), and switch to a detached branch that still uses Spring Boot 2.7:
```execute
git clone https://github.com/spring-projects/spring-petclinic
cd spring-petclinic
git branch advisor-demo 9ecdc1111e3da388a750ace41a125287d9620534
git checkout -f advisor-demo
```

When you ran the above commands, the second command changed to the root directory of our sample project.  This directory is where your build configuration files (`pom.xml` for Maven or `build.gradle` for Gradle) are located.  This is important, because these files are used by Application Advisor to collect relevant information about your project.

## Step 2: Generate a Build Configuration

The build configuration contains your dependency tree, Java version, and build tool versions:

```execute
advisor build-config get
```

You'll see output like:

```
Resolving the build configuration of $path.
🏃 [ 1 / 3 ] Resolving dependencies with "maven/gradle command" [3m 2s] ok
🏃 [ 2 / 3 ] Resolving JDK version [4s]
🏃 [ 3 / 3 ] Resolving build tool [1s]
🚀 Build configuration generated at $path/.advisor/build-config.json
```

The configuration is saved in `.advisor/build-config.json`.

### What Gets Analyzed?

The build configuration process examines:

- **Dependency Tree**: All your project dependencies in CycloneDX format
- **Java Version**: The JDK version required to compile your sources
- **Build Tool Versions**: Your Maven or Gradle version and configuration

### Handling Errors
You shouldn't see any errors in this lab.  However, running Application Advisor in your own environment will likely be vastly different from running in this controlled lab environment.  If you see error messages when you run advisor, you can always check the `.advisor/errors/` directory for detailed logs.

## Step 3: Generate an Upgrade Plan

Create a step-by-step upgrade plan:

```execute
advisor upgrade-plan get
```

You'll see an upgrade plan similar to:

```
🏃 Fetching and processing upgrade plan details [00m 01s] ok
 - Step 1:
    * Upgrade java from 8 to 11
 - Step 2:
    * Upgrade java from 11 to 17
 - Step 3:
    * Upgrade hibernate-orm from 5.6.x to 6.1.x
    * Upgrade spring-data-commons from 2.7.x to 3.0.x
    * Upgrade spring-boot from 2.7.x to 3.0.x
    * Upgrade spring-framework from 5.3.x to 6.0.x
    * Upgrade spring-data-jpa from 2.7.x to 3.0.x
    * Upgrade micrometer from 1.9.x to 1.10.x
 - Step 4:
    * Upgrade hibernate-orm from 6.1.x to 6.2.x
    * Upgrade spring-data-commons from 3.0.x to 3.1.x
    * Upgrade spring-boot from 3.0.x to 3.1.x
    * Upgrade spring-data-jpa from 3.0.x to 3.1.x
    * Upgrade micrometer from 1.10.x to 1.11.x
 - Step 5:
    * Upgrade hibernate-orm from 6.2.x to 6.4.x
    * Upgrade spring-data-commons from 3.1.x to 3.2.x
    * Upgrade spring-boot from 3.1.x to 3.2.x
    * Upgrade spring-framework from 6.0.x to 6.1.x
    * Upgrade spring-data-jpa from 3.1.x to 3.2.x
    * Upgrade micrometer from 1.11.x to 1.12.x
 - Step 6:
    * Upgrade hibernate-orm from 6.4.x to 6.5.x
    * Upgrade spring-data-commons from 3.2.x to 3.3.x
    * Upgrade spring-boot from 3.2.x to 3.3.x
    * Upgrade spring-data-jpa from 3.2.x to 3.3.x
    * Upgrade micrometer from 1.12.x to 1.13.x
 - Step 7:
    * Upgrade hibernate-orm from 6.5.x to 6.6.x
    * Upgrade spring-data-commons from 3.3.x to 3.4.x
    * Upgrade spring-boot from 3.3.x to 3.4.x
    * Upgrade spring-framework from 6.1.x to 6.2.x
    * Upgrade spring-data-jpa from 3.3.x to 3.4.x
    * Upgrade micrometer from 1.13.x to 1.14.x
 - Step 8:
    * Upgrade spring-data-commons from 3.4.x to 3.5.x
    * Upgrade spring-boot from 3.4.x to 3.5.x
    * Upgrade spring-data-jpa from 3.4.x to 3.5.x
    * Upgrade micrometer from 1.14.x to 1.15.x
```

### Understanding the Upgrade Plan

The upgrade plan shows:

- **Sequential Steps**: Upgrades are ordered to ensure compatibility
- **Version Changes**: Specific versions for each component
- **Dependencies**: Related framework upgrades that must happen together

## Step 4: Apply the Upgrade

Apply the upgrade plan locally:

```execute
advisor upgrade-plan apply
```

This command will perform the step at the top of the list:

1. Modify your source files with the necessary changes
2. Update your build configuration files (`pom.xml` or `build.gradle`)
3. Apply code transformations to maintain compatibility
4. Preserve your existing code style

### Reviewing Changes

After applying the upgrade:

1. Review all modified files carefully
2. Run your tests to ensure everything still works
3. Commit the changes to version control
4. Test your application thoroughly

**Important**: Spring Application Advisor preserves your coding style by making only the minimum required changes.
