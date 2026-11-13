#!/bin/bash
# ingest_wave.sh <wave-name> <first-packet-number> <last-packet-number> [review-budget-usd=8] [parallel=100]
# Join the hand-fix result files r17-P<nnnn>.jsonl of one wave into ONE manual-result file (deduplicated on (key, i); every line validated) and ingest it (ingest_manual.sh: re-verify steps 1-3
# + Frama-C, DeepSeek review, state). Waits until no other ingest/state/tag/export/round process runs. Result: mined-data/manual/results/<wave-name>.jsonl, log mined-data/manual/ingest-<wave-name>.log
W=${1:?wave name}; A=${2:?first packet}; Z=${3:?last packet}; VB=${4:-8}; VPAR=${5:-100}
HERE=$(cd "$(dirname "$0")" && pwd); R=/mnt/c/ParanoidBSD/mined-data/manual/results; LOG=/mnt/c/ParanoidBSD/mined-data/manual/ingest-$W.log
log() { echo "$(date '+%F %T') [wave $W] $*" | tee -a "$LOG"; }
busy() { pgrep -f 'ingest_manual.sh|/state.sh|tag_final.sh|export_manual.sh|round_run.sh' | grep -vx "$$" > /dev/null; }
: > "$R/$W.tmp"
for n in $(seq "$A" "$Z"); do f=$(printf '%s/r17-P%04d.jsonl' "$R" "$n"); [ -f "$f" ] && cat "$f" >> "$R/$W.tmp" || log "missing result file for packet $n"; done
# A "drop" whose note says the function was not read (too large to read) is NOT a real drop: the function exists and still needs hand work. Such lines are kept out of the ingest
# (they stay in the queue) and listed in mined-data/manual/results/<wave>.unread-drops.jsonl.
UNREAD='(not read in full|did not read|I did not read|not read\))'
jq -c --arg re "$UNREAD" 'select(.action == "drop" and ((.note // "") | test($re)))' "$R/$W.tmp" > "$R/$W.unread-drops.jsonl" 2>>"$LOG"
jq -c -s --arg re "$UNREAD" 'map(select(.key != null and .i != null and .name != null and (.action == "fix" or .action == "drop"))) | map(select((.action == "drop" and ((.note // "") | test($re))) | not)) | group_by([.key, .i]) | map(.[-1]) | .[]' "$R/$W.tmp" > "$R/$W.jsonl" 2>>"$LOG"
# Optional explicit exclusions: mined-data/manual/results/exclude-<wave>.txt, one "<key><TAB><i>" per line (drops the agent marked for functions it did not read, when the note does not say so).
if [ -s "$R/exclude-$W.txt" ]; then
  jq -c -s --rawfile ex "$R/exclude-$W.txt" '($ex | split("\n") | map(select(length > 0))) as $x | map(select(([.key, (.i | tostring)] | join("\t")) as $k | ($x | index($k)) | not)) | .[]' "$R/$W.jsonl" > "$R/$W.jsonl.x" 2>>"$LOG" && mv "$R/$W.jsonl.x" "$R/$W.jsonl"
  log "explicit exclusions applied: $(wc -l < "$R/exclude-$W.txt")"
fi
log "kept out of the ingest (unread large functions marked drop): $(wc -l < "$R/$W.unread-drops.jsonl")"
log "joined: $(wc -l < "$R/$W.tmp") lines -> $(wc -l < "$R/$W.jsonl") valid results ($(jq -r 'select(.action=="drop")|1' "$R/$W.jsonl" | wc -l) drops)"
rm -f "$R/$W.tmp"
while busy; do log "waiting: another ingest/state/tag/export/round process is running"; sleep 60; done
log "ingest start (review budget \$$VB, parallel $VPAR)"
bash "$HERE/ingest_manual.sh" "$R/$W.jsonl" "$VB" "$VPAR" >> "$LOG" 2>&1
log "ingest finished"
