# README

This repository contains the [Spring Enterprise](spring.academy/guides) guides content.

## Running a lab locally

`run-lab-locally.sh` deploys a single lab with Educates in Docker, using the same
manifest (`resources/apply/<workshop-id>.yaml`) as the real deployment.

### Prerequisites

- Docker
- The [Educates CLI](https://docs.educates.dev/) (`educates`)
- Python 3 with PyYAML

### Provide the Application Advisor CLI

In the real deployment an initContainer downloads the Application Advisor CLI
from a Google Cloud Storage bucket. That is not possible locally, so **the CLI
tar with the name ``application-advisor-cli-linux*.tar` has to be copied into the root of this repository before running the
script**.

Keep the version in sync with the download URL used in the *Installing the CLI*
section of the workshop content.

### Run

```bash
./run-lab-locally.sh              # lists the available labs
./run-lab-locally.sh app-advisor-intro
```

The script generates a local workshop definition in `labs/<lab>/local-resources`
(pointing at a local web server instead of the in-cluster files server, and
without the Kubernetes-only initContainers, volumes and patches), bundles the
lab content plus the CLI binary into `assets.tar`, serves it on
`http://localhost:8082` (override with `PORT`), and deploys the workshop with
`educates docker workshop deploy`. The CLI binary is installed into `~/bin` in
the session by a generated `setup.d` script, which replaces the initContainer.

The web server keeps running so the session can refetch its files -- press
Ctrl+C to stop it once you are done. Note that the session setup installs two
JDKs via SDKMAN and builds the sample corporate starters, so it takes a few
minutes before the terminal is usable.