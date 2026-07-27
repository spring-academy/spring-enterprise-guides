#!/usr/bin/env bash
#
# Run a single workshop lab locally with Educates.
#
# For the chosen lab this script will:
#   1. derive a local workshop definition from resources/apply/<workshop-id>.yaml
#      (the same manifest used for the real deployment), pointing the workshop
#      files at a local web server instead of the in-cluster files server and
#      dropping the Kubernetes-only bits (initContainers, volumes, patches, ...)
#   2. bundle the lab's content (workshop, ...) into assets.tar, together with
#      the Application Advisor CLI binary
#   3. serve assets.tar on http://localhost:8082 (host.docker.internal:8082)
#   4. deploy the workshop with `educates docker workshop deploy`
#
# Application Advisor CLI:
#   In the real deployment an initContainer downloads the CLI from a Google
#   Cloud Storage bucket and mounts it at /home/eduk8s/bin/advisor. That is not
#   possible locally (no bucket credentials, and `educates docker workshop
#   deploy` ignores initContainers/volumes anyway). Instead, this script takes
#   the binary from application-advisor-cli-linux.tar in the root of this
#   repository, ships it inside assets.tar and installs it into ~/bin via a
#   generated setup.d script.
#
#   Override the location of that tar with ADVISOR_CLI_TAR=/path/to/cli.tar
#
# Usage:
#   ./run-lab-locally.sh <lab>        # e.g. ./run-lab-locally.sh app-advisor-intro
#   ./run-lab-locally.sh              # lists the available labs
#
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LABS_DIR="$ROOT_DIR/labs"
APPLY_DIR="$ROOT_DIR/resources/apply"
PORT="${PORT:-8082}"

list_labs() {
  echo "Available labs:"
  for d in "$LABS_DIR"/*/; do
    name="$(basename "$d")"
    [ -f "$d/WORKSHOP_ID" ] || continue
    id="$(cat "$d/WORKSHOP_ID")"
    if [ -f "$APPLY_DIR/$id.yaml" ]; then
      printf '  %-32s (%s)\n' "$name" "$id"
    else
      printf '  %-32s (%s) -- no resources/apply/%s.yaml, skipped\n' "$name" "$id" "$id"
    fi
  done
}

LAB="${1:-}"
if [ -z "$LAB" ]; then
  list_labs
  exit 0
fi

LAB_DIR="$LABS_DIR/$LAB"
if [ ! -d "$LAB_DIR" ]; then
  echo "Error: lab '$LAB' not found under labs/." >&2
  echo >&2
  list_labs >&2
  exit 1
fi

if [ ! -f "$LAB_DIR/WORKSHOP_ID" ]; then
  echo "Error: $LAB_DIR/WORKSHOP_ID is missing." >&2
  exit 1
fi
WORKSHOP_ID="$(cat "$LAB_DIR/WORKSHOP_ID")"

APPLY_YAML="$APPLY_DIR/$WORKSHOP_ID.yaml"
if [ ! -f "$APPLY_YAML" ]; then
  echo "Error: no apply manifest at resources/apply/$WORKSHOP_ID.yaml for lab '$LAB'." >&2
  exit 1
fi

# Locate the Application Advisor CLI tar (replacement for the initContainer).
ADVISOR_CLI_TAR="${ADVISOR_CLI_TAR:-}"
if [ -z "$ADVISOR_CLI_TAR" ]; then
  for candidate in "$ROOT_DIR"/application-advisor-cli-linux*.tar; do
    [ -f "$candidate" ] && ADVISOR_CLI_TAR="$candidate" && break
  done
fi
if [ -z "$ADVISOR_CLI_TAR" ] || [ ! -f "$ADVISOR_CLI_TAR" ]; then
  echo "Error: no Application Advisor CLI tar found." >&2
  echo "       Expected application-advisor-cli-linux*.tar in $ROOT_DIR," >&2
  echo "       or set ADVISOR_CLI_TAR=/path/to/application-advisor-cli-linux.tar" >&2
  exit 1
fi

# Directories shipped to the workshop session (everything but the local tooling).
CONTENT_DIRS=()
for d in "$LAB_DIR"/*/; do
  name="$(basename "$d")"
  [ "$name" = "local-resources" ] && continue
  CONTENT_DIRS+=("$name")
done
if [ ${#CONTENT_DIRS[@]} -eq 0 ]; then
  echo "Error: no content directories found in $LAB_DIR." >&2
  exit 1
fi

# The CLI binary is shipped as an extra top-level directory in the bundle.
ADVISOR_DIR="advisor-cli"
BUNDLE_DIRS=("${CONTENT_DIRS[@]}" "$ADVISOR_DIR")

BUILD_DIR="$LAB_DIR/local-resources"
mkdir -p "$BUILD_DIR"
WORKSHOP_YAML="$BUILD_DIR/workshop.yaml"
ASSETS_TAR="$BUILD_DIR/assets.tar"
ADVISOR_BIN="$BUILD_DIR/advisor"

echo "==> Lab:         $LAB"
echo "==> Workshop id: $WORKSHOP_ID"
echo "==> Content:     ${CONTENT_DIRS[*]}"
echo "==> Advisor CLI: $ADVISOR_CLI_TAR"

# --- 1. Generate the local workshop definition from the apply manifest --------
echo "==> Generating $WORKSHOP_YAML from resources/apply/$WORKSHOP_ID.yaml"
ASSETS_URL="http://host.docker.internal:$PORT/assets.tar"
INCLUDE_PATHS="$(printf '%s\n' "${BUNDLE_DIRS[@]}")" \
ASSETS_URL="$ASSETS_URL" \
python3 - "$APPLY_YAML" "$WORKSHOP_YAML" <<'PY'
import os, sys, yaml

src, dst = sys.argv[1], sys.argv[2]
with open(src) as f:
    doc = yaml.safe_load(f)

spec = doc.setdefault("spec", {})
name = doc.get("metadata", {}).get("name", "workshop")

# Publish the locally built session image to the local registry.
spec["publish"] = {"image": f"localhost:5001/{name}:latest"}

# Pull the workshop files from the local web server instead of the
# in-cluster files server.
include_paths = [f"/{p}/**" for p in os.environ["INCLUDE_PATHS"].split()]
spec.setdefault("workshop", {})["files"] = [
    {"http": {"url": os.environ["ASSETS_URL"], "includePaths": include_paths}}
]

# The in-cluster files Service/Ingress/Deployment and the GCP secret copier are
# not needed (and not supported) locally.
spec.pop("environment", None)

session = spec.get("session", {})

# Kubernetes-only session settings. `educates docker workshop deploy` runs a
# plain container, so the initContainer that fetches the Application Advisor
# CLI from the GCS bucket, its volumes and the pod patches are dropped. The CLI
# is shipped inside assets.tar instead, see the setup.d script generated by
# run-lab-locally.sh.
for key in ("initContainers", "volumes", "volumeMounts", "patches", "namespaces"):
    session.pop(key, None)

# Drop the WEBSERVER env var (points at the in-cluster files server).
env = session.get("env")
if env:
    session["env"] = [e for e in env if e.get("name") != "WEBSERVER"]

with open(dst, "w") as f:
    yaml.safe_dump(doc, f, sort_keys=False)
PY

# --- 2. Bundle the lab content and the Advisor CLI into assets.tar ------------
# Stage a copy so the originals stay untouched.
STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT
for d in "${CONTENT_DIRS[@]}"; do
  cp -R "$LAB_DIR/$d" "$STAGE_DIR/$d"
done
# Drop Maven build output so it does not bloat the bundle (rm -rf is a no-op
# when the target/ directory is absent).
for app in sample-app; do
  rm -rf "$STAGE_DIR/$app/target"
done

# Extract the CLI binary once and cache it next to the bundle.
if [ ! -f "$ADVISOR_BIN" ] || [ "$ADVISOR_CLI_TAR" -nt "$ADVISOR_BIN" ]; then
  echo "==> Extracting cli-binary/advisor from $(basename "$ADVISOR_CLI_TAR")"
  tar -xOf "$ADVISOR_CLI_TAR" cli-binary/advisor > "$ADVISOR_BIN"
  chmod +x "$ADVISOR_BIN"
fi
mkdir -p "$STAGE_DIR/$ADVISOR_DIR"
cp "$ADVISOR_BIN" "$STAGE_DIR/$ADVISOR_DIR/advisor"
chmod +x "$STAGE_DIR/$ADVISOR_DIR/advisor"

# Install the CLI into ~/bin, which is on the PATH of the session, replacing
# what the initContainer does in the real deployment. Runs before the other
# setup.d scripts so the CLI is there as early as possible.
cat > "$STAGE_DIR/workshop/setup.d/00-install-advisor-cli.sh" <<'SH'
#!/bin/bash
# Generated by run-lab-locally.sh -- local replacement for the
# download-app-advisor-cli initContainer of the real deployment.

set -x
set -e

ADVISOR_SRC="$HOME/advisor-cli/advisor"
if [ ! -f "$ADVISOR_SRC" ]; then
    ADVISOR_SRC="$(find "$HOME" -maxdepth 3 -type f -name advisor -not -path "$HOME/bin/*" 2>/dev/null | head -n 1)"
fi
if [ -z "$ADVISOR_SRC" ] || [ ! -f "$ADVISOR_SRC" ]; then
    echo "Application Advisor CLI not found in the workshop files" >&2
    exit 1
fi

mkdir -p "$HOME/bin"
cp "$ADVISOR_SRC" "$HOME/bin/advisor"
chmod +x "$HOME/bin/advisor"
rm -rf "$HOME/advisor-cli"

"$HOME/bin/advisor" --version
SH
chmod +x "$STAGE_DIR/workshop/setup.d/00-install-advisor-cli.sh"

# Point the workshop content at the git server that runs inside the session.
# In the cluster the operator passes GIT_PROTOCOL/GIT_HOST/GIT_USERNAME/
# GIT_PASSWORD into the session, and the content renders the clone command from
# them. `educates docker workshop deploy` drops spec.session.env and sets none
# of those variables, so "git clone {{ git_protocol }}://{{ git_host }}/..."
# would render as "git clone :///..." and the git server, started without
# usable credentials, would answer 401.
#
# Setup scripts run before the content is rendered and anything written to
# $WORKSHOP_ENV is exported into the rest of the startup (see
# /opt/eduk8s/bin/rebuild-workshop), so the values below reach both Hugo and the
# git server process. localhost:10087 is where the git server binds inside the
# container, which is all the terminal of the session needs.
cat > "$STAGE_DIR/workshop/setup.d/00-configure-git-server.sh" <<'SH'
#!/bin/bash
# Generated by run-lab-locally.sh -- local replacement for the git session
# variables the Educates operator provides in the real deployment.

set -x
set -e

GIT_PROTOCOL=http
GIT_HOST=localhost:10087
GIT_USERNAME=educates
GIT_PASSWORD=educates

cat >> "$WORKSHOP_ENV" <<EOF
GIT_PROTOCOL=$GIT_PROTOCOL
GIT_HOST=$GIT_HOST
GIT_USERNAME=$GIT_USERNAME
GIT_PASSWORD=$GIT_PASSWORD
EOF

# /opt/eduk8s/etc/setup.d/02-git.sh already ran with empty values, so write the
# credentials for the git server again with the ones used above.
cat > "$HOME/.git-credentials" <<EOF
$GIT_PROTOCOL://$GIT_USERNAME:$GIT_PASSWORD@$GIT_HOST
EOF
chmod 600 "$HOME/.git-credentials"
git config --global credential.helper "store --file $HOME/.git-credentials"
SH
chmod +x "$STAGE_DIR/workshop/setup.d/00-configure-git-server.sh"

echo "==> Building $ASSETS_TAR"
COPYFILE_DISABLE=1 tar --exclude='.DS_Store' \
  -cf "$ASSETS_TAR" -C "$STAGE_DIR" "${BUNDLE_DIRS[@]}"

# --- 3. Serve assets.tar ------------------------------------------------------
echo "==> Serving $BUILD_DIR on http://localhost:$PORT"
( cd "$BUILD_DIR" && exec python3 -m http.server "$PORT" ) &
SERVER_PID=$!
cleanup() {
  echo
  echo "==> Stopping web server (pid $SERVER_PID)"
  kill "$SERVER_PID" 2>/dev/null || true
  rm -rf "$STAGE_DIR"
}
trap cleanup EXIT INT TERM

# Wait for the server to accept connections.
for _ in $(seq 1 20); do
  if curl -sf -o /dev/null "http://localhost:$PORT/assets.tar"; then
    break
  fi
  sleep 0.25
done

# --- 4. Tear down any previous instance and deploy ----------------------------
echo "==> Removing any previous '$WORKSHOP_ID' containers and volumes"
# Session image of this workshop, e.g. "jdk17-environment:*" -> jdk17-environment
SESSION_IMAGE="$(python3 -c "import sys,yaml;print(yaml.safe_load(open(sys.argv[1]))['spec']['workshop']['image'].split(':')[0])" "$APPLY_YAML")"
ids="$(docker ps -a --format '{{.ID}} {{.Image}} {{.Names}}' 2>/dev/null \
  | grep -E "educates-cli--$WORKSHOP_ID|educates-$SESSION_IMAGE" \
  | awk '{print $1}' || true)"
[ -n "$ids" ] && docker rm -f -v $ids >/dev/null 2>&1 || true
vols="$(docker volume ls --format '{{.Name}}' 2>/dev/null \
  | grep "^educates-cli--$WORKSHOP_ID" || true)"
[ -n "$vols" ] && docker volume rm $vols >/dev/null 2>&1 || true

echo "==> Deploying with educates"
educates docker workshop deploy -f "$WORKSHOP_YAML"

echo
echo "==> '$WORKSHOP_ID' deployed. The session setup installs two JDKs via"
echo "    SDKMAN and builds the sample corporate starters, so it takes a few"
echo "    minutes before the terminal is usable."
echo "==> Web server still running so the session can refetch its files."
echo "    Press Ctrl+C to stop the server."
wait "$SERVER_PID"
