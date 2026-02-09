# t81-examples
Curated demo

## Runtime v0.5 E2E Bundle

See `examples/runtime-v0.5-e2e/README.md` for a deterministic end-to-end path:

1. emit canary bytecode via `t81-lang`,
2. execute in `t81-vm`,
3. execute again through the `t81-python` VM bridge.

Run it with:

```bash
scripts/run-runtime-v0.5-e2e.sh
```

Runtime contract marker: `contracts/runtime-contract.json`.
