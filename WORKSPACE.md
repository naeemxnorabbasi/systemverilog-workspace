# Workspace recovery manifest

**Purpose:** Recreate the local `system_verilog/` tree after disk loss or new machine.

## Pinned versions (2026-08-30)

| Component | Pin | Notes |
|-----------|-----|-------|
| **svfront** | branch `feat/h1-native-primary-nk-tb` | submodule `systemverilog-parser` |
| **OpenTitan** | `c4aef8bde8a71e151ca76ab22f31a0974030f30f` | `third_party/opentitan` submodule |
| **uvm_examples** | in-tree | 12 benches; stock U4 filelists |

## One-command clone

```bash
git clone --recursive https://github.com/naeemxnorabbasi/systemverilog-workspace.git
cd systemverilog-workspace
git -C svfront checkout feat/h1-native-primary-nk-tb
```

## What is **in** git

- `svfront/` — parser, kernel, tests, docs, charters (submodule)
- `uvm_examples/` — add_tb, dff_tb, mul_tb, tlm_analysis_fifo_tb, …
- `third_party/opentitan/` — submodule pointer
- `docs/workspace/` — workspace-level notes
- `.superpowers/sdd/` briefs inside svfront (not session diffs)

## What is **not** in git (regenerate)

| Path | Recovery |
|------|----------|
| `svfront/build/` | `cmake` + `ninja` |
| `svfront/external/` (~4.5 GB) | `./bootstrap.sh` or `svfront/tools/foss/bootstrap_foss_tools.sh` |
| `svfront/dump.vcd` | sim artifact — ignore |
| `test_case_ref_prep/` | Licensed PDFs — keep separate backup |
| `*.wdb`, `xsim.dir/` | commercial sim artifacts |

## Gate commands

```bash
cd svfront/build
unset LD_LIBRARY_PATH

# Cheap subset (~35 min)
ctest -R '^(at_u4_[123]_(1|2)_|at_u3_1_|at_uvm_strict)' --timeout 600 --output-on-failure

# Full funded core (~55 min; excludes U4.4 until signed)
ctest -R '^(at_u4_[123]_|at_u3_1_|at_u2_1_|at_nk_h5_|at_uvm_strict)' --timeout 600 --output-on-failure
```

## Active program state (2026-08-30)

- **Heals:** 16 active / 25 retired
- **HEAD:** see `git -C svfront log -1`
- **Strict wired:** A6, A7, B1–B5, C5, C8, D3 (C7 retired organic)
- **Signed examples:** add_tb, dff_tb, mul_tb (U4.1–U4.3)
