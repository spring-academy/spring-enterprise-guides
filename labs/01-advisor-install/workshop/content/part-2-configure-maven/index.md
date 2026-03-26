---
title: Configure Maven for Enterprise Recipes
---
# Configure Maven for Enterprise Recipes

Spring Application Advisor uses commercial OpenRewrite recipes to perform upgrades. These recipes are distributed through a Maven repository and require configuration to access.

## Understanding the Recipe Repository

When you run `advisor upgrade-plan apply`, the advisor CLI orchestrates OpenRewrite recipes that transform your code. These commercial recipes are not available on Maven Central - they must be fetched from the Spring Enterprise repository (or a mirror of it).

There are three common scenarios for accessing these recipes:

1. **Direct from Broadcom** - Configure Maven to pull recipes directly from `packages.broadcom.com` using your Broadcom Support Portal credentials
2. **Internal Mirror** - Your organization mirrors the Broadcom repository to an internal Maven repository (Nexus, Artifactory, etc.)
3. **Workshop Environment** - This lab uses a pre-configured repository that simulates the Broadcom repository

## Step 1: Configure Maven Settings

In this workshop, we'll configure Maven to use the workshop's recipe repository. Create the Maven settings file:

```execute
mkdir -p ~/.m2
cat > ~/.m2/settings.xml << 'EOF'
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>mirror-central</id>
      <mirrorOf>central</mirrorOf>
      <url>http://{{< param workshop_namespace >}}-reposilite/central</url>
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-spring-enterprise</id>
      <mirrorOf>spring-enterprise-subscription</mirrorOf>
      <url>http://{{< param workshop_namespace >}}-reposilite/spring-enterprise</url>
      <blocked>false</blocked>
    </mirror>
  </mirrors>

  <activeProfiles>
    <activeProfile>org-profile</activeProfile>
  </activeProfiles>

  <profiles>
    <profile>
        <id>org-profile</id>
        <repositories>
          <repository>
            <id>spring-enterprise-subscription</id>
            <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
          </repository>
          <repository>
            <id>central</id>
            <url>https://repo.maven.apache.org/maven2/</url>
            <releases>
              <enabled>true</enabled>
            </releases>
            <snapshots>
              <enabled>true</enabled>
            </snapshots>
          </repository>
        </repositories>
    </profile>
  </profiles>
  <servers>
    <!--
    <server>
      <id>mirror-spring-enterprise</id>
      <username>USERNAME</username>
      <password>PWD</password>
    </server>
    <server>
      <id>mirror-central</id>
      <username>USERNAME</username>
      <password>PWD</password>
    </server>
    -->
    <server>
      <id>spring-enterprise-subscription</id>
      <username>broadcom-support-user</username>
      <password>broadcom-registry-token</password>
    </server>
  </servers>
</settings>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>tanzu-maven-mirror</id>
      <mirrorOf>tanzu-maven</id>
      <url>http://{{< param workshop_namespace >}}-reposilite/artifactory/tanzu-maven</url>
      <!-- This setting is needed due to the mirror being http and not https-->
      <blocked>false</blocked>
    </mirror>
  </mirrors>
  <profiles>
    <profile>
      <id>tanzu-spring</id>
      <repositories>
        <repository>
          <id>tanzu-maven</id>
          <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
        </repository>
      </repositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>tanzu-spring</activeProfile>
  </activeProfiles>
  <!-- This section is needed for any authentication info you might need to pass -->
  <servers>
    <server>
      <id>tanzu-maven-mirror</id>
      <username>internal-mirror-username</username>
      <password>internal-mirror-password</password>
    </server>
    <server>
      <id>tanzu-maven</id>
      <username>your.broadcom.support.portal@email.com</username>
      <password>YOUR_BROADCOM_SUPPORT_PORTAL_REGISTRY_TOKEN</password>
    </server>
  </servers>
</settings>
EOF
```

Verify the file was created:

```execute
cat ~/.m2/settings.xml
```

```section:begin
title: Production Configuration (Reference)
```

In a production environment, you would configure Maven to access the Broadcom Spring Enterprise repository directly. This requires:

1. **Broadcom Support Portal username** - Your email address for the Broadcom Support Portal
2. **Repository token** - The same token you used to download the CLI (stored in `ARTIFACTORY_TOKEN`)

Here's what a production `~/.m2/settings.xml` would look like:

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0">
  <servers>
    <server>
      <id>spring-enterprise</id>
      <username>your-email@company.com</username>
      <password>${env.ARTIFACTORY_TOKEN}</password>
    </server>
  </servers>
  <profiles>
    <profile>
      <id>spring-enterprise</id>
      <repositories>
        <repository>
          <id>spring-enterprise</id>
          <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
        </repository>
      </repositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>spring-enterprise</activeProfile>
  </activeProfiles>
</settings>
```

**Enterprise Alternative**: Many organizations mirror the Broadcom repository to their internal Maven repository (Nexus, Artifactory, JFrog, etc.). If your workstation is already configured to use an internal repository that mirrors Broadcom's Spring Enterprise repository, the recipes will be available automatically without additional configuration.

```section:end
```

## Step 2: Verify the Configuration

Let's verify that the Maven configuration is working by running the advisor against a small test application.

Navigate to the test application:

```execute
cd ~/hello-spring-boot-1-5
```

This is a simple Spring Boot 1.5 application - perfect for testing that everything is configured correctly.

First, let's see what version of Spring Boot it's currently using:

```execute
grep -A1 '<parent>' pom.xml | head -5
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
grep -A1 '<parent>' pom.xml | head -5
```

You should see the Spring Boot version has been upgraded.

Congratulations! Your Spring Application Advisor installation is complete and verified. The CLI can download and execute the commercial upgrade recipes.
