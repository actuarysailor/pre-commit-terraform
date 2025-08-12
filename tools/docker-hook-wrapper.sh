#!/usr/bin/env bash
# Docker hook wrapper script
# This script is called by pre-commit when using language: docker_image
# It extracts the hook ID and calls the appropriate hook script

set -eo pipefail

# Parse arguments to find the hook ID
HOOK_ID=""
HOOK_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --hook-config=--hook-id=*)
      HOOK_ID="${1#*=}"
      shift
      ;;
    *)
      HOOK_ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ -z "$HOOK_ID" ]]; then
  echo "Error: No hook ID specified. Use --hook-config=--hook-id=HOOK_NAME"
  exit 1
fi

# Set up environment variables that hooks expect
export SCRIPT_DIR="/usr/bin/hooks"
export PATH="/usr/bin:$PATH"

# Call the specific hook script
HOOK_SCRIPT="/usr/bin/hooks/${HOOK_ID}.sh"
if [[ ! -f "$HOOK_SCRIPT" ]]; then
  echo "Error: Hook script not found: $HOOK_SCRIPT"
  exit 1
fi

exec "$HOOK_SCRIPT" "${HOOK_ARGS[@]}"
