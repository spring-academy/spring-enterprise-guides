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

## Local Testing
Download and install the Educates CLI by follwing the [Quickstart Instructions](https://docs.educates.dev/en/stable/getting-started/quick-start-guide.html#downloading-the-cli) to the point of downloading and installing the CLI.

Then you can use the `educates` CLI to create a kind cluster to test on with `educates create-cluster`

Next, you need to create a namespace in your cluster called `spring-academy`:
```
kubectl create namespace spring-academy
```

Next, create a secret containing a set of GCP credentials for accessing the development artifact bucket:
```
kubectl -n spring-academy create secret generic gcp --from-file=bucket-reader=<path-to-key>/<key-file-name>.json
```

Now you can use the standard Educates CLI commands to publish, deploy and launch a browser to your workshop.  It is important to create your training portal and workshop with the correct names for some secrets automation to work correctly for the local environment:
```
educates publish-workshop
educates create-portal --portal='spring-enterprise-guides'
educates deploy-workshop -p spring-enterprise-guides -n spring-enterprise-guides-advisor-install
educates browse-workshops -p spring-enterprise-guides
```

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
