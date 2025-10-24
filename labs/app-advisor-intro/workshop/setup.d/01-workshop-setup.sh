#!/bin/bash

set -x
set -eo pipefail

(cd /opt/git/repositories && git clone --bare https://github.com/timosalm/spring-petclinic-2.7 spring-petclinic && echo ".advisor" >> .gitignore)

export PATH=${PATH}:/opt/tanzu/bin
echo "export PATH=${PATH}:${HOME}/opt/tanzu/bin" >> ${HOME}/.bash_profile