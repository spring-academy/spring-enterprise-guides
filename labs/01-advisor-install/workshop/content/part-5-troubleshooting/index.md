# Troubleshooting

Common issues and their solutions when using Spring Application Advisor.

## Build Configuration Errors

### Problem: Maven/Gradle Command Fails

**Symptoms:**
```
💔 Errors
- $repo failed with the following message:
  The maven command failed. You can find the error in .advisor/errors/${error-id}.log
```

**Solutions:**

1. **Check the error log:**
   ```copy-and-edit
   cat .advisor/errors/${error-id}.log
   ```

2. **Verify Maven/Gradle works independently:**
   ```copy
   # For Maven
   mvn clean compile
   ```
   ```copy
   # For Gradle
   gradle clean build
   ```

3. **Ensure proper Java version:**
   ```execute
   java -version
   ```
   Must be Java 23 or lower

4. **Check for corrupted dependencies:**
   ```copy
   # Maven: Clear local repository cache
   rm -rf ~/.m2/repository
   ```
   ```copy
   # Gradle: Clear cache
   rm -rf ~/.gradle/caches
   ```

### Problem: Cannot Resolve Dependencies

**Symptoms:**
- "Could not resolve dependencies" errors
- "Repository not found" messages

**Solutions:**

1. **Verify Maven settings.xml configuration:**
   - Check `~/.m2/settings.xml` (Linux/Mac)
   - Check `%USERPROFILE%\.m2\settings.xml` (Windows)
   - Ensure Spring Enterprise repository is configured

2. **Verify Artifactory token:**
   ```execute
   echo $ARTIFACTORY_TOKEN
   ```

3. **Test repository connectivity:**
   ```copy
   curl -H "Authorization: Bearer $ARTIFACTORY_TOKEN" \
     https://packages.broadcom.com/artifactory/spring-enterprise/
   ```

### Problem: Java Version Mismatch

**Symptoms:**
- "Unsupported class file major version" errors
- Compilation failures during build-config

**Solutions:**

1. **Check current Java version:**
   ```execute
   java -version
   ```

   Must be Java 23 or lower

2. **Set JAVA_HOME if needed:**
   ```copy-and-edit
   export JAVA_HOME=/path/to/java17
   ```

3. **Install compatible Java version:**
   - Download from [Adoptium](https://adoptium.net/)
   - Use SDKMan: `sdk install java 17.0.8-tem`

## Upgrade Plan Issues

### Problem: No Upgrade Plan Generated

**Symptoms:**
- Empty upgrade plan
- "No upgrades available" message

**Solutions:**

1. **Verify build configuration exists:**
   ```execute
   ls -la .advisor/build-config.json
   ```

2. **Check current versions:**
   - Review your `pom.xml` or `build.gradle`
   - Ensure you're not already on the latest version

3. **Regenerate build configuration:**
   ```copy
   rm -rf .advisor
   ./advisor build-config get
   ./advisor upgrade-plan get
   ```

### Problem: Upgrade Plan Apply Fails

**Symptoms:**
- Changes not applied
- Error messages during apply phase

**Solutions:**

1. **Ensure clean working directory:**
   ```execute
   git status
   ```
   Commit or stash any uncommitted changes

2. **Check file permissions:**
   ```copy
   # Linux/Mac: Ensure files are writable
   chmod -R u+w .
   ```

3. **Try with increased memory:**
   ```copy
   ./advisor upgrade-plan apply \
     --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx2g"
   ```

## Installation Issues

### Problem: Cannot Download CLI

**Symptoms:**
- 401 Unauthorized
- 403 Forbidden
- Connection timeout

**Solutions:**

1. **Verify Artifactory token is valid:**
   - Token hasn't expired
   - Token has download permissions

2. **Check network connectivity:**
   ```execute
   ping -c 3 packages.broadcom.com
   ```

3. **Try with proxy settings (if behind corporate proxy):**
   ```copy-and-edit
   export HTTP_PROXY=http://proxy.company.com:8080
   export HTTPS_PROXY=http://proxy.company.com:8080
   ```

### Problem: Extraction Fails

**Symptoms:**
- "tar: command not found"
- Extraction errors

**Solutions:**

1. **Install tar (if needed):**

   Debian/Ubuntu:
   ```bash
   sudo apt-get install tar
   ```

   RHEL/CentOS:
   ```bash
   sudo yum install tar
   ```

2. **Verify tar file integrity:**
   ```execute
   ls -lh advisor-cli.tar
   ```

   Re-download if corrupted

## Maven Repository Configuration

### Problem: Commercial Recipes Not Accessible

**Symptoms:**
- "Could not resolve recipe" errors
- "Recipe not found" messages

**Solutions:**

1. **Configure Maven settings.xml:**
   
   Add to `~/.m2/settings.xml`:
   
   ```xml
   <settings>
     <servers>
       <server>
         <id>spring-enterprise</id>
         <username>your-username</username>
         <password>your-token</password>
       </server>
     </servers>
     
     <profiles>
       <profile>
         <id>spring-enterprise-repos</id>
         <repositories>
           <repository>
             <id>spring-enterprise</id>
             <url>https://packages.broadcom.com/artifactory/spring-enterprise</url>
           </repository>
         </repositories>
       </profile>
     </profiles>
     
     <activeProfiles>
       <activeProfile>spring-enterprise-repos</activeProfile>
     </activeProfiles>
   </settings>
   ```

2. **Refer to official documentation:**
   - [Running Commercial Recipes](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-4/spring-app-advisor/recipes.html)

## Performance Issues

### Problem: Slow Build Configuration

**Symptoms:**
- Build config takes more than 5 minutes
- System becomes unresponsive

**Solutions:**

1. **Increase memory allocation:**
   ```copy
   ./advisor build-config get \
     --build-tool-jvm-args="-Xmx4g"
   ```

2. **Use parallel builds:**
   ```copy
   # Maven
   mvn -T 1C clean install
   ```
   ```copy
   # Gradle
   gradle --parallel
   ```

3. **Clean caches before running:**
   ```copy
   rm -rf ~/.m2/repository
   rm -rf ~/.gradle/caches
   ```

### Problem: Out of Memory Errors

**Symptoms:**
- "OutOfMemoryError: Java heap space"
- Process crashes

**Solutions:**

1. **Increase JVM heap size:**
   ```copy
   ./advisor upgrade-plan apply \
     --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx4g -Xms1g"
   ```

2. **Close other applications:**
   - Free up system memory
   - Close browser tabs
   - Stop unnecessary services

3. **Use different garbage collector:**
   ```copy
   ./advisor upgrade-plan apply \
     --build-tool-jvm-args="-Dorg.gradle.jvmargs=-Xmx2g -XX:+UseG1GC"
   ```

## CI/CD Issues

### Problem: Pull Requests Not Created

**Symptoms:**
- Pipeline succeeds but no PR appears
- "Permission denied" in logs

**Solutions:**

1. **Verify GIT_TOKEN_FOR_PRS:**
   ```bash
   # In CI/CD logs, check token is set (don't print actual value)
   echo "Token length: ${#GIT_TOKEN_FOR_PRS}"
   ```

2. **Check token permissions:**
   - GitHub: Needs `repo` scope
   - GitLab: Needs `api` and `write_repository` scopes

3. **Verify .spring-app-advisor.yml exists:**
   ```execute
   cat .spring-app-advisor.yml
   ```

### Problem: Workflow Doesn't Trigger

**Symptoms:**
- Scheduled workflow never runs
- Manual trigger not available

**Solutions:**

1. **Check schedule syntax:**
   - GitHub Actions: Uses standard cron syntax
   - GitLab CI: Configured in project settings

2. **Verify workflow is enabled:**
   - GitHub: Check Actions tab
   - GitLab: Check CI/CD → Schedules

3. **Check branch restrictions:**
   - Ensure workflow runs on correct branch

## Getting More Help

If you're still experiencing issues:

1. **Check error logs:**
   ```execute
   ls -la .advisor/errors/
   ```

2. **Review official documentation:**
   - [Spring Application Advisor Docs](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/spring-application-advisor/1-4/)

3. **Contact support:**
   - Broadcom Support Portal
   - Your organization's internal support channels

## Common Error Messages Reference

| Error Message | Likely Cause | Solution |
|---------------|--------------|----------|
| "Could not resolve dependencies" | Maven/Gradle repository misconfiguration | Check settings.xml and repository URLs |
| "OutOfMemoryError" | Insufficient heap space | Increase `-Xmx` value |
| "Unsupported class file major version" | Java version too old | Upgrade to Java 17 or newer |
| "The maven command failed" | Build tool configuration issue | Check error log in `.advisor/errors/` |
| "401 Unauthorized" | Invalid or expired token | Verify ARTIFACTORY_TOKEN |
| "Permission denied" | Insufficient Git permissions | Check GIT_TOKEN_FOR_PRS permissions |
