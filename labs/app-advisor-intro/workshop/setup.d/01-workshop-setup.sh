#!/bin/bash

set -x
set -eo pipefail

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version

sdk install java 17.0.18-librca
sdk install java 11.0.30-librca

mkdir -p /opt/git/repositories
(cd /opt/git/repositories && git clone --bare https://github.com/timosalm/spring-petclinic-2.7 spring-petclinic && echo ".advisor" >> .gitignore)