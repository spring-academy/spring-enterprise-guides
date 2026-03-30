---
title: Continuous and Incremental Upgrades
---

As you saw, *Spring Application Advisor* is able to continuously and incrementally upgrade your Spring dependencies in all your Git repositories. The only thing developers still have to do is to review the changes applied for each upgrade.

#### Integrating into your CI/CD pipeline

The recommended way to integrate *Spring Application Advisor* into your software development process is via a **separate CI pipeline** that is scheduled to run, for example, every day or as part of your CI/CD pipelines after every build.

The basic CI/CD integration involves running these commands:
```
advisor build-config get
advisor upgrade-plan apply --push --from-yml
```

Key flags for CI/CD integration:
- **`--push`**: Automatically creates a remote branch, pushes the changes, and opens a pull request. The environment variable `GIT_TOKEN_FOR_PRS` must contain a token with permissions to create pull requests.
- **`--from-yml`**: Enables the upgrade plan based on the contents of a `.spring-app-advisor.yml` file in the repository root. This allows each repository to opt-in to automatic upgrades by adding `enabled: true` to this file.

#### Automatic pull requests

The automatic pull requests feature informs the development team about available upgrades. After reviewing, merging the pull request triggers the default CI/CD pipeline to build and deploy the updated application.

#### Supported CI/CD providers

Documentation on how to set up *Spring Application Advisor* for different CI/CD providers is available:
- **GitLab Enterprise**: Using custom GitLab runners with the Application Advisor CLI
- **GitHub Enterprise**: Using GitHub Actions workflows with the advisor commands
- **Jenkins**: Using Pipeline Templates or CloudBees pipelines
- **Bitbucket**: Using a script-based approach with the `--push` option
- **Other SaaS CI/CD tools**: Script-based integration using `advisor build-config get` and `advisor upgrade-plan apply`

For all providers, the general approach is:
1. Ensure the Application Advisor CLI is available in the CI/CD environment
2. Configure Maven settings to access the Spring Commercial repository
3. Set the `GIT_TOKEN_FOR_PRS` environment variable for pull request creation
4. Schedule the advisor commands to run on a regular basis
