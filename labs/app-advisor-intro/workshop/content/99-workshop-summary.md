---
title: Workshop Summary
---

In this workshop, we explored the capabilities of **Spring Application Advisor** by upgrading a Spring Boot 2.7 / Java 8 application all the way to **Spring Boot 4**.

Here is what we covered:

- **Incremental upgrades**: Using `advisor build-config get`, `advisor upgrade-plan get`, and `advisor upgrade-plan apply` to upgrade step by step
- **Code style preservation**: Using `--after-upgrade-cmd` to automatically run formatters after upgrades
- **Debugging upgrades**: Using `--debug` to see which OpenRewrite recipes are being applied
- **Squashing steps**: Using `--squash=<N>` to combine multiple upgrade steps into one
- **Forcing upgrades**: Using `--force` to proceed when unmapped libraries block the upgrade plan
- **Dependency conflicts**: Understanding `--accept-no-alignment` for handling version misalignments
- **OpenRewrite recipes**: Running commercial Spring recipes directly using the OpenRewrite Maven plugin
- **Custom mappings**: Configuring upgrade mappings for shared internal libraries
- **CI/CD integration**: Setting up continuous upgrades with `--push` and `--from-yml`

Now it's time to start upgrading your applications!
More information is available in the [official documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-5/spring-app-advisor/what-is-app-advisor.html).
