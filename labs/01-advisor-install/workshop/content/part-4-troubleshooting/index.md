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

3. **Verify the settings.xml is correct for your environment:**
   You may need mirrors, or access credentials set for your `~/.m2/settings.xml`.  Refer to [https://maven.apache.org/settings.html] for more information.

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
| "tar: command not found" | tar utility not installed | Install tar using package manager |
