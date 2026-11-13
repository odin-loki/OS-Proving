#!/bin/bash
# w3_precheck.sh   Before the wave-3 ingest: every packet 145-212 must be OK in check_wave.sh; lists drops whose note says the function was not read.
HERE=$(cd "$(dirname "$0")" && pwd); R=/mnt/c/ParanoidBSD/mined-data/manual/results
bash "$HERE/check_wave.sh" 145 212 > /tmp/w3check.txt
echo "packets OK: $(grep -c ' OK ' /tmp/w3check.txt) of 68"
grep -v ' OK ' /tmp/w3check.txt
tot=0; drops=0
for n in $(seq 145 212); do
  f=$(printf '%s/r17-P%04d.jsonl' "$R" "$n"); [ -f "$f" ] || { echo "missing $f"; continue; }
  tot=$((tot + $(wc -l < "$f"))); drops=$((drops + $(jq -r 'select(.action == "drop") | 1' "$f" | wc -l)))
done
echo "lines: $tot, drops: $drops"
for n in $(seq 145 212); do
  f=$(printf '%s/r17-P%04d.jsonl' "$R" "$n")
  jq -r 'select(.action == "drop" and ((.note // "") | test("not read|did not read|unread"))) | "\(.key | split(":")[-1])\ti=\(.i)\t\(.name)\t\(.note[0:120])"' "$f"
done
