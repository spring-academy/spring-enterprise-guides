---
title: Custom Upgrade Mappings for Shared Libraries
---

Most organizations have **shared Java libraries and components** used across multiple Spring applications. When these shared libraries depend on Spring, upgrading the applications that use them requires coordination. You need to ensure the shared library version is compatible with the target Spring Boot version.

By default, *Application Advisor* prevents upgrading applications when it encounters libraries that depend on Spring but have no known upgrade mappings. Let's see this in action with a real example.

#### Adding a third-party library

Let's add a [corporate-starter](https://github.com/timosalm/saa-corporate-starter-sample) sample library to our project.

```editor:select-matching-text
file: ~/spring-petclinic/pom.xml
text: "<!-- end of webjars -->"
description: Add corporate-starter dependency to POM
before: 0
after: 0
cascade: true
```
```editor:replace-text-selection
file: ~/spring-petclinic/pom.xml
hidden: true
text: |2
      <!-- end of webjars -->

      <dependency>
        <groupId>com.example</groupId>
        <artifactId>corporate-starter</artifactId>
        <version>1.0.0</version>
      </dependency>
```

Now let's see what happens when we try to get the upgrade plan.
```execute
advisor upgrade-plan get
```

*Application Advisor* reports that it **cannot create an upgrade plan** because `corporate-starter` uses Spring dependencies, but has no upgrade mappings for them configured. Without those mappings it has no idea which newer versions of the library exist or what they depend on, so it stops instead of quietly leaving the library and its Java API usages behind in an unstable state.

The same thing happens with transitive dependencies, where the report also names the artifact that pulls the unmapped project in and lists the upgrades it holds back. 
```
The projects ["spring-framework", "reactive-streams", "cxf", "opensaml"] could not be included in the Upgrade Plan because they are used as transitive dependencies for other projects, and no upgrades are configured for them.
Ask your administrator to configure the projects of the following dependencies:

	- org.apache.wss4j:wss4j-ws-security-dom
		uses:
			- opensaml
		blocking upgrades for:
			- cxf
			- spring-framework
			- reactive-streams
	...
```

Either way the fix is a mapping, which you write yourself for your own libraries. If the reported artifacts turn out to be dependencies used by Spring projects, it is the mappings shipped with *Application Advisor* that need fixing, so open a [support ticket](https://support.broadcom.com) for those. Until the mapping exists, you can still upgrade everything else with the `--force` flag.

#### Forcing an upgrade with `--force`

The `--force` flag executes the upgrade plan including intermediate dependencies, even when some libraries block the upgrade. Let's commit our changes and try it.
```execute
git add pom.xml && git commit -m "Add corporate-starter dependency to POM"
```
```execute
advisor upgrade-plan apply --force --after-upgrade-cmd=spring-javaformat:apply
```

The upgrade succeeds for the core Spring projects, but notice the warning: *Application Advisor* might produce a **partial upgrade**. If we check the `pom.xml`, we'll see that `corporate-starter` is still at version **1.0.0**. It was not upgraded because there are no mappings telling *Application Advisor* which version is compatible with the new Spring Boot version.

```execute
grep -A 3 "corporate-starter" pom.xml
```

This is not ideal. We want *Application Advisor* to also update the `corporate-starter` version to one that is compatible with the upgraded Spring Boot version. Let's revert these changes and solve this properly with custom mappings.
```execute
git checkout .
```

#### Generating mappings with `advisor mapping create`

Instead of writing mapping files manually, *Application Advisor* provides the `advisor mapping create` command to **auto-generate** mapping files from a Git repository. It checks out each tagged version of the project, generates the build configuration for each, and produces a complete mapping file.

Let's generate the mapping for `corporate-starter` directly from its GitHub repository.
```execute
advisor mapping create --coordinate 'com.example:corporate-starter'
```

This command analyzes all released versions of the library and produces a mapping file in the `.advisor/mappings/` directory. Let's look at the generated mapping.
```execute
ls .advisor/mappings/
cat .advisor/mappings/corporate-starter.json
```

The mapping file describes each version of `corporate-starter` and its Spring compatibility, which Java version it requires, which Spring Boot generation it supports, and what the next version to upgrade to is.



#### Configuring the custom mapping

Now let's configure *Application Advisor* to use this mapping. The simplest approach is to set the `SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH` environment variable to point to the generated mapping file.
```execute
export SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH=$(pwd)/.advisor/mappings/corporate-starter.json
```

Let's check the upgrade plan again with the mapping configured.
```execute
advisor upgrade-plan get
```

Now *Application Advisor* knows about the `corporate-starter` versions and their Spring Boot compatibility. The upgrade plan should now include upgrading `corporate-starter` alongside the other Spring dependencies.

Run the upgrade.
```execute
advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

Verify that `corporate-starter` was properly upgraded this time.
```execute
grep -A 3 "corporate-starter" pom.xml
```

The `corporate-starter` version has been updated to a version that is compatible with the upgraded Spring Boot version. This is the power of custom mappings, *Application Advisor* can now orchestrate upgrades for your internal or third-party libraries alongside the core Spring dependencies.

After reviewing the changes, **commit and push them**.
```terminal:execute
description: Commit and push changes
command: git add . && git commit -m "Add corporate-starter with custom mapping and upgrade" && git push
session: 1
```

#### Customization of provided mappings and recipes

*Application Advisor* 1.6.6 introduced new commands to help you extract and customize upgrade mappings and recipes.

The `advisor mapping search` command enables users to iteratively search and directly extract specific upgrade mappings.

You can search through available project slugs by prefix. 
```execute
advisor mapping search --prefix spring-b
```

Select the `spring-boot` result by **entering number 3 and confirm by pressing enter**.

Also confirm the download location, by **entering `y`, and press enter again.** 

If you already now the slug, you can download the mapping directly.
```execute
advisor mapping search --slug spring-boot
```

Open the downloaded mapping file:
```editor:open-file
file: ~/spring-petclinic/.advisor/mappings/spring-boot.json
```

To configure your customized mapping file to override the default provided mapping, set the  `SPRING_ADVISOR_MAPPING_CUSTOM_0_FILEPATH` and `SPRING_ADVISOR_MAPPING_CUSTOM_0_MERGE_STRATEGY=override` environment variables.

If you also need to customize a recipe referenced within an upgrade mapping, the OpenRewrite recipe definition can be fetched using `advisor recipe show`.
```execute
advisor recipe show com.vmware.tanzu.spring.recipes.boot41.UpgradeSpringBoot_4_1
```

After modifying the recipe, publish it with a new ID to your local or corporate Maven repository, then reference it inside your customized upgrade mapping.

#### Other blockers and warnings

`corporate-starter` was the *missing mappings* case. A few more situations are reported at the bottom of the upgrade plan, and most of them are solved with the same mapping commands:

- **An artifact reached end of life** One artifact of a project is gone from newer releases and is reported as an **excluded artifact**. 
```
Some upgrades were not included in the upgrade plan.

The following dependencies are defined as excluded artifacts in your upgrade mappings because there are no new available versions.
Please, remove them from your project or overwrite/update your upgrade mappings with a recipe that replaces them:

   * org.apache.geode:geode-json:1.9.x
```
Remove it if you don't use it at runtime, or override the project's mappings with a recipe that replaces it.
- **A project blocks everything else** It is reported as needing "an upgrade or migration defined in the upgrade mappings". Either the mappings are stale (run `advisor mapping update`), the project is simply behind (upgrade it), or it is dead like and needs a migration to a successor project defined in its mappings.
```
Some upgrades were not included in the upgrade plan.
Here's a summary of blocker projects and potential actions to take:

	* my-outdated-project:4.2.x needs an upgrade or migration defined in the upgrade mappings to upgrade spring-framework > 6.0.x
	...
```
- **Warnings about versions** Several versions of one project used simultaneously usually points at a misconfiguration in your application, and a version that "does not exist" in the mappings means those mappings need an update.
```
⚠️  Warnings:
	- There is an error in reactor-netty, several versions are used simultaneously:
		- io.projectreactor.netty:reactor-netty:1.1.15
		- io.projectreactor.netty:reactor-netty-core:1.0.39
		- io.projectreactor.netty:reactor-netty-http:1.1.15
```

Details on all of them, including the mapping snippets, are in the documentation [here](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-6/app-advisor/upgrade-plan.html).

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
