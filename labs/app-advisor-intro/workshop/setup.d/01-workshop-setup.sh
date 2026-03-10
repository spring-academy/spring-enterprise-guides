#!/bin/bash

set -x
set -e

# 1. Install SDKMAN if not present
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
fi

# 2. Load SDKMAN into the current shell session
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# 3. FORCE non-interactive mode for automated installs
export sdkman_auto_answer=true

# 4. Install Java versions
# Note: Using '|| true' helps if the version is already installed
sdk install java 17.0.18-librca || true
sdk install java 11.0.30-librca || tru

mkdir -p /opt/git/repositories
(cd /opt/git/repositories && git clone --bare https://github.com/timosalm/spring-petclinic-2.7 spring-petclinic && echo ".advisor" >> .gitignore)