#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(cd "${ROOT}/.." && pwd)}"
VM_DIR="${T81_VM_DIR:-${CODE_ROOT}/t81-vm}"
OUT_DIR="${ROOT}/examples/runtime-v0.5-mode-parity"
PARITY_JSON="${OUT_DIR}/parity-evidence.json"

mkdir -p "${OUT_DIR}"

if [[ ! -d "${VM_DIR}" ]]; then
  echo "missing required repo path: ${VM_DIR}" >&2
  exit 1
fi

echo "[1/2] build runtime artifacts in t81-vm"
make -C "${VM_DIR}" build-check >/dev/null

echo "[2/2] run interpreter vs accelerated-preview parity checks"
PARITY_EVIDENCE_OUT="${PARITY_JSON}" "${VM_DIR}/scripts/check-mode-parity.sh"
python3 - <<'PY' "${PARITY_JSON}"
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
payload = json.loads(path.read_text(encoding="utf-8"))
if not payload.get("overall_ok"):
    raise SystemExit("mode parity evidence indicates non-equal required signals")
vectors = set(payload.get("canonical_vectors", []))
required = {
    "tests/harness/test_vectors/arithmetic.t81",
    "tests/harness/test_vectors/faults.t81",
    "tests/harness/test_vectors/tensor_fault_chain.t81",
}
missing = sorted(required - vectors)
if missing:
    raise SystemExit(f"mode parity evidence missing canonical vectors: {missing}")
print("mode parity evidence summary: ok")
PY

echo "runtime-v0.5 mode parity: ok"
