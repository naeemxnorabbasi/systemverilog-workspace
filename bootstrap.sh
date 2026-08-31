#!/usr/bin/env bash
# Workspace bootstrap: verify layout + optional FOSS tool build.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SVFRONT="${ROOT}/svfront"

die() { echo "bootstrap: $*" >&2; exit 1; }

[[ -d "${SVFRONT}" ]] || die "missing svfront/ — run: git submodule update --init --recursive"
[[ -d "${ROOT}/uvm_examples/add_tb" ]] || die "missing uvm_examples/ — full clone required"
[[ -f "${SVFRONT}/CMakeLists.txt" ]] || die "svfront/ does not look like systemverilog-parser"

echo "== Workspace layout OK"
echo "   svfront:      ${SVFRONT}"
echo "   uvm_examples: ${ROOT}/uvm_examples"
if [[ -d "${ROOT}/third_party/opentitan/.git" ]]; then
  echo "   opentitan:    $(git -C "${ROOT}/third_party/opentitan" rev-parse --short HEAD)"
fi

if [[ -x "${SVFRONT}/tools/foss/bootstrap_foss_tools.sh" ]]; then
  echo "== FOSS bootstrap (svfront/external/foss/prefix) — may take a long time"
  "${SVFRONT}/tools/foss/bootstrap_foss_tools.sh" "$@"
  echo "== source svfront/tools/foss/env.sh before cmake if Z3/Surelog needed"
else
  echo "== skip FOSS bootstrap (script not found)"
fi

echo "== Build svfront"
mkdir -p "${SVFRONT}/build"
cmake -S "${SVFRONT}" -B "${SVFRONT}/build" -DCMAKE_BUILD_TYPE=Release
cmake --build "${SVFRONT}/build" -j"$(nproc)"

echo "== Done. Run gates from ${SVFRONT}/build (see WORKSPACE.md)"
