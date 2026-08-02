#!/usr/bin/env bash
set -euo pipefail

OUTPUT_MODE="${1:-}"

case "${OUTPUT_MODE}" in
  load)
    OUTPUT_FLAG=--load
    ;;
  push)
    OUTPUT_FLAG=--push
    ;;
  *)
    echo "Usage: $0 {load|push}" >&2
    exit 2
    ;;
esac

IMAGE_NAMESPACE="${IMAGE_NAMESPACE:-bluejamkmy}"
IMAGE_NAME="${IMAGE_NAME:-sbx-rust-web}"
PLATFORM="${PLATFORM:-linux/arm64}"
ANTIGRAVITY_INSTALL_URL="${ANTIGRAVITY_INSTALL_URL:-https://antigravity.google/cli/install.sh}"

build_image() {
  local tag="$1"
  local base_variant="$2"
  shift 2

  docker buildx build \
    --platform "${PLATFORM}" \
    --build-arg "BASE_VARIANT=${base_variant}" \
    "$@" \
    -f Dockerfile \
    -t "${IMAGE_NAMESPACE}/${IMAGE_NAME}:${tag}" \
    "${OUTPUT_FLAG}" \
    .
}

build_image codex codex-docker
build_image claude-code claude-code-docker
build_image antigravity shell-docker \
  --build-arg "ANTIGRAVITY_INSTALL_URL=${ANTIGRAVITY_INSTALL_URL}"
