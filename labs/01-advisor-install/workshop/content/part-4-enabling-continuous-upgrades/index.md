# Part 4: Enabling Continuous Upgrades (Optional)

Set up automatic pull requests for continuous Spring Boot upgrades in your CI/CD pipeline.

## Overview

Continuous upgrades allow Spring Application Advisor to:

- Automatically detect when upgrades are available
- Create branches with the upgraded code
- Submit pull requests for your team to review
- Keep your applications up-to-date with minimal manual effort

## Prerequisites

Before setting up continuous upgrades, ensure you have:

- A CI/CD pipeline (GitHub Actions, GitLab CI, Jenkins, etc.)
- Git repository hosted on GitHub, GitLab, or Bitbucket
- Write access to create branches and pull requests
- Spring Application Advisor CLI installed in your CI environment

## Step 1: Update Your CI/CD Pipeline

Add these commands to your CI/CD pipeline configuration:

```copy
advisor build-config get
advisor build-config publish
advisor upgrade-plan apply --push --from-yml
```

### Example: GitHub Actions

Create `.github/workflows/spring-advisor.yml`:

```yaml
name: Spring Application Advisor

on:
  schedule:
    - cron: '0 0 * * 1'  # Run weekly on Mondays
  workflow_dispatch:  # Allow manual triggers

jobs:
  upgrade:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Download Spring Advisor CLI
        run: |
          curl -L -H "Authorization: Bearer ${{ secrets.ARTIFACTORY_TOKEN }}" \
            -o advisor-cli.tar -X GET \
            https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.4.1/application-advisor-cli-linux-1.4.1.tar
          tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
      
      - name: Run Spring Advisor
        env:
          GIT_TOKEN_FOR_PRS: ${{ secrets.GITHUB_TOKEN }}
        run: |
          ./advisor build-config get
          ./advisor build-config publish
          ./advisor upgrade-plan apply --push --from-yml
```

### Example: GitLab CI

Create or update `.gitlab-ci.yml`:

```yaml
spring-advisor:
  stage: upgrade
  image: eclipse-temurin:17-jdk
  only:
    - schedules
  script:
    - curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" 
        -o advisor-cli.tar -X GET 
        https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.4.1/application-advisor-cli-linux-1.4.1.tar
    - tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
    - ./advisor build-config get
    - ./advisor build-config publish
    - ./advisor upgrade-plan apply --push --from-yml
  variables:
    GIT_TOKEN_FOR_PRS: $CI_JOB_TOKEN
```

### Example: Jenkins Pipeline

Create a `Jenkinsfile`:

```groovy
pipeline {
    agent any
    
    triggers {
        cron('0 0 * * 1')  // Run weekly on Mondays
    }
    
    environment {
        ARTIFACTORY_TOKEN = credentials('artifactory-token')
        GIT_TOKEN_FOR_PRS = credentials('git-token')
    }
    
    stages {
        stage('Download Advisor CLI') {
            steps {
                sh '''
                    curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" \
                        -o advisor-cli.tar -X GET \
                        https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.4.1/application-advisor-cli-linux-1.4.1.tar
                    tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF
                '''
            }
        }
        
        stage('Run Spring Advisor') {
            steps {
                sh './advisor build-config get'
                sh './advisor build-config publish'
                sh './advisor upgrade-plan apply --push --from-yml'
            }
        }
    }
}
```

## Step 2: Set Up Git Token

Create a `GIT_TOKEN_FOR_PRS` environment variable or secret with a token that has write access to your repository.

### GitHub

1. Go to Settings → Developer settings → Personal access tokens
2. Generate a new token with `repo` scope
3. Add it as a repository secret named `GIT_TOKEN_FOR_PRS`

### GitLab

1. Go to Settings → Access Tokens
2. Create a token with `api` and `write_repository` scopes
3. Add it as a CI/CD variable named `GIT_TOKEN_FOR_PRS`

### Bitbucket

For Bitbucket, follow the special [Bitbucket Integration Guide](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-4/spring-app-advisor/integrate-bitbucket.html) as the process differs slightly.

## Step 3: Enable Advisor in Your Repository

Create a `.spring-app-advisor.yml` file in your repository root:

```copy
enabled: true
```

This file tells Spring Application Advisor that this repository should receive automatic upgrade pull requests.

### Additional Configuration Options

You can customize the behavior:

```copy
enabled: true
autoMerge: false  # Set to true to auto-merge if tests pass
targetBranch: main  # Specify target branch
assignees:
  - username1
  - username2
labels:
  - spring-upgrade
  - dependencies
```

## How It Works

Once configured, the workflow operates as follows:

1. **Schedule Trigger**: Your CI/CD pipeline runs on schedule (e.g., weekly)
2. **Build Configuration**: Advisor analyzes your current dependencies
3. **Upgrade Plan**: Advisor determines what needs upgrading
4. **Branch Creation**: Advisor creates a new branch with upgrades applied
5. **Pull Request**: Advisor opens a PR against your target branch
6. **Review**: Your team reviews and tests the changes
7. **Merge**: Once approved, merge the PR to complete the upgrade

## Testing the Setup

Test your continuous upgrade setup:

1. Trigger the workflow manually (if supported)
2. Check for errors in the CI/CD logs
3. Verify a branch was created
4. Confirm a pull request was opened
5. Review the PR contents

## Best Practices

- **Schedule Wisely**: Run during low-activity periods
- **Review Regularly**: Don't let PRs pile up
- **Test Thoroughly**: Always run tests before merging
- **Gradual Rollout**: Start with non-critical projects
- **Monitor Results**: Track upgrade success rates

## Troubleshooting CI/CD Issues

### PR Not Created

- Verify `GIT_TOKEN_FOR_PRS` has correct permissions
- Check if `.spring-app-advisor.yml` exists and is valid
- Review CI/CD logs for error messages

### Build Failures

- Ensure Java version matches your project requirements
- Verify Maven/Gradle configuration is correct
- Check network connectivity to Artifactory

### Permission Errors

- Confirm token has `repo` (GitHub) or `api` (GitLab) scope
- Verify token hasn't expired
- Check repository access level

## Next Steps

Your continuous upgrade pipeline is now configured!
