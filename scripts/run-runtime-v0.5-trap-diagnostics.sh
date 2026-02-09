#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODE_ROOT="${CODE_ROOT:-$(cd "${ROOT}/.." && pwd)}"
VM_DIR="${T81_VM_DIR:-${CODE_ROOT}/t81-vm}"
OUT_DIR="${ROOT}/examples/runtime-v0.5-trap-diagnostics"

mkdir -p "${OUT_DIR}"

if [[ ! -d "${VM_DIR}" ]]; then
  echo "missing required repo path: ${VM_DIR}" >&2
  exit 1
fi

echo "[1/3] build runtime artifacts in t81-vm"
make -C "${VM_DIR}" build-check >/dev/null

echo "[2/3] execute division-fault vector with trace"
DIV_OUT="${OUT_DIR}/faults.trace.out"
set +e
"${VM_DIR}/build/t81vm" --trace "${VM_DIR}/tests/harness/test_vectors/faults.t81" 2>&1 | tee "${DIV_OUT}" >/dev/null
div_rc=$?
set -e
if [[ "${div_rc}" -eq 0 ]]; then
  echo "expected non-zero exit for division fault vector" >&2
  exit 1
fi
grep -q '^FAULT DivisionFault$' "${DIV_OUT}" || { echo "missing DivisionFault marker" >&2; exit 1; }
grep -q '^TRAP_PAYLOAD trap=DivisionFault ' "${DIV_OUT}" || { echo "missing DivisionFault payload line" >&2; exit 1; }

echo "[3/3] execute tensor fault-chain vector with trace"
TENSOR_OUT="${OUT_DIR}/tensor_fault_chain.trace.out"
set +e
"${VM_DIR}/build/t81vm" --trace "${VM_DIR}/tests/harness/test_vectors/tensor_fault_chain.t81" 2>&1 | tee "${TENSOR_OUT}" >/dev/null
tensor_rc=$?
set -e
if [[ "${tensor_rc}" -eq 0 ]]; then
  echo "expected non-zero exit for tensor fault-chain vector" >&2
  exit 1
fi
grep -q '^FAULT TypeFault$' "${TENSOR_OUT}" || { echo "missing TypeFault marker" >&2; exit 1; }
grep -q '^TRAP_PAYLOAD trap=TypeFault ' "${TENSOR_OUT}" || { echo "missing TypeFault payload line" >&2; exit 1; }

echo "runtime-v0.5 trap diagnostics: ok"
