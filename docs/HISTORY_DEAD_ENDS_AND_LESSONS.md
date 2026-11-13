# History, dead ends and lessons: code-mined annotation verification and proving (5-13 Nov 2026)

Written for the project owner (Odin Loch) and for a future reader or buyer. It is a factual record of what was done, why, what failed, what went wrong operationally, and what to do differently.

## How to read this document

- **Sources.** Claude Code session transcripts (main session 39bb1365..., 16,936 lines; an earlier session e6f0275e... from 5-7 Nov), the git history of this repository, the memory notes, `docs/plan/LESSONS.md` of the ParanoidBSD repo, the repo docs (VERIFICATION_PLAN/REPORT, SELLABLE_PLAN, HAND_METHOD, ASSURANCE_STATEMENT, ERRORS_FOUND, MILESTONES, summary.md, PILOT_REPORT), `data/status/*.json`, and logs under `C:\ParanoidBSD\mined-data`.
- **Time zone.** Commit dates and mined-data logs are local time (AEDT, UTC+11). Transcript timestamps are UTC; they were converted to local here. A few times are approximate.
- **Number provenance.** Every figure carries a pointer to its source in brackets or a plain statement. Figures I could not tie to a file or transcript line are marked **unverified**. Costs are the miner/ledger "upper bound" at list price (they ignore cache discounts), not the provider's invoice; the real Morph and Anthropic charges were never read (Morph has no balance endpoint: nine paths returned 404, per the session summary).
- **Counts change as rounds finish.** README.md quotes 520,731 "verified"; the final table (data/status/final-summary.json) says 527,395. The final table wins.
- No keys, tokens or third-party source code are reproduced here.

---

## (a) Original goal and product intent

**What.** Odin is building ParanoidBSD (PBSD): a hardened OS distro on HardenedBSD 15-STABLE with its own languages and toolchain (ForgeScript/FORGE, FUSE, PRISM, MathScript and others; source: the 4-5 Nov audit prompt in the early session). The early work (5-7 Nov) was a large agent pipeline ("the tester": a C++23 runner `pbsd_run`, gates, PRISM for proofs, FORGE for inference, GLM-5.3-Flash via Morph) that was supposed to build and Lean-prove PBSD components (12,976 tasks; tiers T0-T4; source: session summary, LESSONS.md).

**Pivot to mined data (7 Nov).** After rehearsals produced proofs, helper lemmas and errors, Odin asked to "cache proofs and make a proof library and templates and then just re-ingest them ... Lets make a lean dsl" (user, 7 Nov 19:30), then "I'm looking to datamine and cache those common patterns" and "Why so few loc? I thought we would mine the whole thing". The code miner was extended from 1,081 planned files to the whole Linux, HardenedBSD, PBSD and KDE corpus.

**Product intent (11-12 Nov).** Once the annotations existed, the aim hardened into a product: "We will keep verifying until everything's correctly proved and ready for the DoD ... Im proving this to sell. It needs to be of the highest quality" (user, 11 Nov). A sellable-level plan (`SELLABLE_PLAN.md`, 12 Nov) fixed the labelling rule: PROVED, PROVED-ASSUMING, BOUNDED, TESTED, REVIEWED, REJECTED/UNCHECKED, never merged, and "verified" never means proved. Customer: the US Department of Defense and its contractors. On 12 Nov Odin also said "I want the whole thing proved. Give me an estimate."; on 13 Nov: "So I wanted to prove all million functions." The honest answer given (13 Nov) was that proving all 1.1 million in the strong sense is not achievable; see (j) and `docs/ASSURANCE_STATEMENT.md`.

**Outcome.** A labelled corpus of 1,135,593 functions with a machine-checked-proof subset (5,855 of 24,806 attempted, 23.6%) and a much larger reviewed-but-not-proved set. Not a verified operating system.

**Lesson.** The goal moved three times in a week (build the OS with proofs -> proof library -> annotate everything -> prove for sale). Each move re-used work, but the "whole thing proved" aim was stated after the annotations were already in a form (prose, mostly no formal contract) that cannot reach it. Decide the sale-grade claim first, then design the annotation format around it.

### Early-phase decisions that shaped the later work (5-7 Nov)
- No fine-tuning (user, 6-7 Nov: "We are not fine tuning. No point."). FORGE has no training path anyway (LESSONS.md D24).
- Goedel-Prover-V2-8B dropped for good on 7 Nov (see (i)).
- GPU burst VM not needed; GCP burst worker (project hbsd-513913) blocked because a physical card was needed for the billing account (user, 6 Nov: "I need a physical card to make a billing account").
- Morph credit was paid by hand and was about $5 on 7 Nov; a bank outage blocked a top-up that evening (user messages "My card is having trouble going through", "Banks doing Maintenance").
- Rule zero (7 Nov): work was lost four times in two days (final Spec/Model of the passing P0-02 run, a rehearsal's state, profiling output, the first Goedel smoke test) because it sat in /tmp or /run. User: "No more losing work. Add that to the mistakes." Saved in LESSONS.md section 0 and memory.

---

## (b) Mining the annotations

**What.** A shell/awk/jq miner (`docs/plan/tools/mine/`) chunks C/C++ files (about 200 lines per chunk on average), sends each chunk to GLM-5.3-Flash on Morph, and appends one JSON line per chunk: per function a one-line summary, a prose contract, an ACSL-style contract (only for scalar functions), loop shapes with informal invariants, and sync/ownership/error hints. Results go to `C:\ParanoidBSD\mined-data` with a ledger, progress file, error log and failed list; gzip shards (4,000 results each, 72 shards: 9 for tier B, 63 for tier C) are committed to git.

**Why this model.** GLM-5.3-Flash was already the tester's workhorse and was the cheap option: Morph list price $0.047 input / $0.268 output per 1M tokens (session summary). First 8-chunk test cost under one cent (18k tokens in, 6.9k out; transcript 7 Nov).

**Numbers (sourced).**
- Phase 1 (7 Nov, 800 random chunks of the planned files): US$0.33 for 796 valid chunks, $0.00041 per chunk, 5,336 functions, 578 with a contract candidate (transcript). The 4 corrupted lines were redone; `phase1.raw-with-corrupt-lines.jsonl` is kept in the repo.
- Whole-corpus run: started 8 Nov 09:01, finished 8 Nov 22:40 (`mined-data/miner.log`: "tier C complete / MINE-ALL-DONE"). 284,637 chunks (34,615 tier B + 250,022 tier C). Ledger spend at the end: US$91.78 (upper bound; Odin had $73 of credit, so the real charge was lower, exact figure unverified). Rate rose from about 100-150/min at 24-28 parallel to 300-400/min at 64 parallel. Zero restarts at the 13:21 check.
- 214 chunks failed (`failed.txt` has 214 lines). Cause: the model returned `content: null` with its reasoning consuming the token budget (errors.log shows `reasoning_content` and no content). The verification stage later re-tried them with a bigger budget: 203 recovered, 11 are test vectors or data files with no functions (VERIFICATION_REPORT).
- Yield: about 39% of tier C chunks had no functions (headers, tables, data). Per record about 4 functions; of 3,490 functions in a 900-record sample, 96% had a prose contract but only 11% a formal ACSL contract (VERIFICATION_PLAN section 1). Estimated annotation quality "about 6.5/10" (same source; the plan's own spot-check estimate).

**What went wrong.**
- **Corpus size estimate was wrong.** First estimate: about 190,000 chunks, about $78. Real chunk list: 284,637 chunks (the chunker averaged 200 lines, not 300, and many small files each became a chunk). The assistant said so itself (7 Nov / 8 Nov).
- **First phase was self-limited** to 1,081 files, top-level Linux directories only, `.c` only, `-maxdepth 1`, 800 chunks. Odin noticed ("Why so few loc?").
- **Parallel appends over 4 KB corrupted 4 of 800 lines** (appends over PIPE_BUF are not atomic). Fix: file lock (`flock`).
- **Three scaling bugs** found before the big run: resume check scanned the whole output file per chunk, spend counter re-read all data per batch, and a failed or truncated reply was dropped without a record. Fixed (ledger file, one retry with more room, failure log).
- **Sync window never started** for the first hour because the launcher's nested quotes broke (commit 4d6cad0 "fix the sync window launcher"). Data was safe on disk; git commits just lagged.
- **Duplicates** from three restarts: 324 duplicate chunks in tier B (dedup at aggregation).
- Odin stopped mining overnight on 7 Nov ("We will do it tomorrow") and ran it on 8 Nov with "Just use the whole lot. Im not worried about budget, so get rid of that" (the $60 cap was removed; session summary).

**Lesson.** Measure the real chunk list before quoting cost. Reasoning models eat max_tokens: empty replies are billed and common. Appends above 4 KB need a lock. Always run the data-sync loop under its own supervisor and verify it produced commits.

---

## (c) Verification design (steps 1 to 6)

Plan: `VERIFICATION_PLAN.md` (6 and 8 Nov), results: `VERIFICATION_REPORT.md` (run 11 Nov). Tools: shell, awk, jq, C++ only ("no Python in shipped tooling", an Odin constraint). Order is cheapest first; a record that fails an earlier step is not sent to a later one.

| Step | Why | What actually happened |
|---|---|---|
| 1 mechanical (name in slice, `result` on void, contract identifiers exist in the file, prose error codes in the formal `ensures`, no `requires`/`ensures`, `ensures true`) | Free, all 1,135,593 functions | 55,307 fail (4.9%); 43,516 of the 149,268 with a formal contract (29%). Top reason: names that do not exist in the file (26,311). Bug found: C++ method names (`File::flush`, `SYSCALL_DEFINE0(getpid)`) were wrongly failed -> accepted when the last component is in the slice; `BPF_PROG(sub` crashed a regex built from the name. |
| 2a stub grammar | Cheap pre-filter | 23,105 of 149,268 fail (15%); 21,000 are prose inside the ACSL block. |
| 2b Frama-C ACSL parse and type check | Authoritative front end | 145,743 contracts: 78,819 pass, 45,801 fail (parse), 20,260 type errors, 863 unknown. Frama-C rejected 98% of what the stub grammar rejected plus about 22,000 more (C function calls in ACSL, lowercase `null`, `old(x)` without backslash, 1,875 operator-precedence bugs). Frama-C here is the apt `frama-c-base` 25.0 (the user hit "E: Unable to locate package frama-c" at first). |
| 3 random testing (own `contract2c` ACSL-integer-subset to C in `__int128`, 200,000 random and edge inputs) | Plan wanted libFuzzer/E-ACSL | Only 2,312 of 31,367 candidates testable: 1,586 pass, 695 counterexamples (257 wrong for ordinary inputs e.g. a constant in the wrong byte order; 436 only at integer limits), 17 trap. |
| 4 cross-check by a second model: DeepSeek V4.1 Flash 1017 (`morph-dsv41flash-1017`, $0.12/$0.80 per 1M) | Different family from the GLM generator, so independent | Run on 132,513 eligible records (the plan estimated about 58k). Stopped by Odin at 1,458 records (3,399 agree, 1,545 disagree = 31%), then resumed; completed with 132,951 records (commit 7058cd2). |
| tiebreak (plan: Claude Sonnet) | Resolve disagreements | No Anthropic key then; Odin asked for it "in this session". 60 random DISAGREEs judged by three in-session subagents: 43 upheld, 16 overturned, 1 unclear; 12 of the 16 overturns were "weaker than the prose but true", which the plan counts as a defect, so DeepSeek was right in about 55 of 60 under the plan's definition. |
| 6 (step 5 does not exist) tag every function | Keep originals untouched | `tags/` and later `tag_final.sh`; step numbering skips 5 in the plan (the assistant flagged it on 11 Nov). |

**Results after step 4 (commit 7058cd2):** verified 415,923 / rejected 173,356 (15.3% of 1,135,593) / unchecked 546,314. "Verified" is weak: in the 11 Nov report about 60,000 of the early "verified" rested only on syntax.

**Choices and why.**
- Frama-C used per contract, each in its own stub file: in a batch file one crash or bad stub hid every later verdict (LESSONS K2). A pass rate that looked too good (0.2% failing next to our own 15%) exposed it.
- E-ACSL plus libFuzzer abandoned (shadow memory vs thread-local storage; then hand-built E-ACSL had a malloc/free mismatch with GMP; apt package lacks `e-acsl-gcc.sh`).
- DeepSeek `reasoning_effort`: first run showed no cost change; later test on 40 records: `low` 29% cheaper than the default with the same verdicts within noise; `minimal` cost the same as `low` but turned 19 of the default's DISAGREEs into AGREE (lenient). Adopted `low` (commit d3ad236).
- Cost: about $0.0018 per record measured (95% of output is hidden reasoning), later $0.0016-0.0023; step 4 total about $236 (SELLABLE_PLAN section 5: about $263 of $295 spent, DeepSeek $236, GLM repair $28).
- Odin's mid-course reversals: stopped step 4 on 11 Nov ("Stop the deepseek run.", 15:51), then "Dont actually. Continue it ... Fix all the broken ones too", then "You fucking finish the deepseek run ... Fix the whole 81k please" (16:10). The caps changed with the credit: $60 -> $260 -> (with only $100 credit) $75 -> (after "I now have 295 USD of credit") $260.

**Lessons.** Give every judge the same definition of a defect (LESSONS K6: reviewer and checker rules differed). "Weaker than the prose" must be decided up front. A same-family reviewer is not independent (see (d)).

---

## (d) Repair rounds 1 to 20

### Rounds 1-2: machine repair with GLM, review with DeepSeek

**What.** For every rejected function (81,651 functions, 41,068 records) GLM-5.3-Flash was given the code plus the exact reasons it was rejected and asked for a repaired annotation (fix or drop). Repairs were re-verified through steps 1-3 and Frama-C, then reviewed again by DeepSeek.

**Numbers.**
- Round 1 repair: 80,960 functions re-verified: fixed 67,865, still-rejected 6,316, dropped 6,779 (commit 7f955bf). Cost about $0.0004/record. A first 610-function sample showed 593 passing, but for 435 of 594 that had a formal contract the repair had deleted it (pointer functions), so repaired records mostly cannot be tested.
- Round 1 review (DeepSeek) of 33,377 of 33,566 records: $49 (`data/status/spend-baseline.txt` 49.17), 44,912 functions agree (68%), 21,058 disagree (32%).
- Round 2 repair (GLM, effort raised): 31,856 records, $18.03 of a $32 cap (commit 38942c9); 56,178 functions re-verified: 50,934 fixed, 4,201 still rejected, 1,043 dropped. Review: DeepSeek agreed on 37,988 of 55,983 (67.9%), disagreed on 9,133, 3,626 never reviewed because the review cap ran out. Job total $78.40 of a $90 cap. Final tags after round 2: verified 498,825 / unchecked 551,360 / rejected 77,588 / dropped 7,820.

**Decision.** Odin (12 Nov ~15:00): "Instead of just feeding the data through and through, if its already been through a few times you do it. Just get it done." Rounds 3 and 4 of GLM repair were cancelled; the survivors went to a manual queue (772 packets of about 40 functions at first) fixed by Claude agents reading the source.

**Lesson.** Machine repair removes the formal contract rather than fixing it (reasoning cheaper than correctness). After two passes the remaining items needed a reader of the real source.

### Rounds 3-14: hand-fix pilot and redo rounds (about 40 functions each)
Round logs (`mined-data/repairN/round.log`) show rounds 3-11 as tiny rounds of 39-41 functions (12 Nov 19:28 to 23:02), round 12 with 93 functions (done 13 Nov 00:29), round 13 with 41 (01:18), round 14 with 25 (03:29). They ingested packet results from the hand-fix pilot (commits 0ea595e, ad91ccf, 2908245, 134b00b, 33b8f30 for P0001-P0008 and P0080) and the re-do passes (redo-A/B: 93 functions, 64 reviewer disagreements plus 29 unreviewed, commit 7eba8a1; redo-C: 25 functions, commit 93bfd91; redo-D: 19 functions, commit 9730a1f). The exact mapping of packet ids to rounds 3-11 is not recorded in a single table and is **unverified**.

**Findings from the pilot.** All 322 functions of P0001-P0008 passed the mechanical and Frama-C checks, but the reviewer agreed on only 229, disagreed on 64, and 29 reviews failed; 70 of 322 carried "name outside slice". On redo, of the 64 disagreements: 37 were real prose mistakes, 6 partly right, 21 reviewer errors (transcript 12 Nov). Hand pass on 93 functions: real prose errors in 43 of 64 reviewer-disagreed and in 8 of 29 unreviewed, none of which the mechanical or Frama-C checks caught (HAND_METHOD.md "Why this method").

### Round 15: DeepSeek on the manual queue
- Odin: "Pick between Deepseek 4.1 or Kimi", then "I think Deepseek and then You claude. Get it done as quick as possible." (12 Nov ~19:55-20:04 local).
- Why DeepSeek: measured on this exact job and its failure modes known; Kimi K3 not run on this data. Kimi K3 for all 772 packets was estimated at about $550 at $3/$15 per 1M (from third-party price pages; unverified) against about $190 of credit. A reviewer or fixer that changes mid-project also makes counts incomparable.
- Result (round 15, 13 Nov 08:18): 21,573 of 21,580 records attempted (38 empty three times). Fixed and reviewer agrees 21,446; fixed but disagrees 4,949; review call failed 2,031; still rejected 1,160; dropped 1,641 (transcript). Dropped fell from 7,746 to 1,646 overall: most "not a function" verdicts of earlier rounds were real functions (macro-generated or head-cut).
- Cost: repair $61.13 against a $55 cap (raised to $66), review $44.35 against $25 then $40; total about $105.5 against the $80 Odin set ("Make the cap 80", 12 Nov 20:40). Caps were lifted at Odin's request ("Just increase the cap.") and the overrun was reported to him.
- Weakness stated by the assistant: the same DeepSeek model did both repair and review, so "agree" is a gate, not independent proof.

### The Anthropic API attempt (Haiku / Sonnet / Opus) and why it was dropped
- **Why.** Odin: "We can use the claude API to get these models done. I have $200 there." (12 Nov 23:11). A Batches/Messages runner (`cl_*.sh`, commit a8cc466) was built by an agent. Key was kept in `~/.pbsd/env`, never printed.
- **Prices used** (cached skill table, 3 Nov): Haiku 5.5 $0.10/$0.50, Sonnet 5.5 $2/$10, Opus 5.5 $4/$20 per 1M; batch assumed 50% off (unconfirmed).
- **Quality tests (about $5 spent against a $3 test cap).** P0080 (40 functions): after a prompt fix, Sonnet fixed 39/40, Opus 40/40, hand-fixed reference 39/40; first runs dropped fragment slices (12/40 Sonnet, 11/40 Opus) because the prompt never showed the enclosing function; full-source limit raised from 14,000 to 60,000 characters. These are mechanical+Frama-C pass rates, not proof the prose is right. Reviewer test on 100 records (50 good, 50 deliberately wrong): Haiku accepted 46/50 good and caught 48/50 wrong at $0.0006 per record; Sonnet accepted 34/50 and caught 50/50 at $0.009. Haiku chosen as reviewer because Sonnet was too strict. A 300-record Sonnet batch: 320 fixed, 12 still rejected, 8 dropped, $0.011 per record.
- **Plan:** `sonnet-tail` on the last ~5,000 records of DeepSeek's queue, Opus on repeated failures, Haiku reviewing DeepSeek's fixes (independent family).
- **End.** "credit balance is too low" at 13 Nov 01:01; ledger spend $28.62 at list price. `claude/STOP` set. Paid output parked: 3,318 Sonnet result lines (1,775 records), 29 Opus lines (19 records), 2,360 Haiku verdicts.
- **Odin's decision** (13 Nov 04:49): "Just skip anthropic. We will just use the AI here. Only use it for the hardest of work." The parked results were later ingested at no extra Anthropic cost as round 17 (3,346 results, 206 drops; 1,806 re-verified after removing 1,540 already settled).
- **Why the credit ran out early was never established** in the transcript; the key's account balance was exhausted at $28.62 of ledger spend, far below the $200 Odin expected (billing/plan question, unverified). Odin's plan question (is the $200 monthly credit an extra to Claude Code?) was answered from help pages: separate from interactive Claude Code.
- **Value received** (assistant's tally): about $0.009 per annotation; about $5 went on tests.
- **Later** a quote for a Haiku double-check of everything: 3,961 input / 776 output tokens per review average, $0.00078 per function: about $890 list for all 1,135,593, about $410 for the 527,395 verified, about $7 for the ~8,700 hand-fixed. Not run (no credit; Odin had said skip).
- **Lesson.** Do a small credited test, read the real balance on the console first, and watch the ledger; a runner with a hard cap and a clean stop on credit errors saved the rest of the data. Haiku as a reviewer is not perfect (4 of 50 good fixes rejected).

### Rounds 16-17: redo-D and Claude-result ingest
Round 16 (19 functions, 13 Nov 08:28) re-submitted functions with slice-boundary wording; round 17 (13 Nov 09:26) ingested the parked Claude results with Haiku verdicts applied; status after it: verified 521,729 / unchecked 548,215 / rejected 64,462 / dropped 1,187.

### Rounds 18-20: hand-fix waves (see (e))
Round 18 (wave 1) 2,987 results, $5.77 review; round 19 (wave 2) 2,982 results incl 114 drops, $5.41; round 20 (wave 3) 2,735 results incl 121 drops, $5.25.

### Outcome after round 20 (`data/status/state-summary.json`, ERRORS_FOUND section 2)
For the 173,710 functions that entered repair: fixed and reviewer agrees 111,652; fixed and reviewer disagrees 1,169; fixed and unreviewed 1,202; still rejected 300; dropped 377; never attempted 59,010 (driver glue, no packets). Unchanged: 415,743 kept verified, 546,140 kept unchecked. Final tags: verified 527,395 / unchecked 547,342 / rejected 60,479 / dropped 377. (173,710 vs the 173,356 first-round failures: reason for the 354 difference is **unverified**.)

---

## (e) Hand-fix waves 1 to 3 (Claude agents)

**What.** After round 17 the re-exported manual queue was 8,714 functions in 212 packets: 4,453 reviewer-disagrees, 2,075 unreviewed, 977 still rejected, 1,187 dropped to double-check. Waves: wave 1 = P0001-P0072, wave 2 = P0073-P0144, wave 3 = P0145-P0212; 12 in-session agents per wave, about six packets each, writing only result files (`mined-data/manual/results/r17-<packet>.jsonl`); the coordinator ingested whole waves serially (`ingest_wave.sh`, `check_wave.sh`). Odin: "Do all." (13 Nov ~09:13).

**HAND_METHOD rules (first version, `manual/HAND_METHOD.md`).** Read the real source, not the slice; list every return and goto first; ban unqualified "always/never/every path/nothing else changes/returns 0"; contract field only for pure int/bool/enum functions; real function name (macro head for generated functions); drop only non-functions; reviewer claims are leads, not facts (cite file:line when rejecting one); second pass on yourself; no model API calls for fixing; do not ingest or commit.

**How the method evolved.**
- After the 8-packet pilot: name check changed (opt-in `NAME_WHOLE_FILE=1` in verify12.awk, whole-file whitespace-insensitive match, flagged "name outside slice"; default output byte-identical on 20,000 original rows) because many slices cut off the head (33 of 80 in P0003/P0004; earlier rounds had guessed names like `afs_rotate` for `afs_select_fileserver`) and macro-generated functions need a macro-head naming convention.
- Wave 2: agents had to keep a running tally of reviewer claims (right/wrong/mixed) and re-read every prose against the source after each packet; scratch files in their own folders.
- Wave 3 additions: never drop real large functions (mark "partly read"), use real source line numbers in notes, write each packet before the next, run `check_wave.sh` until OK.

**Quality problems found.**
- **Agents ran out of context.** Examples: P0094-P0096 not done, P0084 partial (17 then 23 of 40 saved), P0154-P0156 never started (the agent that finished P0151-P0153 ran out); catch-up agents were launched. Agents also reported that sub-agents were refused.
- **Unread real functions dropped.** Some "drops" were large real functions the agent had not read (e.g. P0123 `dt_node_op2`, `dt_cook_op2`; P0126's nine). Fix: regex plus per-wave exclusion list (`exclude-w2.txt`) kept them queued (10 kept out in wave 2). Wave 3 had none flagged.
- **Scratch line numbers** in `note` fields referred to the agents' scratch dumps, not the source.
- **Keyword-sweep second pass.** ERRORS_FOUND section 5: "The agents' second pass was mostly a keyword sweep for unqualified words rather than a full re-read, so these fixes are drafts until independently re-read." Very large functions read only partly (about 150 in wave 3; `altera_execute` about 1,900 lines read at its head only).
- **Reviewer accuracy varied widely by packet:** P0007-P0012 about 86% right (131 right, 22 wrong); P0073-P0078 about 68% (110 right, 28 mixed, 24 wrong); P0139-P0144 about 43% (64 right, 73 wrong, 11 mixed; causes: one reviewer claim pasted onto a whole slice, e.g. 25 of 27 `chrono::operator<<`; round-15 reviewer said all 21 allocator `new` operators "never return NULL" and was wrong for every one).
- **Round-to-round churn:** the earlier DeepSeek "dropped as not a function" verdicts were largely wrong; the hand pass reversed 11 of them in one packet range.

**Real errors found in old prose (examples with source in transcripts):** `setpriority` returns -EACCES not -EPERM; `ZSTD_RowFindBestMatch` returns 3 on no match, not 0; `xfs_file_write_zero_eof` can return 1; `bond_enslave` XDP failure paths do not undo `slave_cnt`; `errno_to_blk_status` wrong mapping; and about 60 possible bugs in the source code itself (ERRORS_FOUND section 6: leads only, none reproduced).

**Lessons.** Hand fixes are drafts until independently re-read. Budget context per agent (6 packets of 40 functions each exceeded it often). Never let an agent drop a function it did not read. Require evidence lines (real file:line). Check completeness mechanically (`check_wave.sh` compares each packet's key set with its result file).

---

## (f) The core proving run

### Pilot (S4, 12 Nov; PILOT_REPORT.md)
- **Candidate pool:** 24,825 functions tagged verified, in 12 core kinds (arith, bit, bitmap, allocator, refcount, ring-buffer, list, lock, parser, error-path, init-teardown, other), with a formal contract; extrapolated "about 32,000" in the first estimate.
- **Three routes tried on 200 functions (sample A) plus 60 loop-bearing (sample B):** Frama-C WP on the mined ACSL; GLM-written loop invariants/asserts then WP; GLM-written Lean models; PRISM as a second engine. Result: route chosen = Frama-C WP (proves the stated contract, no model tokens, about 10 s per function); 29/200 proved (15 PROVED, 14 PROVED-ASSUMING), all replayed clean; 149 did not build; GLM invariants 0 of 24 functions (72 attempts); GLM Lean 6 of 14 theorems compiled but none acceptable as PROVED (the model is not the C function, or weaker than the contract); PRISM's wp stage never disagreed but added almost nothing (refuses pointer functions). Pilot model spend $0.55 of a $40 cap.
- **Toolchain:** Frama-C 33.0 + WP, Why3 1.8.2, Alt-Ergo 2.6.4, Z3 4.8.12, CVC5 1.1.2 built in a private opam root (about 25 minutes); apt Frama-C has no WP.
- **Build environment fix:** per-translation-unit preprocessing using kbuild flags (configs tried: x86 allyesconfig, x86 defconfig, arm64, arm, riscv, powerpc, mips, s390), `tuslice.cpp` slicer, `tu_bsd.sh` BSD flag reconstruction with empty `opt_*.h` stubs (labelled), a CBMC 5.95 bit-vector path (`acsl2bv.cpp`, `bv-sat-uncertified` label), vacuity check, annotation guard ("exactly one ACSL block equal to the expanded mined contract").
- **After the fix, on two 200-function samples:** A 29 -> 38 (19%), C 25 -> 47 (23.5%). Mutation test: 65% of broken variants caught (84 of 129); 21 of 87 proved units have a mutant that survived; 41 of 87 (47%) proved contracts are range-only (weak).
- **Decision (12 Nov, Odin):** "Can you resolve that?" then the full core run.

### Full run (12 Nov 14:51 start to 13 Nov, `prove-core/run.log`, MILESTONES.md)
- Start P=14 workers; restarted with P=30 on 13 Nov 01:08 (after a memory/CPU review showed idle CPU); 80 workers on 13 Nov ~09:05 after Odin said "Use all the cores. Theres 32" (64 logical CPUs). Memory note says 56 workers is fine "when the enwik8 jobs are off" (time of that setting: unverified).
- Speed history (transcript figures): about 15 units/min with 14 workers when repair jobs shared the machine; about 3 units/min while Odin's enwik8 jobs held about 31 of 64 cores; about 5 units/min from the BSD preprocessing slowdown; after the fix and 80 workers about 30-90 units/min; at chunk 21,000 about 30 minutes per 1,000 units; the last chunk had about 20-minute stragglers.
- **Speed problems and fixes.** (1) `tu_bsd.sh` ran `find` over the whole FreeBSD tree on the Windows share (9p) for each BSD unit: 30+ minutes each under load, four workers held 22-30 minutes. Fix: a cached `.m` index (`build_bsd_index.sh`, 275 `.m` files; `~/kb/bsd_m_index.txt`). (2) Serial `sync_core.sh` -> parallel `xargs -P 32`. (3) Resume: `CORE_START=N` skips the sweep of finished chunks; `prove_core.sh` patched `last=${CORE_START:-0}`. (4) `commit_core.sh` made copy-only after `git push` hung (see (g)).
- **Milestones.** MILESTONES.md snapshots (25%/50%/75%/100% plan). At 7,000 units: PROVED 690 (10%), PROVED-ASSUMING 960 (14%), CONTRACT-ONLY 865 (12%), FALSE 595 (8.5%), FAILED 562 (8%), UNBUILT 3,287 (47%): 1,650 proved = 23.6%. Note: MILESTONES.md repeats the heading "28% (7000 of 24825)" on every snapshot from 13 Nov 00:15 to 04:52 (the label does not update; the assistant also noted a premature "100%" heading, so check the table body, not the heading).
- **Final (summary.md, all 24,825 units built, 24,806 functions):** PROVED 2,388; PROVED-ASSUMING 3,467 (5,855 = 23.6%); CONTRACT-ONLY 2,982; FALSE 2,148; FAILED 1,957; UNBUILT 11,730. Best kinds: bitmask 71%, arith-helper 30%, bitmap 28%; worst: list-op 4%, refcount 10%, allocator 11%, ring-buffer 11%, parser 12%, lock 12%.
- **Why 47% did not build** (top causes): 846 C++ sources, 442 preprocess failures in FreeBSD `contrib/llvm-project`, 378 "unbound logic variable true" annotation errors (a mined-contract bug), 278 `vnode.h` preprocess failures, 267 openssl test tree, 175 bit-field width errors.
- **Assumptions to disclose on proved results:** `bv-sat-uncertified` 911, callees-without-spec 1,066, config 599, header-function-in-probe-unit 965, pointer-or-memory-precondition 642, stub headers assumed empty 369.
- **Post-processing (rebv, replay, mutation, strength, 400-function audit sample)** started after the last chunk; it was halted on 13 Nov ~14:55 because rebv filled C: (see (g)); not finished at the last commit (98b3b6e, 13 Nov).

**Lessons.** The cost of a proof is compute plus build environment, not tokens: SELLABLE_PLAN section 8 had estimated $1,600-$25,000 for 32,000 core functions at tester-task prices; the pilot measured about $0 of model per proved function. The unbuilt share (47%) is the biggest loss and is a toolchain problem. Contracts refuted by the prover (2,148) are a finding about the annotations, not a failure of the run.

---

## (g) Infrastructure and operational incidents

| Incident | What happened | Fix / rule |
|---|---|---|
| WSL wipes /tmp and /run when idle | Detached jobs killed, evidence lost (4 times by 7 Nov) | Keep a `wsl -- sleep infinity` window; data on Windows paths or ~/kb; rule zero |
| Git Bash path mangling | MSYS rewrote `/mnt/c/...` args to `C:/Program Files/Git/mnt/...` | `MSYS_NO_PATHCONV=1`, or write a script file and run it |
| Bash tool halved backslashes in heredocs | `\result` -> CR; `\` in awk regexes broke; sed once wrote a vertical tab into AGENTS.md | Write ACSL/awk files with the Write tool; check with `od -c` |
| CRLF checkout broke bash scripts | Windows clone of OS-Proving got CRLF: "unexpected end of file" | `.gitattributes` (`* text=auto eol=lf`, `*.cmd` CRLF, gz binary), renormalise, `git reset --hard` (commit eeeab74) |
| Git over HTTPS hangs in WSL | `commit_core.sh` `git push` hung 12+ minutes (no credentials in WSL), blocked the proving run | Script made copy-only; commit/push from Windows git only |
| Windows `find` over 9p | See (f) | Cached index; keep working copies on WSL ext4 (ingest scripts 5 min -> 59 s state recount, tag 753 s -> 48 s, export 17-23 min -> 252 s; commits b9e0db6, 55c103e) |
| Overnight death of all console windows (11 Nov ~21:36) | Cause unknown; step 4 stopped | Relaunch launchers; watchers (`*_watch.sh`) restart on death or stall |
| Morph outage 20:04-20:10 (11 Nov) | Model name unavailable for 6 minutes | Retries recovered |
| Batch-barrier stalls | `xargs` per batch waited on the slowest call: throughput 437 -> 143 -> 14 -> 1 records/min | Single streaming `xargs` plus a background budget watchdog (commit 33af82e); rate rose from about 63/min to about 380/min |
| Credit watchdog false positives | Greps matched the word "insufficient" in model text and stopped step 4 (06:10) and repair (07:14) on 12 Nov: about 45 minutes lost | Require an `"error"` line first (commit 4243deb) |
| `pkill xargs` | A pkill killed step 4's stream; `step4_all.sh` wrote DONE-batch | Removed DONE-batch and relaunched; rule: never pkill xargs. Repeated once in `kill_stuck_units.sh` v1 (matched parent xargs; acceptable during a drain) |
| Accidental STOP/restart of the DeepSeek stream | The agent's restart script moved 80 -> 100 workers and raised the budget, leaving about $0.10 of duplicate calls (removed at ingest); STOP/restart cycles also on 13 Nov for the budget raise | Done-key dedupe; budget enforcer script |
| WSL crash 1 (13 Nov ~02:50) | Four `cyphalm_trie` enwik8 jobs (about 40 of 47 GB RAM) from Odin's other work; WSL VM restarted, /tmp wiped | Restarted runs. Later Odin: "You got the whole PC to yourself." |
| WSL crash 2 (13 Nov ~03:50) | Every command into Ubuntu failed "Catastrophic failure (E_UNEXPECTED)" although `wsl --list` said Running | Needed `wsl --shutdown`; the auto-mode classifier blocked it until Odin approved |
| C: full (13 Nov ~11:30) | C: had 21 MB free of 973 GB; WSL `ext4.vhdx` had grown to 520 GB; WSL got I/O errors; proving, DeepSeek and ingest all stopped; hand-fix agent on P0079-P0084 hit it | Deleted `OS-Proving-stage` (0.5 GB) and WSL crash dumps (0.4 GB); after Odin's "Go do it": `wsl --shutdown`, journal replayed, state intact (22,940 unit directories), deleted `~/kb/tu` (about 50 GB), `fstrim`; C: back to about 43.8 GB. Elevated compaction (UAC) ran before the trim, so the vhdx still read about 520 GB. 5-minute check now tests C: free first (< 10 GB -> touch STOP) |
| C: nearly full again (13 Nov ~14:55) | `rebv` rebuilt translation units into `~/kb/tu` (needs about 30 GB): C: fell 33 GB -> 3.6 GB in about 25 minutes | Stopped `post_core.sh` and the watcher, killed rebv and cbmc, deleted `~/kb/tu` (7 GB), `fstrim` freed 41.6 GiB inside WSL, `halt_post.sh` added; C: 9.7 GB free; compaction UAC prompt not approved at the last status, so post-processing not restarted. Plan: restart in slices with cache cleanup and a 15 GB pause guard |
| Repo move (13 Nov 08:26-08:57) | Odin: "Move all the data and documentation to this git ... Halt everything ... Move all the git history too." New public repo odin-loki/OS-Proving, AGPL-3.0-or-later with a commercial licence pointer | 164 commits of path-filtered history (docs/plan/lib/code-mined, tools/verify, tools/mine), third-party source stripped from every commit; secret scans of tree, history and gz clean (assistant's report); first unit archives were 3 GB because they included kernel-derived caches, rebuilt to about 6 MB; scripts repointed to `/mnt/c/ParanoidBSD/OS-Proving`; old worktree still holds the FreeBSD source |
| Secrets | An API key sat in a OneDrive-synced folder (deleted; LESSONS B12). On 13 Nov a process listing showed the Morph key in curl arguments. The Anthropic key was found in a `secrets` folder (gitignored) and copied to `~/.pbsd/env` without printing | Stop printing process args; health-check prompt says "never print process args or API keys"; recommendation to rotate the Morph key after the runs stands (session summary) |
| Safety classifier | Blocked long heredocs, some `pkill`, `curl | sh` installers, `gh pr merge`, and `wsl --shutdown` | Use Write/Edit tools; ask Odin to run installers; ask explicitly before `wsl --shutdown` |
| Other tooling traps | `NR==FNR` with an empty first file made the pilot do nothing -> use `FILENAME==ARGV[1]`; `tail -F` of a log the run creates left a delete-pending name and broke `>>run.log` for 20 minutes; `cmd /k` watcher started by Start-Process died (use background `wsl -- bash`); bash reads a running script incrementally, so editing it live executed new lines; list builds killed by a stall watcher left truncated files (write `.part` and `mv`) | See LESSONS G/H/K |
| Agent changed a script during a live run | The pilot agent edited `bv_unit.sh` while the core run used it: a few in-flight syntax errors | Post phase reruns CBMC on all unproved; rule: never replace a binary or script a run uses |

---

## (h) Decisions the user made, and when (local time)

| When | Decision |
|---|---|
| 6 Nov | Use Windows cmd for merges; Google billing account blocked (physical card needed) |
| 6-7 Nov | "We are not fine tuning. No point." Goedel dropped; GLM writes proofs; PRISM T2 policy |
| 7 Nov | Rule zero (save work). Mine the whole corpus. Spend up to about $75; stopped overnight, resumed 8 Nov with $73 credit |
| 8 Nov | "Just use the whole lot. Im not worried about budget, so get rid of that." |
| 11 Nov | Run all verification steps in parallel; "I added 100 USD to Morph"; tiebreaks in-session; stop then continue step 4; repair all 81k; effort "minimal or the right amount of effort. Not max." (-> `low`); credit now $295: caps $260 (step 4) and $30 (repair) |
| 11-12 Nov | "Keep verifying until everything's correctly proved and ready for the DoD"; update plan to sellable level; "Got 100 USD more credit"; "I want the whole thing proved. Give me an estimate."; "I added 200 USD credit. Do the whole plan. Upgrade the spend cap" |
| 12 Nov | "Instead of just feeding the data through and through ... you do it" (stop GLM rounds 3-4, use agents); reuse the monitor script; 5-minute health checks; close console windows; DeepSeek over Kimi; "Make the cap 80"; use the Claude API ($200) |
| 13 Nov | "Just skip anthropic ... Only use it for the hardest of work"; "Lets ingest them and can you speed that thing up"; "Just increase the cap"; move everything to OS-Proving with history and AGPL; "Keep working in that git"; "Use all the cores. Theres 32."; "Do all."; "Go do it." (wsl --shutdown and space plan); "Do all 3" (build fixes, runtime-error proofs, Haiku double check idea) |
| 13 Nov | Cursor/Grok 4.7 for the "final run": a question about Cursor Ultra usage only; no decision recorded (the plan figures quoted, "400 API and 1000 grok", are unverified) |
| 13 Nov (pm) | Wants a large random-sample audit population, a seL4 comparison "honest and optimistic/sellable", every error documented ("Log every single last error ... a dataset for learning"), and a full history document (this file) |

Spend caps timeline (Odin's own statements): $5 left (7 Nov); $73 (8 Nov); +$100 (11 Nov); $295 total (11 Nov); +$100; +$200 (12 Nov); Anthropic $200 expected, exhausted at about $28.6 ledger spend (13 Nov).

---

## (i) Dead ends and abandoned approaches

| Approach | Why abandoned |
|---|---|
| Goedel-Prover-V2-8B (and 32B escalation) for Lean proofs | 13 failed `lean_prove` calls in the passing run; at 16k context it looped on `a &&& a = a` (claimed Lean has no bitwise AND for Nat); at 32k+ context the GPU/WSL froze twice (about 4 minutes in, 100% GPU, 23.8 of 24 GB). GLM proved 15 of 16 harder statements instead. One-problem sample, not a benchmark. |
| Fine-tuning Qwen 3.5 9B / Goedel | Odin: "no point"; FORGE has no training path |
| GPU burst VM / GCP workers | Billing blocked; no GPU needed after Goedel dropped; the estimate of 44 days PC-only vs about 6-10 days with burst never tested |
| E-ACSL + libFuzzer for step 3 | Runtime crash (shadow memory vs TLS); hand-built malloc/free mismatch; package lacks script. Replaced by `contract2c` (2,312 of 31,367 testable) |
| Sonnet tiebreak of every disagreement | No API key then; 60-sample in-session judgement instead (about 20,000 disagreements were expected) |
| GLM repair rounds 3 and 4 | Odin ordered agents instead after two rounds |
| Kimi K3 for the manual queue | No Morph id, no data, about $550 estimate (unverified third-party prices) |
| Anthropic API runner | Credit exhausted; Odin said skip (see (d)) |
| GLM-written loop invariants/asserts and Lean models as a proof route | 0 of 24 functions; none of 6 Lean theorems acceptable |
| PRISM as a second engine for contract proofs | Never disagreed with WP but refuses pointer functions and reads machine integers; not used as proof |
| Whole-corpus formal-contract proving | Only about 11% of functions had a formal contract; driver glue (about 322,000 functions) depends on hardware and concurrency proofs cannot model |
| Treating DeepSeek review as independent | Same model repaired and reviewed round 15 |
| Dropping "not a function" items automatically | Dropped count fell 7,746 -> 1,646 -> 377 as real functions were recovered |
| Python in the shipped pipeline | Odin constraint: C, C++, CUDA, shell/awk/jq only |
| Whole-file keyword second pass as "double reading" | Agents' second pass often only a keyword sweep |
| Haiku audit of all verified functions | Quoted at about $410-890; not run |
| Elevated WSL disk compaction before trim | Did not shrink the vhdx; needs trim first |

---

## (j) Consolidated lessons for future runs

**Money and models**
1. Quote and cap spend per stage, but read the real provider balance first; ledger figures are upper bounds and Morph has no balance endpoint.
2. Reasoning models bill hidden reasoning as output; set `reasoning_effort` (`low`) and `max_tokens` high enough (14,000, 20,000 on retry) or pay for empty replies.
3. Independence matters: do not use the same model for repair and for review. Give every judge the same definition of a defect.
4. Caps will be raised mid-run by the owner; report overruns plainly (DeepSeek stage $105.5 vs $80).
5. Machine repair deleted formal contracts instead of fixing them; keep contracts in scope or accept prose-only.

**Verification**
6. Run each contract in its own file; a pass rate that looks too good is a bug.
7. Mechanical and Frama-C checks missed real prose errors (hand pass: 43 of 64 disagreed items had real errors); only reading the source finds them.
8. Operator-precedence bugs in contracts are real defects (1,875 in the corpus).
9. A formal contract that is only a range proves little (47% of proved contracts in a sample): measure strength and mutation survival.
10. Decide "weaker than prose = defect" before the review, not after.

**Proving**
11. Fix the build environment first: 47% of core functions are unbuilt; a header/flag problem outweighs prover power.
12. Measure the unit rate, not the worker count: one 9p `find` per unit throttled everything.
13. Make the run resumable (done-markers, `CORE_START`), drain with a STOP file, never kill the parent `xargs`.
14. Label every proof with its assumptions (stub headers, callees without spec, uncertified SAT, disjoint pointers).
15. The MILESTONES heading and run.log counts can disagree with the table; read the table.

**Operations**
16. Hold a `wsl` session; keep data off /tmp and /run; write results to persistent paths and commit from Windows git.
17. Guard disk: check C: free before heavy phases (vhdx grows and does not shrink); fstrim before compaction; point caches at bounded dirs.
18. Do not run Odin's other heavy jobs (enwik8 about 40 GB RAM) alongside; they caused the first WSL crashes.
19. Use `.gitattributes` for LF in repositories used from WSL.
20. Never print process args or keys; keep keys out of synced folders; rotate keys after incidents.
21. Streaming (one `xargs` plus watchdog) beats batch loops that wait on stragglers.
22. Do not edit scripts or replace binaries a live run uses.

**Agents**
23. Cap agent workload by context; verify completeness with a script, not the agent's report.
24. Forbid dropping unread functions; require file:line evidence.
25. Treat hand fixes as drafts; plan a random audit with seeded stratified samples (done: 20,000 verified, 10,000 unchecked, 9,001 hand-fixed; checked results not yet produced).

**Claims**
26. "Verified" is not "proved". Labels never merged; every count generated by script (ASSURANCE_STATEMENT, ERRORS_FOUND, README).
27. A prover that refutes a contract (2,148) is a result worth reporting.

---

## (k) Timeline (local time; commit hashes from `git log`, other items from logs/transcripts)

| Date | Event |
|---|---|
| 5 Nov | Early session: audit/feature-map/proof-plan prompt for the PBSD distro; build PRISM; first pipeline runs |
| 6 Nov | Goedel `.fpk` search, PRISM merges, GCP billing blocked, 8B model decisions |
| 7 Nov | Rehearsals, FORGE#72 and PRISM#43/44 speed fixes (567 s -> 118 s per prove), `lean_check`, Goedel dropped, rule zero; proof-pattern miner (ad0abd3); phase-1 code mining (4071e29, $0.33) |
| 8 Nov 09:01 | Whole-corpus mining starts (aabdc2a, c911ef5, 96b512a); sync window fixed (4d6cad0); 17:01 high-failure alert; 22:40 `MINE-ALL-DONE`, 284,637 chunks, $91.78 upper bound, 72 shards |
| 8 Nov | VERIFICATION_PLAN.md committed (6beb05c, 2b8f0f3) |
| 11 Nov | Plan switched to DeepSeek V4.1 Flash 1017 (526d350); steps 1 and 2 (144e1de); Frama-C ACSL parse (9eacb1f); step 3 (b3ab4d8); results (0037549); step 4 started 15:08, stopped at 1,458 (5384321), resumed; repair pipeline (7ee5f94); effort `low` (d3ad236); caps for $100 (178adbb) |
| 11 Nov ~21:36 | Overnight death of all windows; relaunch |
| 12 Nov 01:00-07:00 | Streaming runners (3dd4db9, 33af82e, baaef55); false-credit STOPs (fixed 4243deb); repair watcher (2bd6054) |
| 12 Nov | Step 4 complete: 132,951 records, tags verified 415,923 / rejected 173,356 / unchecked 546,314 (7058cd2); repairs final (7f955bf); sellable plan (7d61401); pilot (5bbb683, 02efaf7); round 1 review done |
| 12 Nov | Round-based repair loop (24c6a44), per-TU preprocessing and WP v2 (905ac41); pilot rounds 1-3 (2386302, a4c08dd, f81aca1); round 2 data (38942c9, 3ed5dfc); manual queue (1bfb629, 0ea595e) |
| 12 Nov 14:51 | Core proving run starts at 14 workers (scripts: commit 87daea0) |
| 12 Nov evening | Hand-fix pilot packets ingested (ad91ccf, 2908245, 134b00b, 33b8f30); dsv41flash stream (af8a263); NAME_WHOLE_FILE (345ffb2); Claude runner (a8cc466) |
| 13 Nov 01:01 | Anthropic credit exhausted; STOP set |
| 13 Nov 01:08 | Core run restarted at 30 workers; BSD `.m` index fix |
| 13 Nov ~02:50, ~03:50 | WSL crashes 1 and 2 |
| 13 Nov 04:49 | "Just skip anthropic" |
| 13 Nov 08:18 | Round 15 done (DeepSeek stage final, $105.5) |
| 13 Nov 08:26-08:57 | Repo moved to OS-Proving (23d586a README and licence, c93f8d2, 2b78e90, a06ea9e, 3ea9253 repoint, eeeab74 `.gitattributes`); 80 workers |
| 13 Nov 09:26 | Round 17 (Claude results) |
| 13 Nov 10:56, 12:33, 13:46 | Rounds 18, 19, 20 (waves 1-3) |
| 13 Nov ~11:30 | C: full, WSL I/O errors; recovery after "Go do it." |
| 13 Nov 12:48 | All 24,825 unit directories built |
| 13 Nov | Fast ingest pipeline (b9e0db6), export speed (55c103e), dsv stage commit (1799509), Claude ingest script (70c1b06), snapshots c4edbd5 (17,967), 32f3aeb (76%), f6b6baa (32%), 943daf3, 00a0107 (wave scripts, disk compaction script) |
| 13 Nov 14:00 | Wave 3 ingested as round 20, final tags verified 527,395 / unchecked 547,342 / rejected 60,479 / dropped 377 (1b81a4c) |
| 13 Nov ~14:55 | rebv fills C:, post-processing halted (halt_post.sh) |
| 13 Nov 15:04 | Last commit 513630b: assurance statement (seL4 comparison), errors-found report, seeded audit samples, `halt_post.sh`; proving run final labels committed (98b3b6e) |


---

## Not covered

- The 5-7 Nov early sessions (tester pipeline, PRISM/FORGE fixes, rehearsals, GCP) are summarised from LESSONS.md and the session summaries only; the 624 KB early transcript was not read beyond its first prompt.
- Per-round cost and per-round packet mapping for rounds 3-11 (no single table); exact redo-C commit hash.
- Real Morph and Anthropic invoices; why the Anthropic account balance was far below the expected $200.
- Contents of sub-agent transcripts (wave agents, pilot agents, ingest-speed agent); agent tallies come from their hand-back text as reported in the main transcript and ERRORS_FOUND.
- Results of S5 audits (mutation on the full proved set, 400-function statement audit, the 39,001-function random audits): samples are drawn, results not produced.
- Whether the WSL vhdx was ever compacted, and whether post-processing was restarted after 13 Nov 15:04.
- Frama-C 25.0 vs 33.0 split by step is as stated in the reports; Morph model versions beyond the ids in the scripts were not audited.
- The reason for the 354-function difference between the first-round failures (173,356) and the repair-pipeline total (173,710).
- Sample B (loop-bearing) results and the sample C details beyond the figures quoted.
