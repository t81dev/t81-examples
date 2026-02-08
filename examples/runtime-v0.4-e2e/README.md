# Runtime v0.4 E2E Example

This bundle verifies an end-to-end runtime path aligned with `runtime-contract-v0.5`:

1. emit deterministic canary bytecode (`t81-lang`),
2. execute the program in `t81-vm` CLI,
3. execute the same program via `t81-python` `VMBridge`.

## Requirements

- Sibling repositories under `/Users/t81dev/Code`:
  - `t81-lang`
  - `t81-vm`
  - `t81-python`
- Python 3 available for helper scripts.

## Run

```bash
scripts/run-runtime-v0.4-e2e.sh
```

Expected output includes:

- `STATE_HASH ...` from the VM CLI run,
- matching bridge state hash line:
  - `bridge_state_hash=0x...`
