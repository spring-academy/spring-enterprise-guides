---
title: Installing the CLI (optional)
---

{{< note >}}
This section is optional. To skip the CLI installation, scroll to the bottom and continue to the next section.
{{< /note >}}

In this section, you'll install the Spring Application Advisor CLI. We're simulating downloading it from the Spring Enterprise Repository.

Some organizations mirror the Spring Enterprise Repository to an internal Maven repository. Contact your IT staff to find out whether your organization does this, where the mirror lives, and what credentials you'll need.

## Step 1: Set Your Spring Enterprise Repository Token

Set your repository token as an environment variable. The token below is a sample and **WILL NOT** work against the real Broadcom Spring Enterprise repository:

```execute
export REPOSITORY_TOKEN=eyJ2ZXIiOiIyIiw_EXAMPLE_TOKEN_nzQOKQc6A
```

For instructions on generating a real token from the Broadcom Support Portal, see [KB article 421110](https://knowledge.broadcom.com/external/article/421110).

```section:begin
title: Windows and macOS examples
```
Windows (PowerShell):
```bash
$env:REPOSITORY_TOKEN="your-token-here"
```

Windows (Command Prompt):
```cmd
set REPOSITORY_TOKEN=your-token-here
```

```section:end
```

## Step 2: Download and Install the CLI

Download the Spring Application Advisor CLI for Linux:

```execute
curl -L -H "Authorization: Bearer $REPOSITORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.6.5/application-advisor-cli-linux-1.6.5.tar
```

To run `advisor` from anywhere, extract the archive into a directory on your `$PATH`. In this environment, the user's home `bin` folder is already on the path:

```execute
echo $PATH | grep /home/eduk8s/bin
```

Extract the archive there:

```execute
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C /home/eduk8s/bin
```

```section:begin
title: Windows and macOS examples
```

Windows (PowerShell):
```bash
echo $env:PATH
curl -L -H "Authorization: Bearer $env:REPOSITORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-windows/1.6.5/application-advisor-cli-windows-1.6.5.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C <directory>
```

Windows (Command Prompt):
```bash
echo %PATH%
curl -L -H "Authorization: Bearer %REPOSITORY_TOKEN%" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-windows/1.6.5/application-advisor-cli-windows-1.6.5.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C <directory>
```

MacOS (Intel):
```bash
echo $PATH
curl -L -H "Authorization: Bearer $REPOSITORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos/1.6.5/application-advisor-cli-macos-1.6.5.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C <directory>
```

MacOS (ARM64/Apple Silicon):
```bash
echo $PATH
curl -L -H "Authorization: Bearer $REPOSITORY_TOKEN" -o advisor-cli.tar -X GET https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-macos-arm64/1.6.5/application-advisor-cli-macos-arm64-1.6.5.tar
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C <directory>
```

```section:end
```

## Step 3: Verify Installation

Confirm the CLI is installed and on your path:

```execute
advisor --version
```

You should see the installed version printed to the terminal. The CLI is now ready — in the next section, we'll run Application Advisor against a sample application.