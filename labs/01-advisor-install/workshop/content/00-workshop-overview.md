---
title: Workshop Overview
---
# Spring Application Advisor Workshop

Welcome! In this workshop, you'll learn how to install and use the Spring Application Advisor CLI to upgrade your Spring Boot applications.

## Workshop Environment

This workshop runs in a **Linux-based environment**. All interactive commands and examples are designed for Linux. However, where applicable, we also provide example commands for Windows and macOS platforms for your reference when working outside the workshop environment.

## Prerequisites

Before you begin, make sure you have:

- A Broadcom Artifactory token (stored in `ARTIFACTORY_TOKEN` environment variable)
- Java version 23 or lower installed
- Maven or Gradle configured on your system
- Access to the Spring Maven Enterprise repository

## What is Spring Application Advisor?

Spring Application Advisor is a native CLI tool that helps you upgrade Spring applications by:

- Analyzing your project's build dependencies and tools
- Creating step-by-step upgrade plans
- Applying upgrades automatically while preserving your code style

The CLI supports two main commands:

- `build-config` - Analyzes project build dependencies and tools
- `upgrade-plan` - Retrieves or applies upgrade plans to your project

## Workshop Structure

This workshop is organized into the following sections:

1. **Installing the CLI** - Get started with installing the Spring Application Advisor CLI
2. **Using Spring Application Advisor** - Learn the core functionality and commands
3. **Advanced Usage** - Explore advanced features and configuration options
4. **Enabling Continuous Upgrades** - Set up automated upgrade workflows
5. **Troubleshooting** - Common issues and their solutions
6. **Next Steps** - Resources for continued learning
