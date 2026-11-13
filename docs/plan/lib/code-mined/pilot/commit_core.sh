#!/bin/bash
# commit_core.sh   Copy the snapshot of the core run (labels, summary, repair list, milestones; not the per-unit directories, which live in mined-data/prove-core) into data2/core.
# 13 Nov 2026: it no longer runs git. Inside WSL `git push` over HTTPS waits for a password forever (no credentials there) and blocked the whole run; and a git commit from WSL can
# collide with the commits made from Windows git. The snapshot is committed and pushed from Windows git (docs/plan/lib/code-mined/pilot/data2/core).
HERE=$(cd "$(dirname "$0")" && pwd); OUT=/mnt/c/ParanoidBSD/mined-data/prove-core; D=$HERE/data2/core
mkdir -p "$D"
cp "$OUT/summary.md" "$OUT/labels.tsv" "$OUT/repair_list.tsv" "$OUT/MILESTONES.md" "$D/" 2>/dev/null
gzip -f "$D/labels.tsv" "$D/repair_list.tsv"
echo "$(date '+%F %T') snapshot copied to data2/core (commit from Windows git)"
