#!/bin/bash

set -x
set -eo pipefail

curl -s "https://get.sdkman.io" | bash && \
echo "sdkman_auto_answer=true" > $HOME/.sdkman/etc/config && \
echo "sdkman_auto_selfupdate=false" >> $HOME/.sdkman/etc/config && \
source "$HOME/.sdkman/bin/sdkman-init.sh" && \
sdk install java $(sdk list java | grep  "17.*[0-9]-librca" | awk '{print $NF}' | head -n 1) && \
sdk install java $(sdk list java | grep  "11.*[0-9]-librca" | awk '{print $NF}' | head -n 1)

(cd /opt/git/repositories && git clone --bare https://github.com/timosalm/spring-petclinic-2.7 spring-petclinic && echo ".advisor" >> .gitignore)
