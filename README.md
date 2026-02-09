# t81-examples
Curated demo

This repository is the canonical consumer integration path for the active
runtime contract baseline.

## Canonical Runtime v0.5 Bundles

### 1) End-to-End Bridge Path

See `examples/runtime-v0.5-e2e/README.md` for the deterministic consumer
bridge path:

1. emit canary bytecode via `t81-lang`,
2. execute in `t81-vm`,
3. execute again through the `t81-python` VM bridge.

Run it with:

```bash
scripts/run-runtime-v0.5-e2e.sh
```

### 2) Trap Diagnostics Path

See `examples/runtime-v0.5-trap-diagnostics/README.md` for trap payload
contract checks:

```bash
scripts/run-runtime-v0.5-trap-diagnostics.sh
```

### 3) Mode Parity Path

See `examples/runtime-v0.5-mode-parity/README.md` for interpreter vs
accelerated-preview parity evidence validation:

```bash
scripts/run-runtime-v0.5-mode-parity.sh
```

Runtime contract marker: `contracts/runtime-contract.json`.

## Positioning

- Canonical path: `t81-examples` runtime contract-aligned bundles.
- Reference path: `t81-foundation/examples` for broader research and exploratory demos.
