---
title: Custom Upgrade Mappings for Shared Libraries
---

Most organizations have **shared Java libraries and components** used across multiple Spring applications. When these shared libraries depend on Spring, upgrading the applications that use them requires coordination -- you need to ensure the shared library version is compatible with the target Spring Boot version.

By default, *Application Advisor* prevents upgrading applications when it encounters libraries that depend on Spring but have no known upgrade mappings. Let's see this in action with a real example.

#### Adding a third-party library

Let's add a [corporate-starter](https://github.com/timosalm/saa-corporate-starter-sample) sample library to our project.

```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "</dependencies>"
description: Add corporate-starter dependency to POM
before: 0
after: 0
cascade: true
```
```editor:replace-text-selection
file: ~/spring-petclinic/pom.xml
hidden: true
text: |2
          <dependency>
            <groupId>com.example</groupId>
            <artifactId>corporate-starter</artifactId>
            <version>1.0.0</version>
          </dependency>
      </dependencies>
```

Now let's see what happens when we try to get the upgrade plan.
```execute
advisor build-config get && advisor upgrade-plan get
```

*Application Advisor* reports that it **cannot create an upgrade plan** because `corporate-starter` uses Spring dependencies (spring-framework, spring-boot, micrometer) but has no upgrade mappings configured. This blocks upgrades for spring-boot, spring-data, hibernate-orm, and other projects.

#### Forcing an upgrade with `--force`

The `--force` flag forces execution of the upgrade plan including intermediate dependencies, even when some libraries block the upgrade. Let's commit our changes and try it.
```execute
git add pom.xml && git commit -m "Add corporate-starter dependency to POM"
```
```execute
advisor upgrade-plan apply --force --after-upgrade-cmd=spring-javaformat:apply
```

The upgrade succeeds for the core Spring projects, but notice the warning: *Application Advisor* might produce a **partial upgrade**. If we check the `pom.xml`, we'll see that `corporate-starter` is still at version **4.0.0** -- it was not upgraded because there are no mappings telling *Application Advisor* which version is compatible with the new Spring Boot version.

```execute
grep -A 3 "corporate-starter" pom.xml
```

This is not ideal. We want *Application Advisor* to also update the `corporate-starter` version to one that is compatible with the upgraded Spring Boot version. Let's revert these changes and solve this properly with custom mappings.
```execute
git checkout .
```

#### Generating mappings with `advisor mapping build`

Instead of writing mapping files manually, *Application Advisor* provides the `advisor mapping build` command to **auto-generate** mapping files from a Git repository. It checks out each tagged version of the project, generates the build configuration for each, and produces a complete mapping file.

Let's generate the mapping for `corporate-starter` directly from its GitHub repository.
```execute
advisor mapping build -r https://github.com/timosalm/saa-corporate-starter-sample --offline -c='com.example:corporate-starter'
```

This command analyzes all released versions of the library and produces a mapping file in the `.advisor/mappings/` directory. Let's look at the generated mapping.
```execute
ls .advisor/mappings/
cat .advisor/mappings/saa-corporate-starter-sample.json
```

The mapping file describes each version of `corporate-starter` and its Spring compatibility -- which Java version it requires, which Spring Boot generation it supports, and what the next version to upgrade to is.

#### Configuring the custom mapping

Now let's configure *Application Advisor* to use this mapping. The simplest approach is to set the `SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH` environment variable to point to the generated mapping file.
```execute
export SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH=$(pwd)/.advisor/mappings/saa-corporate-starter-sample.json
```

Let's check the upgrade plan again with the mapping configured.
```execute
advisor build-config get && advisor upgrade-plan get
```

Now *Application Advisor* knows about the `corporate-starter` versions and their Spring Boot compatibility. The upgrade plan should now include upgrading `corporate-starter` alongside the other Spring dependencies.

Let's run the upgrade.
```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

Let's verify that `corporate-starter` was properly upgraded this time.
```execute
grep -A 3 "corporate-starter" pom.xml
```

The `corporate-starter` version has been updated to a version that is compatible with the upgraded Spring Boot version. This is the power of custom mappings -- *Application Advisor* can now orchestrate upgrades for your internal or third-party libraries alongside the core Spring dependencies.

After reviewing the changes, **commit and push them**.
```terminal:execute
description: Commit and push changes
command: git add . && git commit -m "Add corporate-starter with custom mapping and upgrade" && git push
session: 1
```

#### Providing custom mappings in production

In a production environment, there are three ways to provide custom mappings to *Application Advisor*:

1. **File system**: Set `SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH` to point to the mapping file (as we just did).

2. **Git repository**: Store mappings in a Git repository and configure with:
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_GIT_URI` for the repo URL
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_GIT_PATH` for a subfolder
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_GIT_BRANCH` for a specific branch

3. **JFrog Artifactory**: Store mappings in Artifactory and configure with:
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_ARTIFACTORY_URI`
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_ARTIFACTORY_TOKEN`
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_ARTIFACTORY_REPOSITORY`
   - `SPRING_ADVISOR_MAPPING_CUSTOM_0_ARTIFACTORY_GAV`

You can configure multiple custom mappings by incrementing the index (e.g., `CUSTOM_0`, `CUSTOM_1`, etc.).
