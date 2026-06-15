#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# deploy-docs.sh — publish the kumbuka docs site (docs.kumbuka.ai)
#
# Builds the Astro Starlight site to static HTML *inside a container* (so no
# Node/pnpm is needed on the host or on a contributor's machine) and copies the
# output into the jba-stack web root, where the edge Caddy serves it live.
#
# The build uses the repo's own Dockerfile `build` stage — the single source of
# truth for how the site is built, and the link-validation gate. If the build
# fails (e.g. a broken internal link), the script aborts *before* touching the
# live site, so a bad build can never overwrite good docs.
#
# Caddy serves the files directly, so there is NO restart and NO downtime — the
# new files are picked up on the next request.
#
# Usage:
#   ./deploy-docs.sh            # build from the current checkout and publish
#   ./deploy-docs.sh --no-build # publish an existing ./dist (e.g. from `pnpm build`)
#
# Requirements: docker + rsync on the host. Writing the web root needs root, so
# the script uses `sudo` for that single step (you may be prompted).
# ---------------------------------------------------------------------------
set -euo pipefail

WEBROOT="/var/www/html/kmbkdocs"   # jba-stack web root, bind-mounted into Caddy
BUILD_STAGE="build"                # the Dockerfile's node build stage
IMAGE_TAG="kmbkdocs-build:local"
LOCK="/tmp/kmbkdocs-deploy.lock"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

NO_BUILD=0
[ "${1:-}" = "--no-build" ] && NO_BUILD=1

command -v rsync >/dev/null 2>&1 || die "rsync not found on PATH"

# Only one deploy at a time (several people may share the host).
exec 9>"$LOCK"
flock -n 9 || die "another docs deploy is already running"

# docker may or may not need sudo depending on the user's group membership.
DOCKER="docker"
$DOCKER info >/dev/null 2>&1 || DOCKER="sudo docker"

# Advisory: show what revision is being shipped and whether it's current.
branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '?')"
commit="$(git rev-parse --short HEAD 2>/dev/null || echo '?')"
log "deploying docs from ${branch}@${commit}"
git fetch -q origin main 2>/dev/null || true
if git rev-parse origin/main >/dev/null 2>&1; then
  behind="$(git rev-list --count HEAD..origin/main 2>/dev/null || echo 0)"
  [ "$behind" != "0" ] && \
    echo "    note: HEAD is ${behind} commit(s) behind origin/main — run 'git pull' for the latest docs"
fi

STAGE="$(mktemp -d)"
CID=""
cleanup() { rm -rf "$STAGE"; [ -n "$CID" ] && $DOCKER rm -f "$CID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

if [ "$NO_BUILD" -eq 1 ]; then
  # Publish an already-built ./dist (e.g. a native `pnpm build`).
  [ -f dist/index.html ] || die "--no-build given but ./dist/index.html is missing — run 'pnpm build' first"
  log "using existing ./dist (skipping container build)"
  cp -a dist/. "$STAGE/"
else
  # Build the static site in the container (this is also the link-check gate).
  log "building static site in a container (Dockerfile target: ${BUILD_STAGE})"
  $DOCKER build --target "$BUILD_STAGE" -t "$IMAGE_TAG" .
  # Extract /app/dist out of the built image.
  CID="$($DOCKER create "$IMAGE_TAG")"
  $DOCKER cp "$CID:/app/dist/." "$STAGE/"
fi

# Refuse to publish an empty/broken build.
[ -f "$STAGE/index.html" ] || die "build produced no index.html — refusing to publish"

# Publish. rsync --delete makes the web root mirror the build exactly, so pages
# that were removed from the docs disappear from the live site too.
#
# The web root only needs to be world-READABLE for Caddy to serve it (the mount
# is read-only), so it does NOT need to be root-owned. If it belongs to a shared
# deploy group (setgid + group-writable), any member can publish WITHOUT sudo.
# We therefore use sudo only as a fallback, when the deployer can't write it.
SUDO=""
if [ -e "$WEBROOT" ]; then
  [ -w "$WEBROOT" ] || SUDO="sudo"
else
  [ -w "$(dirname "$WEBROOT")" ] || SUDO="sudo"
fi
if [ -n "$SUDO" ] && ! sudo -n true 2>/dev/null && ! sudo -v 2>/dev/null; then
  die "cannot write ${WEBROOT} and sudo is unavailable — ask an admin to add you to the group that owns ${WEBROOT}"
fi

log "publishing to ${WEBROOT}${SUDO:+ (via sudo)}"
$SUDO mkdir -p "$WEBROOT"
# --chmod gives dirs ug=rwx,o=rx (775) and files ug=rw,o=r (664): world-readable
# for Caddy, group-writable so the next deploy-group member can overwrite. A
# setgid web root (set up once on the host) keeps new dirs in the deploy group.
$SUDO rsync -a --delete --chmod=ug=rwX,o=rX "$STAGE/" "$WEBROOT/"

log "done — Caddy serves it live, no restart. https://docs.kumbuka.ai"
