# Part 1: Installing the CLI

In this section, you'll download and install the Spring Application Advisor CLI.

## Step 1: Set Your Artifactory Token

First, ensure your Artifactory token is set as an environment variable:

```copy-and-edit
export ARTIFACTORY_TOKEN=your-token-here
```

**For reference, on other platforms:**

Windows (PowerShell):
```bash
$env:ARTIFACTORY_TOKEN="your-token-here"
```

Windows (Command Prompt):
```cmd
set ARTIFACTORY_TOKEN=your-token-here
```

## Step 2: Download and Install the CLI

Download the Spring Application Advisor CLI for Linux:

```execute
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.4.1/application-advisor-cli-linux-1.4.1.tar
```

Extract the CLI:

```execute
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

**For reference, on other platforms:**

Windows:
```bash
curl -L -H "Authorization: Bearer $env:ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-windows/1.4.1/application-advisor-cli-windows-1.4.1.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

MacOS (Intel):
```bash
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos/1.4.1/application-advisor-cli-macos-1.4.1.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

MacOS (ARM64/Apple Silicon):
```bash
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos-arm64/1.4.1/application-advisor-cli-macos-arm64-1.4.1.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
```

## Step 3: Verify Installation

Test that the CLI is working:

```execute
./advisor --help
```

You should see the available commands listed:
```
Usage: advisor [COMMAND]
Spring Application Advisor CLI
Commands:
  build-config  Project build dependencies and tools
  upgrade-plan  Retrieves or applies upgrade plan(s) to project
```

## Step 4: Configure Maven Settings

To enable Spring Application Advisor to download commercial recipes, you need to configure your Maven repositories correctly. Refer to the [official documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-4/spring-app-advisor/recipes.html) for detailed configuration steps.
