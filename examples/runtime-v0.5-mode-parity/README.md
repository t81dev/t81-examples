# Runtime v0.5 Mode Parity Example

This bundle validates required-equal signals between `interpreter` and
`accelerated-preview` execution modes using canonical vectors declared in the
VM contract evidence metadata.

Checks:

1. mode-parity script execution succeeds,
2. parity evidence reports `overall_ok=true`,
3. expected canonical vectors are present in evidence metadata.

## Run

```bash
scripts/run-runtime-v0.5-mode-parity.sh
```
