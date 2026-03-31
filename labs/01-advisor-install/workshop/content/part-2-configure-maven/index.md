---
title: Configure Maven for Enterprise Recipes
---
# Configure Maven for Enterprise Recipes

Spring Application Advisor uses commercial recipes to perform upgrades. These recipes are distributed through a Maven repository and require configuration to access via a Token.

## Understanding the Recipe Repository

When you run `advisor upgrade-plan apply`, the advisor CLI orchestrates recipes that transform your code. These commercial recipes are not available on Maven Central - they must be fetched from the Spring Enterprise repository (or a mirror of it).

There are two common scenarios for accessing these recipes:

1. **Direct from Broadcom** - Configure Maven to pull recipes directly from `packages.broadcom.com` using your Broadcom Support Portal credentials
2. **Internal Mirror** - Your organization mirrors the Broadcom repository to an internal Maven repository (Nexus, Artifactory, etc.)

**NOTE:** The following sections build on each other, so make sure to follow each step.

## Step 1: Configure Maven Settings for Direct Download of Recipes from Broadcom

In this section, we'll configure Maven to use the Spring Enterprise directly from Broadcom.  You can configure repository connections with credentials by editing/creating a Maven settings file.  You can read more about Maven Settings at https://maven.apache.org/settings.html.

Let's create a shell for our Maven settings file:

```editor:append-lines-to-file
file: ~/.m2/settings.xml
text: |
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
    </settings>
```

Next, we'll create a new "profile" that allows us to define a respository we can apply to tools that use Maven like Application Advisor.  We're going to define one for the Spring Enterprise repo hosted at Broadcom.

```editor:append-lines-after-match
file: ~/.m2/settings.xml
match: |
    http://maven.apache.org/xsd/settings-1.0.0.xsd">
text: |

      <profiles>
        <profile>
          <id>org-profile</id>
          <repositories>
            <repository>
              <id>spring-enterprise-subscription</id>
              <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
            </repository>
          </repositories>
        </profile>
      </profiles>
```

Great!  At this point, we have the pointer to the Spring Enterprise repository, but we need a way to pass in our credentials to access this protected respository.  For that, we'll add a new "servers" section below our profile.  Notice the "id" that the server entry uses exactly matches the "id" for the repository in our profile.  This is how Maven knows to use these credentials for access.

```editor:append-lines-after-match
file: ~/.m2/settings.xml
match: "</profiles>"
text: |

      <servers>
        <server>
          <id>spring-enterprise-subscription</id>
          <username>broadcom-support-user</username>
          <password>broadcom-registry-token</password>
        </server>
      </servers>
```

We've added a profile and credentials, but we need to tell Maven to actually use these settings.  Maven has some very sophisticated ways to enable profiles based on rules and conditions.  But in our case, we're going to take the simple approach and just tell Maven to make our profile always active.

```editor:append-lines-after-match
file: ~/.m2/settings.xml
match: |
    http://maven.apache.org/xsd/settings-1.0.0.xsd">
text: |
    
      <activeProfiles>
        <activeProfile>org-profile</activeProfile>
      </activeProfiles>
```

Now, if the machine you are running Advisor on is able to reach the internet, you would be able to test things out.  However, like many enterprises, in our lab environment we are required to use a governed mirror of various Maven repositories.  So how do we deal with that?  Thankfully, Maven supports configuring **Mirror** respositories.  Let's add a mirror configuration to our settings.  We need one for Maven Central, one for our Mirror of the Spring Enterprise repositories, and a few more for various respositories that the Advisor CLI needs to pull from.

```editor:append-lines-after-match
file: ~/.m2/settings.xml
match: |
    http://maven.apache.org/xsd/settings-1.0.0.xsd">
text: |

      <mirrors>
        <mirror>
          <id>mirror-central</id>
          <mirrorOf>central</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/central</url>
          <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
          <blocked>false</blocked>
        </mirror>
        <mirror>
          <id>mirror-spring-enterprise</id>
          <mirrorOf>spring-enterprise-subscription</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/spring-enterprise</url>
          <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
          <blocked>false</blocked>
        </mirror>
        <mirror>
          <id>mirror-spring-snapshot</id>
          <mirrorOf>spring-snapshot</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/spring-snapshot</url>
          <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
          <blocked>false</blocked>
        </mirror>
        <mirror>
          <id>mirror-gradle</id>
          <mirrorOf>gradle</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/gradle</url>
          <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
          <blocked>false</blocked>
        </mirror>
        <mirror>
          <id>mirror-rewrite-build-plugins</id>
          <mirrorOf>rewrite-build-plugins</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/rewrite-build-plugins</url>
          <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
          <blocked>false</blocked>
        </mirror>
        <mirror>
          <id>mirror-sonatype-nexus-snapshots</id>
          <mirrorOf>sonatype-nexus-snapshots</mirrorOf>
          <url>http://{{< param workshop_namespace >}}-reposilite/sonatype-nexus-snapshots</url>
          <blocked>false</blocked>
        </mirror>
      </mirrors>
```

We don't need it in our environment, but if your mirror organization's Mirror servers required authentication, you could simple add more "server" entries to the "servers" tag of the settings, adding in credentials for the using the "id" of the mirrors you need to provide credentials to.

## Step 2: Verify the Configuration

Let's verify that the Maven configuration is working by running the advisor against a small test application.

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
