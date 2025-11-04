# Part 1: Installing the CLI

In this section, you'll install the Spring Application Advisor CLI.  We'll be simulating the experience of downloading the CLI directly from the Spring Enterprise Repository.  In many environments organizations will mirror the Spring Enterprise Repository to your own internal Maven repository.  Access to the internal repository will depend on your organization's setup.  Contact your IT staff to determine your mirrored repository location and access credentials.

## Step 1: Set Your Artifactory Token

First, ensure your Artifactory token is set as an environment variable.  The token here is a sample and **WILL NOT** work with the Broadcom Spring Enterprise repository:

```execute
export ARTIFACTORY_TOKEN=eyJ2ZXIiOiIyIiw_EXAMPLE_TOKEN_nzQOKQc6A
```

```section:begin
title: Other Platform Examples
```
Windows (PowerShell):
```bash
$env:ARTIFACTORY_TOKEN="your-token-here"
```

Windows (Command Prompt):
```cmd
set ARTIFACTORY_TOKEN=your-token-here
```

```section:end
```

## Step 2: Download and Install the CLI

Download the Spring Application Advisor CLI for Linux.  In this example, the hostname we're using is internal to this workshop.  Normally you would use `https://packages.broadcom.com` as the hostname instead of `{{< param ingress_protocol >}}://{{< param workshop_namespace >}}-files.{{< param ingress_domain >}}`:

```execute
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET {{< param ingress_protocol >}}://{{< param workshop_namespace >}}-files.{{< param ingress_domain >}}/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.5.0/application-advisor-cli-linux-1.5.0.tar
```

Extract the CLI:

```execute
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

```section:begin
title: Other Platform Examples
```

Windows:
```bash
curl -L -H "Authorization: Bearer $env:ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-windows/1.5.0/application-advisor-cli-windows-1.5.0.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

MacOS (Intel):
```bash
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos/1.5.0/application-advisor-cli-macos-1.5.0.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

MacOS (ARM64/Apple Silicon):
```bash
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos-arm64/1.5.0/application-advisor-cli-macos-arm64-1.5.0.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

```section:end
```

## Step 3: Verify Installation

Test that the CLI is working:

```execute
./advisor --help
```

You should see the available commands listed:
```
Usage: advisor [-v] [?] [COMMAND]
Spring Application Advisor CLI
  ?, -h, --help       Prints the help to understand the command options
  -v, --version       Prints version of Spring Application Advisor CLI
Commands:
  build-config  Generates or publishes build dependencies and tools
  upgrade-plan  Generates or applies upgrade plan(s) to upgrade the repository code base with the latest versions of Spring components.
  mapping       Generates the Maven artifacts that belong to a Git repository, which usually represents a project (e.g spring-boot).
  advice        Generates or applies best practices to deploy Tanzu Spring applications.
```

## Step 4: Configure Maven Settings

To enable Spring Application Advisor to download commercial recipes, you need to configure your Maven repositories correctly. Refer to the [official documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-5/spring-app-advisor/recipes.html) for detailed configuration steps.
