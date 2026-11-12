#!/bin/bash
# stage_data.sh   Copy the project's data (annotations, status tables, repair and review results, proving results) from the working data directory into this repository's data/ tree.
# Rules: only text results are copied (json, jsonl, tsv, log, md, txt), big files are gzipped, files above 90 MB are split. NO third-party source code is copied: no source slices, no packets, no preprocessed
# units, no *.c *.h *.i files. Credentials are never copied (a scan runs at the end).
# Usage: stage_data.sh <mined-data dir> <rCore run dir> <repo dir>
M=${1:-/mnt/c/ParanoidBSD/mined-data}; RC=${2:-$HOME/kb/rCore}; REPO=${3:-/mnt/c/ParanoidBSD/OS-Proving}; D=$REPO/data
mkdir -p "$D"/{status,rounds,results/dsv,results/claude,results/manual,proving/core}
say() { echo "$(date '+%F %T') $*"; }
put() { # put <src> <dst-dir>: copy, gzip when large, split when still above 90 MB
  local f=$1 d=$2 b; b=$(basename "$f"); mkdir -p "$d"
  [ -f "$f" ] || return 0
  local sz; sz=$(stat -c %s "$f")
  if [ "$sz" -gt 5000000 ] && [[ "$b" != *.gz ]]; then gzip -9 -c "$f" > "$d/$b.gz"; b=$b.gz; else cp "$f" "$d/$b"; fi
  local osz; osz=$(stat -c %s "$d/$b")
  if [ "$osz" -gt 90000000 ]; then split -b 80m -d "$d/$b" "$d/$b.part-"; rm -f "$d/$b"; fi
}
say "status tables"
for f in final/state.tsv final/state-summary.json final/final-summary.json; do put "$M/$f" "$D/status"; done
[ -f "$M/final/spend-baseline.txt" ] && cp "$M/final/spend-baseline.txt" "$D/status/"
say "rounds (repair + verification results of every round)"
for r in "$M"/repair[0-9]* "$M"/repair; do
  [ -d "$r" ] || continue; n=$(basename "$r")
  for f in "$r"/*.jsonl "$r"/*.tsv "$r"/*.log "$r"/*.json "$r"/*.txt; do [ -f "$f" ] && put "$f" "$D/rounds/$n"; done
done
for r in "$M"/verify-repair[0-9]* "$M"/verify-repair "$M"/verify; do
  [ -d "$r" ] || continue; n=$(basename "$r")
  for f in "$r"/repair-tags.jsonl "$r"/*.json "$r"/*summary* "$r"/dropped.tsv "$r"/xcheck/xcheck.jsonl "$r"/xcheck/ledger.txt "$r"/xcheck/step4.log "$r"/tags.jsonl "$r"/step12.jsonl "$r"/s3.jsonl "$r"/frama.jsonl; do
    [ -f "$f" ] && put "$f" "$D/rounds/$n/$(dirname "${f#$r/}")"
  done
done
say "DeepSeek stage"
for f in dsv/dsv.dedup.jsonl dsv/dsv.jsonl dsv/ledger.txt dsv/done.keys dsv/failed.txt dsv/repair.log dsv/watch.log; do put "$M/$f" "$D/results/dsv"; done
say "Claude API stage (parked results)"
for j in "$M"/claude/jobs/*; do [ -d "$j" ] && for f in "$j"/res.jsonl "$j"/ledger.txt "$j"/job.log; do put "$f" "$D/results/claude/$(basename "$j")"; done; done
for f in "$M"/claude/*.log "$M"/claude/*.summary "$M"/claude/README.txt "$M"/claude/*.tsv "$M"/claude/status.json; do [ -f "$f" ] && put "$f" "$D/results/claude"; done
say "manual queue results (no packets: they contain source text)"
[ -d "$M/manual/results" ] && cp -r "$M/manual/results/." "$D/results/manual/" 2>/dev/null
for f in manual/index.tsv manual/functions.tsv manual/export.out manual/ingest-redoC.log manual/ingest-redoD.log manual/roundrun14.log; do put "$M/$f" "$D/results/manual"; done
[ -d "$M/manual/ingest-logs" ] && cp -r "$M/manual/ingest-logs" "$D/results/manual/" 2>/dev/null
say "proving run (labels, summaries, per-unit result files)"
for f in prove-core/labels.tsv prove-core/repair_list.tsv prove-core/sample.tsv prove-core/summary.md prove-core/MILESTONES.md prove-core/run.log; do put "$M/$f" "$D/proving/core"; done
[ -d "$RC" ] && bash "$(dirname "$0")/stage_units.sh" "$RC" "$D/proving/core/units"
say "pilot data sets (kept small)"
for p in pilot pilot-B pilot-C; do for f in "$M/$p"/*.tsv "$M/$p"/*.jsonl "$M/$p"/*.md "$M/$p"/*.json; do [ -f "$f" ] && put "$f" "$D/proving/$p"; done; done
say "secret scan"
if grep -rIlE 'sk-ant-api|sk-[A-Za-z0-9]{40,}|Bearer [A-Za-z0-9_-]{30,}|AKIA[0-9A-Z]{14,}|ghp_[A-Za-z0-9]{30,}' "$D" 2>/dev/null | head -5 | grep . ; then say "POSSIBLE SECRET FOUND (listed above): do not commit"; else say "no secret patterns found in data/"; fi
for f in $(find "$D" -name '*.gz' -size -2000k | head -2000); do :; done
say "done: $(du -sk "$D" | cut -f1) KB, $(find "$D" -type f | wc -l) files"
