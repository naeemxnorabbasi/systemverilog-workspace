# forever_tb — SystemVerilog `forever` construct demo

Plain SystemVerilog example (no UVM) showing three common `forever` patterns from the language reference.

## DUT

`counter` — 8-bit counter with synchronous enable and active-low reset.

## Testbench patterns

| Pattern | Location | Purpose |
|---------|----------|---------|
| `forever` + delay | `Clocking` block | Generate a free-running clock |
| `forever` + `break` | `Stimulus` block | Loop until a test condition is met |
| `disable` | `Stimulus` block | Stop a named `forever` block cleanly |

## How to run

```sh
vivado2025
cd forever_tb/scripts
source run_xsim.csh
```

Expected output ends with `PASS: forever demo complete`.
