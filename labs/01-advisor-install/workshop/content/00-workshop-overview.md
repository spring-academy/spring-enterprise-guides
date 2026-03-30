---
title: Workshop Overview
---
# Spring Application Advisor Installation Workshop

Welcome! In this workshop, you'll learn how to install the Spring Application Advisor CLI and configure your environment to access the commercial upgrade recipes.

## Workshop Environment

This workshop runs in a **Linux-based environment**. All interactive commands and examples are designed for Linux. However, where applicable, we also provide example commands for Windows and macOS platforms for your reference when working outside the workshop environment.

## Prerequisites

In this workshop, we have already set up the environment to contain all the pre-requisites you need to install and run Application Advisor. If you are trying to replicate this lab in your own environment, you will need to make sure you have:

- A Broadcom Artifactory token (stored in `ARTIFACTORY_TOKEN` environment variable), follow steps to retrieve the [Artifactory Token](https://techdocs.broadcom.com/us/en/vmware-tanzu/spring/tanzu-spring/commercial/spring-tanzu/guide-artifact-repository-administrators.html#access-enterprise-subscription)
- Java version 23 or lower installed
- Maven configured on your system

## What is Spring Application Advisor?

Spring Application Advisor is a native CLI tool that helps you upgrade Spring applications by:

- Analyzing your project's build dependencies and tools
- Creating step-by-step upgrade plans
- Applying upgrades automatically while preserving your code style

The CLI uses commercial OpenRewrite recipes to perform the actual code transformations. These recipes are built and maintained by the Spring team at Broadcom.

## Workshop Structure

This workshop is organized into the following sections:

1. **Installing the CLI** - Download and install the Spring Application Advisor CLI
2. **Configure Maven for Enterprise Recipes** - Set up access to the commercial recipe repository and verify the installation
3. **Next Steps** - Resources for continued learning
4. **Troubleshooting** - Common installation issues and their solutions

After completing this workshop, you'll have a fully functional Spring Application Advisor installation ready to upgrade your Spring applications. For hands-on experience with actual application upgrades, continue with the **Spring Application Advisor Introduction** workshop.
