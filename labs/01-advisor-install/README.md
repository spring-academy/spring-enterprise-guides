# Spring Application Advisor Workshop

An [Educates](https://educates.dev) workshop for learning how to install and use the Spring Application Advisor CLI to upgrade Spring Boot applications.

## About Spring Application Advisor

Spring Application Advisor is a native CLI tool that helps you upgrade Spring applications by:

- Analyzing your project's build dependencies and tools
- Creating step-by-step upgrade plans
- Applying upgrades automatically while preserving your code style

The CLI supports two main commands:
- `build-config` - Analyzes project build dependencies and tools
- `upgrade-plan` - Retrieves or applies upgrade plans to your project

## Workshop Status

- [x] Setup initial project structure
- [x] Test deployment to Spring Academy staging environment
- [ ] Provide a known good sample project for use with advisor that won't require GitHub cloning (Maybe https://github.com/dashaun/spring-petclinic)?
- [ ] ~~Setup something like Dashaun's memory/CPU test scripts after each migration stage to show improvements from each leap forward.~~
- [ ] ~~Add in some kind of CVE reporting at each migration step~~
- [ ] ~~Separate CI/CD instructions into dedicated workshop~~
- [ ] Modify lab to describe normal CLI download process with token
- [ ] Add CLI binary to lab environment for token-free access
- [ ] Final walkthrough/testing with team
- [ ] Cut release
- [ ] Deploy to production Spring Academy environment
