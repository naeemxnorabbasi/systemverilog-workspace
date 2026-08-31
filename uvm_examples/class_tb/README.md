# class_tb — SystemVerilog `class` construct demo

Plain SystemVerilog example (no UVM) illustrating the **class** construct from
SV reference material (pages ~66–70). Patterns adapted from guide syntax,
examples, rules, gotchas, and tips.

## DUT

`class_demo_dut` — simple 8-bit loadable register driven from TB classes.

## Feature map (guide → code)

| ID | Guide topic | Where |
|----|-------------|-------|
| F1 | `Register` + `new` + `load` | `register_pkg.sv`, `class_tb.sv` Stimulus |
| F2 | Handles, `new`, `new(8'hff)`, array of objects | `class_tb.sv` |
| F3 | Direct member access `accum.data = …` | `class_tb.sv` |
| F4 | Param by value `RegisterVal #(8)`, `#(.n(16))` | `register_pkg.sv` |
| F5 | Param by type `RegisterType #(int)`, `#(bit[7:0])` | `register_pkg.sv` |
| F6 | `extends`, `extern` task declarations | `ShiftRegister` in `register_pkg.sv` |
| F7 | Out-of-class `::` defs; `load` + `shiftleft` → `8'haa` | `register_pkg.sv`, `class_tb.sv` |
| F8 | `super.new(...)` first in derived `new` | `ShiftRegister`, `WideShiftRegister` |
| F9 | Static property shared by all instances | `Register::instance_count` |
| F10 | Legal `$cast` base handle → derived handle | `class_tb.sv` |

## How to run

```sh
vivado2025
cd class_tb/scripts
source run_xsim.csh
```

Expected final line:

```text
PASS: class construct demo complete
```

## See also

Related constructs from the guide: `extends`, `extern`, `new`, `super`, `static`,
`virtual`, `local`, `protected`, `rand`, `constraint`.
