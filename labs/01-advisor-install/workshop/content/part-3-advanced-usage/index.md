# Part 3: Advanced Usage

Learn how to customize Spring Application Advisor for your specific needs.

## Using Code Formatters

If you're using a formatter like `spring-javaformat`, you can run it automatically after the upgrade to maintain your code style.

### With Maven

```copy
./advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply
```

### With Gradle

```copy
./advisor upgrade-plan apply --after-upgrade-cmd=spotlessApply
```

### Why Use Formatters?

While Spring Application Advisor preserves your coding style, applying your project's formatter ensures:

- Consistent indentation and spacing
- Adherence to your team's style guide
- Proper import organization
- Line length compliance

## Increasing Memory for Large Projects

For large projects, you may need to increase Gradle's memory limit. By default, Gradle's daemon process limits memory to 512 MB, which may be insufficient for large codebases.

### Basic Memory Increase

Increase memory to 1 GB:

```copy
./advisor upgrade-plan apply --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx1g"
```

### Advanced Memory Configuration

Increase memory to 2 GB and use the Parallel Garbage Collector:

```copy
./advisor upgrade-plan apply --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx2g -XX:+UseParallelGC"
```

### When to Increase Memory

Consider increasing memory if you experience:

- Out of memory errors during build configuration
- Slow performance when analyzing dependencies
- Gradle daemon crashes
- Projects with hundreds of modules or dependencies

### Other JVM Options

You can pass any JVM arguments:

```copy
./advisor upgrade-plan apply --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx4g -Xms1g -XX:MaxMetaspaceSize=512m"
```

Common options:

- `-Xmx`: Maximum heap size
- `-Xms`: Initial heap size
- `-XX:MaxMetaspaceSize`: Maximum metaspace size
- `-XX:+UseG1GC`: Use G1 Garbage Collector
- `-XX:+UseParallelGC`: Use Parallel Garbage Collector

## Air-Gapped Environments

If you're working in an air-gapped or restricted network environment, you can configure a custom plugin repository.

### Setting a Custom Repository

Set the environment variable before running the advisor:

```copy-and-edit
export ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY=https://pluginrepository.acme.com/m2
```

**For reference, on other platforms:**

Windows (PowerShell):
```bash
$env:ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY="https://pluginrepository.acme.com/m2"
```

Windows (Command Prompt):
```cmd
set ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY=https://pluginrepository.acme.com/m2
```

### Repository Requirements

Your custom repository must:

- Mirror Maven Central plugins
- Be accessible from your network
- Support standard Maven repository structure
- Include all OpenRewrite plugins and dependencies

### Making It Permanent

Add the environment variable to your shell profile:

```copy
echo 'export ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY=https://pluginrepository.acme.com/m2' >> ~/.bashrc
```

**For reference, on other platforms:**

Windows (PowerShell Profile):
```bash
Add-Content $PROFILE '$env:ADVISOR_DEFAULT_OSS_PLUGINS_REPOSITORY="https://pluginrepository.acme.com/m2"'
```

## Combining Advanced Options

You can combine multiple advanced options in a single command:

```copy
./advisor upgrade-plan apply \
  --after-upgrade-cmd=spring-javaformat:apply \
  --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx2g -XX:+UseParallelGC"
```
