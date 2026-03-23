#!/bin/bash

echo "Creating bin directory in home folder"
mkdir -p $HOME/bin

# Extract test application for verification step
echo "Extracting test application"
tar -xzf /home/eduk8s/hello-spring-boot-1-5.tgz -C $HOME/
rm /home/eduk8s/hello-spring-boot-1-5.tgz

# Extract dependencies for test app
echo "Extracting ~/.m2/repository directory"
tar -xzf /home/eduk8s/deps.tgz -C $HOME/ 