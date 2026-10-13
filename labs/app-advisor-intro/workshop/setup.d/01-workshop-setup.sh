#!/bin/bash

set -x
set -e

# Session pods have no internet access (see the NetworkPolicies in the Workshop resource).
# Everything is either packaged in the workshop files at build time (./sources) or served by
# the in-cluster services below, which are populated once per workshop environment:
#   LAB_FILES_URL   - file service with the SDKMAN/JDK bundle
#   MAVEN_MIRROR_URL - read-only caching proxy of Maven Central
: "${LAB_FILES_URL:?}" "${MAVEN_MIRROR_URL:?}"

# 1. Wait for the environment-level jobs to publish the SDKMAN bundle
for i in $(seq 1 90); do
    curl -sf --head "$LAB_FILES_URL/sdkman.tar.gz" > /dev/null && break
    echo "Waiting for $LAB_FILES_URL/sdkman.tar.gz ($i/90)"
    sleep 5
done

# 2. Install SDKMAN and the Java versions used in the lab from the bundle
# (the bundle is built with 17 installed first, then 11, which leaves 11 as the default like before)
if [ ! -d "$HOME/.sdkman" ]; then
    curl -sf "$LAB_FILES_URL/sdkman.tar.gz" | tar -xz -C "$HOME"
fi
# Never call out to api.sdkman.io
sed -i -e 's/^sdkman_auto_answer=.*/sdkman_auto_answer=true/' \
       -e 's/^sdkman_auto_update=.*/sdkman_auto_update=false/' \
       -e 's/^sdkman_selfupdate_feature=.*/sdkman_selfupdate_feature=false/' \
       "$HOME/.sdkman/etc/config"
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk offline enable

# 3. Maven resolves everything through the in-cluster mirror
mkdir -p "$HOME/.m2"
cat > "$HOME/.m2/settings.xml" <<EOF
<settings>
  <mirrors>
    <mirror>
      <id>lab-mirror</id>
      <mirrorOf>*</mirrorOf>
      <url>${MAVEN_MIRROR_URL}</url>
    </mirror>
  </mirrors>
</settings>
EOF
export MVNW_REPOURL="$MAVEN_MIRROR_URL"

SOURCES_DIR=/opt/workshop/workshop/sources

# 4. Make sample code repository available on local git server
mkdir -p /opt/git/repositories
cp -r "$SOURCES_DIR/spring-petclinic.git" /opt/git/repositories/spring-petclinic
(cd /opt/git/repositories && printf "\n.advisor" >> .gitignore)

# 5. Add sample corporate starters to local maven cache
git clone "$SOURCES_DIR/saa-corporate-starter-sample.git" saa-corporate-starter-sample
cd saa-corporate-starter-sample
git checkout 1.0.0 && ./mvnw install
git checkout 2.0.0 && ./mvnw install
git checkout 3.0.0 && ./mvnw install
cd ..
rm -rf saa-corporate-starter-sample
