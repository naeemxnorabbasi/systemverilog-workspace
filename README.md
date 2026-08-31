# SystemVerilog workspace (monorepo)

Single clone to recover the full local development layout for **svfront** + stock UVM examples + pinned third-party checkouts.

## Layout

```
systemverilog-workspace/     ← this repo (git root)
├── README.md                ← you are here
├── WORKSPACE.md             ← recovery checklist + pinned versions
├── bootstrap.sh             ← FOSS tools + verify layout
├── svfront/                 ← submodule → systemverilog-parser
├── uvm_examples/            ← stock Accellera example benches (U4 gates)
└── third_party/
    └── opentitan/           ← submodule @ pinned commit (OT pilot)
```

Stock U4 tests resolve examples as `svfront/../uvm_examples/<bench>` — **do not** nest `uvm_examples` inside `svfront/`.

## Quick start

```bash
git clone --recursive https://github.com/naeemxnorabbasi/systemverilog-workspace.git
cd systemverilog-workspace
git submodule update --init --recursive

cd svfront
git checkout feat/h1-native-primary-nk-tb   # if submodule detached

mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
unset LD_LIBRARY_PATH
cmake --build . -j$(nproc)

# Subset gate (~35 min)
ctest -R '^(at_u4_[123]_(1|2)_|at_u3_1_|at_uvm_strict)' --timeout 600 --output-on-failure
```

Optional FOSS bootstrap (Verilator, Surelog, Z3, … — ~4 GB under `svfront/external/`):

```bash
./bootstrap.sh
```

## Program docs (in svfront)

| Doc | Purpose |
|-----|---------|
| `svfront/docs/superpowers/plans/2026-08-30-general-lrm-sim-roadmap-2034.md` | Waves 1–9 to 2034 |
| `svfront/docs/status/uvm_kernel_heal_inventory.md` | Living heal tracker |
| `svfront/docs/superpowers/plans/2026-08-26-uvm-zero-heal-master.md` | Wave 1 immediate work |
| `svfront/.superpowers/sdd/` | Agent task briefs + progress |

## Honesty

`accellera_uvm_no_dpi_zero_heal_mvp_not_full_uvm_examples` — not commercial LRM parity.
