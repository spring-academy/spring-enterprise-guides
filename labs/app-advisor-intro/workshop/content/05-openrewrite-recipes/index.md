---
title: Using Commercial Recipes with OpenRewrite Tools
---

*Spring Application Advisor* orchestrates upgrades using **OpenRewrite recipes** under the hood. But did you know that you can also run these commercial Spring recipes **directly** using the OpenRewrite Maven or Gradle plugin?

This is useful when you want to:
- Run a **specific recipe** on a single repository without the full upgrade orchestration
- Apply a recipe that is not part of the standard upgrade plan (e.g., design principle recipes)
- Have **full control** over which recipes are executed and in what order

#### How it works

The commercial Spring recipes are published in the **Spring Commercial repository**. The OpenRewrite Maven plugin can resolve and run these recipes directly from that repository.

Let's explore the available recipes for upgrading Spring. You can run any of the recipes listed in the Spring commercial recipes catalog using the following Maven command format.

For example, to upgrade to a specific Spring Boot version, you would run:
```execute
./mvnw -B org.openrewrite.maven:rewrite-maven-plugin:run -Drewrite.recipeArtifactCoordinates=com.vmware.tanzu.spring.recipes:spring-boot-3-upgrade-recipes:1.5.5 -Drewrite.activeRecipes=com.vmware.tanzu.spring.recipes.boot35.UpgradeSpringBoot_3_5
```

This command:
1. Uses the OpenRewrite Maven plugin directly (no Application Advisor CLI needed)
2. Resolves the recipe artifact from your configured Maven repositories
3. Runs the specific `UpgradeSpringBoot_3_5` recipe for the main upgrade to Spring Boot 3.5.x 

Let's check if any changes were applied.
```execute
git --no-pager diff --stat
```

If changes were made, you can review and revert them since this was just a demonstration.
```execute
git checkout .
```

#### Design principles of Spring commercial recipes

Commercial Spring Recipes follow a couple of design principles that are different from the OSS Spring recipes:
- Recipes do not perform steps to upgrade previous steps. For instance, the recipe to upgrade to Spring Boot 3.1.x does not invoke the recipe to upgrade to Spring Boot 3.0.x. 
- Recipes do not upgrade downstream projects. The Spring Framework recipes do not upgrade Spring Security.

This is why *Application Advisor* is the recommended approach for most use cases -- it correctly sequences and orchestrates the recipes for you.

#### When to use OpenRewrite directly vs. Application Advisor

| Use Case | Recommended Tool |
|----------|-----------------|
| Continuous, incremental upgrades across many repos | Application Advisor |
| One-off recipe on a single repo | OpenRewrite plugin |
| CI/CD pipeline integration | Application Advisor |
| Exploring individual recipe effects | OpenRewrite plugin |
| Custom recipe development and testing | OpenRewrite plugin |
