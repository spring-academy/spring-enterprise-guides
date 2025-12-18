---
title: Next Steps
---
# Next Steps

Congratulations on completing the Spring Application Advisor workshop! Here are some recommendations for continuing your journey.

## Practice and Experimentation

### Try It on a Test Project First

Before using Spring Application Advisor on production code:

1. **Create a test branch:**
   ```execute
   git checkout -b test-spring-advisor
   ```

2. **Run the full upgrade process:**
   ```execute
   ./advisor build-config get
   ```
   ```execute
   ./advisor upgrade-plan get
   ```
   ```execute
   ./advisor upgrade-plan apply
   ```

3. **Review the changes thoroughly:**
   ```execute
   git diff
   ```

4. **Test your application:**
   - Run all unit tests
   - Run integration tests
   - Perform manual testing
   - Check for deprecation warnings

### Start with Smaller Projects

Build confidence by starting with:

- Microservices with fewer dependencies
- Internal tools or utilities
- Non-critical applications
- Projects with good test coverage

## Integrate into Your Development Workflow

### Regular Upgrade Schedule

Establish a routine for keeping applications up-to-date:

- **Weekly**: Check for available upgrades
- **Monthly**: Apply non-breaking upgrades
- **Quarterly**: Plan major version upgrades
- **Annual**: Review overall Spring Boot strategy

### Team Adoption

Help your team adopt Spring Application Advisor:

1. **Share this workshop** with team members
2. **Create internal documentation** specific to your organization
3. **Set up pair programming sessions** for initial upgrades
4. **Establish review processes** for advisor-generated PRs
5. **Document lessons learned** from each upgrade

## Advanced Configurations

### Customize for Your Organization

Explore additional configuration options:

- **Custom upgrade rules** for your organization's needs
- **Integration with internal tools** and systems
- **Custom formatting rules** to match your style guide
- **Automated testing** in CI/CD pipelines

### Monitoring and Metrics

Track your upgrade efforts:

- Number of applications upgraded
- Time saved compared to manual upgrades
- Issues discovered during upgrades
- Success rate of automated PRs

## Deepen Your Knowledge

### Learn More About Spring Boot Upgrades

- **Spring Boot Migration Guides**: Understand what changes between versions
  - [Spring Boot 2.x to 3.x Migration](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Migration-Guide)
  
- **Spring Framework Documentation**: Stay current with framework changes
  - [What's New in Spring](https://spring.io/blog/category/news)

### OpenRewrite

Spring Application Advisor uses OpenRewrite under the hood:

- [OpenRewrite Documentation](https://docs.openrewrite.org/)
- [Writing Custom Recipes](https://docs.openrewrite.org/authoring-recipes/recipe-development-environment)
- [Recipe Catalog](https://docs.openrewrite.org/recipes)

### DevOps and Automation

Enhance your CI/CD skills:

- **GitHub Actions**: Automate more workflows
- **GitLab CI/CD**: Advanced pipeline configurations
- **Jenkins**: Enterprise automation patterns
- **Infrastructure as Code**: Terraform, Ansible for environment management

## Contributing Back

### Share Your Experience

Help others by:

- Writing blog posts about your upgrade experiences
- Speaking at local meetups or conferences
- Contributing to community forums
- Creating example projects

### Provide Feedback

Help improve Spring Application Advisor:

- Report bugs and issues to Broadcom
- Suggest new features
- Share use cases and success stories

## Keep Learning

### Stay Updated

- **Subscribe to Spring newsletters**: Get notified of new releases
- **Follow Spring social media**: Twitter, LinkedIn, YouTube
- **Join Spring community**: Slack channels, forums
- **Attend Spring events**: SpringOne, local meetups

### Related Technologies

Expand your knowledge:

- **Spring Cloud**: Microservices patterns
- **Spring Security**: Authentication and authorization
- **Spring Data**: Database access patterns
- **Reactive Programming**: Spring WebFlux

## Building Expertise

### Certification

Consider pursuing Spring certifications:

- Spring Professional Certification
- Spring Boot Certification
- Cloud-native development certifications

### Hands-on Projects

Apply what you've learned:

- **Migrate a legacy application** to the latest Spring Boot
- **Build a new microservice** with current best practices
- **Contribute to open-source** Spring projects
- **Mentor others** in your organization

## Community Resources

### Official Resources

- [Spring Application Advisor Documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-4/)
- [Spring Boot Reference Guide](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Framework Documentation](https://docs.spring.io/spring-framework/docs/current/reference/html/)
- [Tanzu Developer Center](https://tanzu.vmware.com/developer/)

### Community Forums

- [Spring Community Forum](https://stackoverflow.com/questions/tagged/spring-boot)
- [Spring on Stack Overflow](https://stackoverflow.com/questions/tagged/spring)
- [Reddit r/springframework](https://www.reddit.com/r/springframework/)

### Blogs and Tutorials

- [Spring Blog](https://spring.io/blog)
- [Baeldung](https://www.baeldung.com/spring-boot)
- [DZone Spring Zone](https://dzone.com/spring-boot-tutorials)

## Quick Reference Commands

Keep these commands handy:

```copy
# Generate build configuration
./advisor build-config get

# Get upgrade plan
./advisor upgrade-plan get

# Apply upgrades locally
./advisor upgrade-plan apply

# Apply with formatter
./advisor upgrade-plan apply --after-upgrade-cmd=spring-javaformat:apply

# Apply with increased memory
./advisor upgrade-plan apply --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx2g"

# Continuous upgrades
./advisor build-config get
./advisor build-config publish
./advisor upgrade-plan apply --push --from-yml
```

## Final Thoughts

Spring Application Advisor is a powerful tool that can:

- **Save significant time** on routine upgrades
- **Reduce human error** in migration processes
- **Keep your applications secure** with latest patches
- **Enable continuous modernization** of your codebase

The key to success is:

1. **Start small** and build confidence
2. **Test thoroughly** after each upgrade
3. **Learn from each migration** to improve your process
4. **Share knowledge** with your team
5. **Stay current** with Spring ecosystem changes

## We Want to Hear From You!

Your feedback helps improve this workshop:

- What worked well?
- What was confusing?
- What topics should we add?
- How are you using Spring Application Advisor?

Share your experiences and help make this workshop better for future participants!

---

Thank you for completing the Spring Application Advisor workshop. Happy upgrading!
