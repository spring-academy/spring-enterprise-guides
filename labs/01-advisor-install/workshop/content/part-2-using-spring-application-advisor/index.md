# Part 2: Using Spring Application Advisor

Now let's use the CLI to analyze and upgrade a Spring Boot project!

## Step 1: Navigate to Your Project

Change to your Spring Boot project directory:

```copy-and-edit
cd /path/to/your/spring-boot-project
```

Make sure you're in the root directory of your project where your `pom.xml` (Maven) or `build.gradle` (Gradle) file is located.

## Step 2: Generate a Build Configuration

The build configuration contains your dependency tree, Java version, and build tool versions:

```execute
./advisor build-config get
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

If you see error messages, check the `.advisor/errors/` directory for detailed logs:

```
💔 Errors
- $repo failed with the following message:
  The maven command failed. You can find the error in .advisor/errors/${error-id}.log
```

## Step 3: Generate an Upgrade Plan

Create a step-by-step upgrade plan:

```execute
./advisor upgrade-plan get
```

You'll see an upgrade plan similar to:

```
Fetching details for upgrade plan:
- Step 1:
  * Upgrade Spring Boot from v2.6.1 to v2.7.x
  * Upgrade Spring Framework from v3.5.1 to v4.0.x
- Step 2:
  * Upgrade Java from 8 to 11
- Step 3:
  * Upgrade Spring Boot from v2.7.1 to v3.0.x
```

### Understanding the Upgrade Plan

The upgrade plan shows:

- **Sequential Steps**: Upgrades are ordered to ensure compatibility
- **Version Changes**: Specific versions for each component
- **Dependencies**: Related framework upgrades that must happen together

## Step 4: Apply the Upgrade

Apply the upgrade plan locally:

```execute
./advisor upgrade-plan apply
```

This command will:

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
