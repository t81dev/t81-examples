#!/usr/bin/env bash
set -euo pipefail

echo "runtime-v0.4 e2e entrypoint is deprecated; forwarding to runtime-v0.5"
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run-runtime-v0.5-e2e.sh" "$@"
