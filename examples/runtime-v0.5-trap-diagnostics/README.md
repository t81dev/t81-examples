# Runtime v0.5 Trap Diagnostics Example

This bundle validates trap-class and trap-payload output contracts for the
active runtime baseline.

Signals verified:

1. `DivisionFault` from `faults.t81`
2. `TypeFault` from `tensor_fault_chain.t81`
3. canonical `TRAP_PAYLOAD` lines for both fault classes

## Run

```bash
scripts/run-runtime-v0.5-trap-diagnostics.sh
```
