---
title: Troubleshooting
---
# Troubleshooting

Common issues and their solutions when installing Spring Application Advisor.

## CLI Download Issues

### Problem: Cannot Download CLI

**Symptoms:**
- 401 Unauthorized
- 403 Forbidden
- Connection timeout

**Solutions:**

1. **Verify Artifactory token is valid:**
   - Token hasn't expired
   - Token has download permissions
   - Token was generated from the Broadcom Support Portal

2. **Check the token is set correctly:**
   ```execute
   echo "Token length: ${#ARTIFACTORY_TOKEN}"
   ```
   If the length is 0, the token is not set.

3. **Check network connectivity:**
   ```copy
   ping -c 3 packages.broadcom.com
   ```

4. **Try with proxy settings (if behind corporate proxy):**
   ```copy-and-edit
   export HTTP_PROXY=http://proxy.company.com:8080
   export HTTPS_PROXY=http://proxy.company.com:8080
   ```

### Problem: Extraction Fails

**Symptoms:**
- "tar: command not found"
- Extraction errors
- Corrupted archive

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
   ```copy
   ls -lh advisor-cli.tar
   ```

   If the file size is very small (< 1MB), it may be corrupted or the download failed. Re-download the CLI.

3. **Check for disk space:**
   ```copy
   df -h .
   ```

## Maven Repository Configuration

### Problem: Commercial Recipes Not Accessible

**Symptoms:**
- "Could not resolve recipe" errors
- "Recipe not found" messages
- Upgrade plan apply fails with dependency errors

**Solutions:**

1. **Verify Maven settings.xml exists and is configured:**
   ```execute
   cat ~/.m2/settings.xml
   ```

2. **Check the repository URL is correct:**
   - Workshop: `http://<workshop-namespace>-files/artifactory/tanzu-maven`
   - Production: `https://packages.broadcom.com/artifactory/spring-enterprise`

3. **Verify credentials (for production):**
   - Username should be your Broadcom Support Portal email
   - Password should be your `ARTIFACTORY_TOKEN`

4. **Test repository connectivity (production):**
   ```copy
   curl -u "your-email@company.com:$ARTIFACTORY_TOKEN" \
     https://packages.broadcom.com/artifactory/spring-enterprise/
   ```

### Problem: Cannot Resolve Dependencies During Verification

**Symptoms:**
- "Could not resolve dependencies" during `advisor upgrade-plan apply`
- Maven download errors

**Solutions:**

1. **Clear Maven cache and retry:**
   ```copy
   rm -rf ~/.m2/repository
   advisor build-config get
   advisor upgrade-plan apply
   ```

2. **Check network connectivity to Maven Central:**
   ```copy
   curl -I https://repo1.maven.org/maven2/
   ```

3. **Verify the active profile is set in settings.xml:**
   Look for `<activeProfiles>` section in your `~/.m2/settings.xml`

## Getting More Help

If you're still experiencing issues:

1. **Review official documentation:**
   - [Spring Application Advisor Documentation](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-5/app-advisor/index.html)
   - [Running the CLI](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/application-advisor/1-5/app-advisor/run-app-advisor-cli.html)

2. **Contact support:**
   - Broadcom Support Portal
   - Your organization's internal support channels

## Common Error Messages Reference

| Error Message | Likely Cause | Solution |
|---------------|--------------|----------|
| "401 Unauthorized" | Invalid or expired token | Verify ARTIFACTORY_TOKEN is set and valid |
| "403 Forbidden" | Token lacks download permissions | Regenerate token with correct permissions |
| "Connection timed out" | Network issues or firewall | Check proxy settings and firewall rules |
| "Could not resolve recipe" | Maven repository not configured | Check ~/.m2/settings.xml configuration |
| "tar: command not found" | tar utility not installed | Install tar using package manager |
