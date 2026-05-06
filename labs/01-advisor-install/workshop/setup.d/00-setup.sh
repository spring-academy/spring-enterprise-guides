#!/bin/bash

echo "Creating bin directory in home folder"
mkdir -p $HOME/bin

# Extract test application for verification step
echo "Extracting test application"
tar -xzf /home/eduk8s/hello-spring-boot-1-5.tgz --exclude='._*' --exclude='.DS_Store' -C $HOME/
rm /home/eduk8s/hello-spring-boot-1-5.tgz

# Create ~/.m2/settings.xml
mkdir -p $HOME/.m2
cat <<EOF > $HOME/.m2/settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                          http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>mirror-central</id>
      <mirrorOf>central</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/central</url>
      <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-spring-enterprise</id>
      <mirrorOf>spring-enterprise-subscription</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/spring-enterprise</url>
      <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-spring-snapshot</id>
      <mirrorOf>spring-snapshot</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/spring-snapshot</url>
      <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-gradle</id>
      <mirrorOf>gradle</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/gradle</url>
      <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-rewrite-build-plugins</id>
      <mirrorOf>rewrite-build-plugins</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/rewrite-build-plugins</url>
      <!-- Need the following if your mirror is using HTTP instead of HTTP/S-->
      <blocked>false</blocked>
    </mirror>
    <mirror>
      <id>mirror-sonatype-nexus-snapshots</id>
      <mirrorOf>sonatype-nexus-snapshots</mirrorOf>
      <url>http://${WORKSHOP_NAMESPACE}-reposilite/sonatype-nexus-snapshots</url>
      <blocked>false</blocked>
    </mirror>
  </mirrors>
</settings>
EOF