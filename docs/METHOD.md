# Method: how the pipeline works, stage by stage, and how to re-run it

This describes what each stage does, which script does it, what it reads and writes, and why it exists. For what we tried and abandoned see `HISTORY_DEAD_ENDS_AND_LESSONS.md`; for results see `ASSURANCE_STATEMENT.md` and `ERRORS_FOUND.md`; for the error dataset see `../data/errors/README.md`. All counts quoted anywhere in these documents come from the data tables by script.

Layout: scripts live in `docs/plan/tools/{mine,verify}` and `docs/plan/lib/code-mined/pilot`; data in `data/` (status tables, per-round results, proving results, audit samples, the error dataset). Working data too big for git lives in `C:\ParanoidBSD\mined-data` (= `/mnt/c/ParanoidBSD/mined-data` in WSL) and in WSL `~/kb`. Rules that apply everywhere: shell, awk, jq and C++ only (no Python in shipped tooling); nothing important only in `/tmp` or `/run`; every long run is resumable and has a STOP file and a budget cap; secrets are never printed or committed.

## Stage 0. The corpus

Linux (`pbsd-ref/linux`), FreeBSD/HardenedBSD (`hbsd/`, `pbsd/`) and KDE (`kde/`). Source files are cut into chunks (a "slice" is a line range of one file, key = `tier:path:start-end`); each chunk holds the functions that start in it. A function is addressed by `(key, i)` = chunk key plus its index in the chunk's list. Tier B and tier C are the two mining tiers (181,335 and 954,258 functions by the status table; see the history document for how they were chosen). The status table has one row per `(key, i)`: 1,135,593 rows.

## Stage 1. Mining the annotations (`docs/plan/tools/mine`)

`mine_all.sh <tiers> <budget-usd>` sends every chunk to GLM-5.3-Flash on the Morph API in batches of 400, resumable, with a spend cap and back-off, and writes shards of JSON (`docs/plan/lib/code-mined/shards/tierX-NNNN.jsonl.gz`). For each function the model returns: a one-line summary, a kind (driver-glue, state-machine, arith-helper, ...), a prose contract (precondition and postcondition in English), a formal ACSL contract where the function is scalar enough, loop notes, ownership notes and an error-convention note. `mine_retry.sh` re-runs failed chunks with a bigger token budget. Why this model: chosen for cost and measured in the pilot; see the history document.

## Stage 2. Verification of the annotations (`docs/plan/tools/verify`)

Follows `docs/plan/lib/code-mined/VERIFICATION_PLAN.md`; results in `VERIFICATION_REPORT.md`.

| Step | Script | What it checks | Why |
|---|---|---|---|
| 1 mechanical | `run_verify12.sh`, `verify12.awk` | function name appears in its slice; `result` not used on a void function; contract names exist in the file; error codes in the prose appear in the formal contract; has `requires`/`ensures`; no `ensures true`; the name is a real C/C++ name | cheap, catches the most common model mistakes |
| 2a grammar | `verify12.awk` | contract fits a stub grammar (single-line ACSL, clauses start with requires/ensures/assigns, balanced brackets, no prose between operands) | prose smuggled into a contract is the most common failure |
| 2b Frama-C parse | `run_frama.sh`, `frama_gen.awk`, `frama_one.sh` | each contract is parsed and type-checked by Frama-C's ACSL front end, one tiny C file per contract so one crash cannot hide other verdicts | the authoritative syntax and type check |
| 3 random testing | `s3/` | for pure integer helpers: the contract is translated to C with exact 128-bit semantics and run on 200,000 random and edge-value inputs | finds contracts that are false for ordinary inputs |
| 4 cross-check | `step4_all.sh`, `step4_chunk.sh` | a second model (DeepSeek V4.1 Flash on Morph) reads code and annotation and answers AGREE or DISAGREE with a reason | catches wrong prose that is grammatically fine |
| 5 tiebreak | `tb_build.sh` | random DISAGREEs judged by reading the source | measures how often the cross-check is itself wrong |
| 6 tags | `tag_all.sh` | one tag per function: verified, rejected, unchecked | "verified" means no check failed and at least one passed; **it is not proved** |

## Stage 3. Repair rounds (`docs/plan/tools/verify/repair`)

`round_run.sh <round> <repair-budget> <review-budget>` runs one round: build the todo list of rejected functions (`build_todo.sh`, `repair_build.sh`), repair with the model (`repair_all.sh`, `repair_chunk.sh`, GLM-5.3-Flash), re-verify steps 1 to 3 plus Frama-C (`repair_verify.sh`), then review with DeepSeek, then `state.sh` rebuilds the status table. Later rounds used DeepSeek V4.1 Flash for the repair itself (`dsv_all.sh`, `dsv_build.sh`, `dsv_chunk.sh`, `dsv_finish.sh`) and the Claude API (Haiku reviewer, Sonnet and Opus repair; `cl_*.sh`) for a measured test, which was stopped when credit ran out. `state.sh` is the single place the per-function status is computed: kept-verified, kept-unchecked, fixed-agree, fixed-disagree, fixed-unreviewed, still-rejected, dropped, rejected-unrepaired. `tag_final.sh` turns it into the final tags (`docs/plan/lib/code-mined/final-tags`).

## Stage 4. The manual queue and hand-fix waves

`export_manual.sh` writes the functions that still fail into packets of about 40 (`mined-data/manual/packets`, not committed: they contain source slices). Agents read the real source for each function and write one result line per function (`{key,i,name,action fix|drop,prose,contract,note}`) following `docs/plan/lib/code-mined/manual/HAND_METHOD.md` (list every return and goto, ban unqualified always/never, reviewer claims are leads, contracts only for pure int/bool/enum functions, never drop a real large function, real source line numbers in notes). `check_wave.sh` verifies a packet's result file covers exactly its functions; `ingest_wave.sh` / `ingest_manual.sh` re-verify the results (steps 1 to 3 plus Frama-C), run the DeepSeek review and update the state table. Waves 1 to 3 covered packets P0001 to P0212 (rounds 18 to 20).

## Stage 5. Machine proving of the core tier (`docs/plan/lib/code-mined/pilot`)

The core tier is 24,825 verified small functions of core kinds (arithmetic helpers, bitmasks, bitmaps, allocators, parsers, error paths, init/teardown, lists, locks, rings, refcounts) with a formal contract. `prove_core.sh` runs them in chunks of 1,000 with milestones and snapshots:

1. `mkunit2.sh`: build the verification unit from the real preprocessed translation unit of the source file (Linux: kbuild per-TU flags from a configured tree; BSD: flags reconstructed by `tu_bsd.sh`; extra architectures by `build_kernel_cfg.sh`). `guard_annot.sh` accepts a model-annotated function only if it is the same C code plus annotations.
2. `prove_unit2.sh`: Frama-C WP (Why3 with Alt-Ergo, Z3, CVC5), A = contract goals, B = plus run-time-error guards, plus a vacuity check (`assert \false` at entry must not be provable, so a contract that is contradictory cannot be "proved").
3. `bv_unit.sh`, `rebv.sh`: for contracts WP cannot close, CBMC bit-precise SAT, with pointer and loop handling in the later rounds. This is what produces concrete counterexamples for the FALSE label.
4. `prism_check.sh`: a second independent engine (PRISM) on units WP proved.

Labels: PROVED, PROVED-ASSUMING, CONTRACT-ONLY, FALSE, FAILED, UNBUILT, WPERROR, VACUOUS, BOUNDED. Chunk results are snapshotted to `data/proving/core` (summary, labels, repair list, per-unit result archives).

## Stage 6. Post-processing of the proofs (`post_core.sh`)

After the run: `rebv.sh` (second bit-vector pass for every unproved unit), `replay_proved.sh` (independent replay of every proved unit in a fresh directory, WP cache off, banned constructs scanned, contract text compared), `mutate_proved.sh` (mutation test: break the C code in one place, the proof must fail: eq/lt/gt/and/add/band/shl/ret mutants), contract strength, and the 400-function audit sample (statement vs contract vs code). These phases are resumable; each skips finished units. They were interrupted on 13 November 2026 when C: ran out of space (rebv writes about 30 GB of rebuilt units to WSL) and are rerun after the disk compaction.

## Stage 7. Random-sample audits (`tools/audit_sample.sh`, `data/audit`)

Seeded, stratified (code base x status) samples: 20,000 of the verified population, 10,000 of the unchecked, all 9,001 of the hand-fixed, plus the proved set. The sample lists are committed so a draw can be repeated. An independent reader (Haiku) checks each; a calibration sub-sample read by agents measures the reader's own error so that the reported error rates can be corrected for it.

## Stage 8. Reports and the error dataset

`tools/gen_errors_report.sh` writes `docs/ERRORS_FOUND.md`; `tools/build_error_dataset.sh` writes `data/errors/`; `tools/stage_data.sh` and `tools/stage_units.sh` copy the working data into `data/` (with a secret scan and no third-party source). `tools/compact_wsl_disk.ps1` returns free space inside the WSL disk file to Windows (elevated).

## Re-running

1. Mining and verification: `docs/plan/tools/mine/start_mining.cmd`, then `run_verify12.sh`, `run_frama.sh`, step 3 and 4 scripts, `tag_all.sh`.
2. Repair: `start_round.cmd` per round (`round_run.sh`), then `state.sh`, `tag_final.sh`, `export_manual.sh`.
3. Hand-fix: give the packets to readers following `HAND_METHOD.md`, then `ingest_wave.sh <wave> <first> <last>`.
4. Proving: `docs/plan/lib/code-mined/pilot/start_core.cmd` (watcher, resumable; `CORE_START` skips finished chunks), `post_core.sh` for the follow-up phases.
5. Reports: `tools/gen_errors_report.sh`, `tools/audit_sample.sh`, `tools/build_error_dataset.sh`.

Toolchain pinned in the repo: Frama-C 33 with WP, Why3, Alt-Ergo, Z3, CVC5, CBMC, gawk, jq, GNU make and the kernel build chain (see `install_framac_wp.sh`, `build_tools.sh`). The first verification run (11 November) used Frama-C 25.0 for the parse check.
