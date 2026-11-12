Claude API stage (mined-data/claude). Scripts: docs/plan/tools/verify/repair/cl_*.sh, start_claude.cmd.
Jobs (jobs/<name>/job.env): sonnet-tail (Sonnet 5.5 batch, end of the DeepSeek order, stays behind position 16500 until mined-data/dsv/STOP|DONE exists),
  opus-fail (Opus 5.5 batch: group 0 + DeepSeek failed.txt), review-dsv (Haiku 5.5 batch review of the DeepSeek fixes; todo grows: review-dsv/todo.tsv).
Results: jobs/<name>/res.jsonl (manual-result format; reviews: xcheck format), ledger.txt ("model batch|rt in out"), job.log, errors.log. Global: watch.log, status.json.
Stop: create STOP in mined-data/claude (all) or jobs/<name>/. Resume: start_claude.cmd <jobs...>. Cap: USD 150 over all ledgers (test/*/ledger.txt + jobs/*/ledger.txt) + reservations of unfinished batches.
Quality test (P0080, 38 records/40 functions, checks = ingest checks, scratch dirs test/score-*, no merge into the status table):
  Sonnet 5.5 medium, old prompt: 28 fixed / 12 dropped (fragments dropped). Opus 5.5 high, old prompt: 28 / 11 dropped / 1 still-rejected.
  After adding the "function containing the slice" section + placeholder-name rule: rerun of the 14 failing records: Sonnet 11/12 fixed (1 still-rejected), Opus 12/12 fixed.
  => P0080 total: Sonnet 39/40, Opus 40/40 (reference 39/40). Cost per record (batch, 50%): Sonnet ~0.011-0.017 USD, Opus ~0.045 USD (sync Opus 0.055, Sonnet 0.022).
  Haiku review of those fixes: Sonnet 36 agree/2 disagree, Opus 13 agree/1 disagree (of the first 14).
Reviewer test (100 records: 50 hand-fixed reference = good, 50 same code with another function's annotation = bad): Haiku 5.5 good->agree 46/50, bad->disagree 48/50 (0.0006 USD per record);
  Sonnet 5.5 good->agree 34/50, bad->disagree 50/50 (0.009 USD per record, too strict). Haiku is used.
First production Sonnet batch (300 records, 340 functions) scored with the ingest checks: 320 fixed, 12 still-rejected, 8 dropped.
After the DeepSeek ingest: bash cl_apply_reviews.sh <K>; bash state.sh   (Haiku reviews replace DeepSeek self-review for the dsv round K)
Claude fixes: bash cl_finish.sh <review-budget> [parallel]  (waits for dsv FINISHED, then ingest_manual.sh etc.).  Opus round 2: bash cl_opus_round.sh; start_claude.cmd opus-round2
