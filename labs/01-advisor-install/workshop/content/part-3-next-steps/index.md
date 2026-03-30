---
title: Next Steps
---
# Next Steps

You have successfully installed the Spring Application Advisor CLI and configured Maven to access the commercial upgrade recipes. Here's what to do next.

## Continue Learning

### Hands-On Workshop: Upgrading Applications

To learn how to use Spring Application Advisor to upgrade your applications, take the **Spring Application Advisor Introduction** workshop. In that workshop, you will:

- Upgrade a Spring Boot 2.7 application all the way to Spring Boot 4
- Learn about advanced flags like `--squash` and `--force`
- Run commercial OpenRewrite recipes directly
- Set up custom upgrade mappings for shared libraries
- Integrate Spring Application Advisor into CI/CD pipelines

### Official Documentation

For comprehensive documentation on Spring Application Advisor:

- [Spring Application Advisor Documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-5/app-advisor/index.html)
- [Running the CLI](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-5/app-advisor/run-app-advisor-cli.html)
- [CI/CD Integration](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-5/app-advisor/ci-cd.html)

## Quick Reference

Here are the key commands you've learned:

```bash
# Download and install the CLI
curl -L -H "Authorization: Bearer $ARTIFACTORY_TOKEN" \
  -o advisor-cli.tar \
  https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/application-advisor-cli-linux/1.5.5/application-advisor-cli-linux-1.5.5.tar

# Extract to a directory on your PATH
tar -xf advisor-cli.tar --strip-components=1 --exclude=./META-INF -C ~/bin

# Verify installation
advisor --help

# Basic upgrade workflow
advisor build-config get
advisor upgrade-plan get
advisor upgrade-plan apply
```

## Summary

In this workshop, you learned how to:

1. **Install the CLI** - Download and extract the Spring Application Advisor CLI
2. **Configure Maven** - Set up access to the commercial recipe repository
3. **Verify the installation** - Run a test upgrade to confirm everything works

You're now ready to start upgrading your Spring applications!

The next session is optional and covers some common troubleshooting topics.