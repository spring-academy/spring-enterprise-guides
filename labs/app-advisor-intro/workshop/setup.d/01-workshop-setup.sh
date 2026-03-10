set -x

set -o pipefail

curl -s "https://get.sdkman.io" | bash

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

echo "sdkman_auto_answer=true" > "$SDKMAN_DIR/etc/config"
echo "sdkman_auto_selfupdate=false" >> "$SDKMAN_DIR/etc/config"

set -e

JAVA_17=$(sdk list java | grep "17.*[0-9]-librca" | awk '{print $NF}' | head -n 1)
sdk install java "$JAVA_17"

JAVA_11=$(sdk list java | grep "11.*[0-9]-librca" | awk '{print $NF}' | head -n 1)
sdk install java "$JAVA_11"

mkdir -p /opt/git/repositories
(cd /opt/git/repositories && git clone --bare https://github.com/timosalm/spring-petclinic-2.7 spring-petclinic && echo ".advisor" >> .gitignore)