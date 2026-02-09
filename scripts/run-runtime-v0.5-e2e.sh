#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(cd "${ROOT}/.." && pwd)}"
LANG_DIR="${T81_LANG_DIR:-${CODE_ROOT}/t81-lang}"
VM_DIR="${T81_VM_DIR:-${CODE_ROOT}/t81-vm}"
PY_DIR="${T81_PYTHON_DIR:-${CODE_ROOT}/t81-python}"

CANARY_JSON="${ROOT}/examples/runtime-v0.5-e2e/canary.tisc.json"
VM_OUT="${ROOT}/examples/runtime-v0.5-e2e/vm.out"

for req in "${LANG_DIR}" "${VM_DIR}" "${PY_DIR}"; do
  if [[ ! -d "${req}" ]]; then
    echo "missing required repo path: ${req}" >&2
    exit 1
  fi
done

echo "[1/4] emit canary bytecode from t81-lang"
python3 "${LANG_DIR}/scripts/emit-canary-bytecode.py" "${CANARY_JSON}"

echo "[2/4] build runtime artifacts in t81-vm"
make -C "${VM_DIR}" build-check >/dev/null
VM_LIB="${VM_DIR}/build/libt81vm_capi.dylib"
if [[ ! -f "${VM_LIB}" ]]; then
  VM_LIB="${VM_DIR}/build/libt81vm_capi.so"
fi
if [[ ! -f "${VM_LIB}" ]]; then
  echo "missing VM shared library (.dylib/.so) under ${VM_DIR}/build" >&2
  exit 1
fi

echo "[3/4] run canary in t81-vm CLI"
"${VM_DIR}/build/t81vm" --snapshot "${CANARY_JSON}" | tee "${VM_OUT}" >/dev/null
grep -q '^STATE_HASH ' "${VM_OUT}" || { echo "missing STATE_HASH in VM output" >&2; exit 1; }
VM_HASH="$(grep '^STATE_HASH ' "${VM_OUT}" | tail -n1 | awk '{print $2}')"

echo "[4/4] run same canary via t81-python VM bridge"
PYTHONPATH="${PY_DIR}/src" T81_VM_LIB="${VM_LIB}" python3 - <<'PY' "${CANARY_JSON}" "${VM_HASH}"
from pathlib import Path
import sys

from t81_python.vm_bridge import VMBridge

program = Path(sys.argv[1])
expected_hash = sys.argv[2].strip().lower().replace("0x", "")

bridge = VMBridge()
bridge.load_file(program)
status = bridge.run_to_halt()
if status != 0:
    raise SystemExit(f"bridge run failed: status={status}")

actual_hash = f"{bridge.state_hash():016x}"
if actual_hash != expected_hash:
    raise SystemExit(f"state hash mismatch bridge={actual_hash} vm={expected_hash}")

print(f"bridge_state_hash=0x{actual_hash}")
PY

echo "runtime-v0.5 e2e: ok"
