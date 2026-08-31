# SVFront Current State for Local Models

**Canonical copy:** [svfront/docs/status/current_state_for_local_models.md](../../svfront/docs/status/current_state_for_local_models.md)

Also read:

- [svfront/docs/status/cost_progress_report.md](../../svfront/docs/status/cost_progress_report.md)
- [svfront/docs/status/project_progress_report.md](../../svfront/docs/status/project_progress_report.md)
- [svfront/CURSOR_GUIDANCE.md](../../svfront/CURSOR_GUIDANCE.md)

## Quick snapshot (2026-07-20)

| Item | Value |
|------|-------|
| CTest | 933/933 |
| RTL-VS | 703/703 — **no RTL-VS-704** |
| CAP-GAP shipped | 001–314 (Phase 4 synthesis RTL classification complete) |
| Strongest flow | preprocess → parse → elaborate → IR + `driver_summary` + `rtl_classification` |
| Biggest blocker | **semantic diagnostics depth** / clock sensitivity AST |
| Next work | Phase 5 (≤10 gaps) — not broad sweeps |

Governance docs refreshed 2026-07-20 after Phase 4 (CAP-GAP-305–314).
