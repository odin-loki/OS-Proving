#!/bin/bash
# build_error_dataset.sh   Build the error dataset data/errors/ from the project's data (a learning dataset: every error event we recorded, the original annotations that had errors, and every repair attempt).
# Reads:  <mined-data>/verify (round-0 checks), <mined-data>/repairN (repair rounds), data/rounds/verify-repairN (post-repair checks), <mined-data>/manual/results (hand-fix results), <mined-data>/prove-core (prover labels),
#         docs/plan/lib/code-mined/shards (original annotations), data/status/state.tsv.gz.
# Writes: data/errors/{events.jsonl.gz, annotations-original.jsonl.gz, repairs-rNN.jsonl.gz, index.tsv.gz, SCHEMA.md-numbers}. NO third-party source code is included: only our own annotations, check messages and prover output.
# Temp files go to WSL-local ext4 ($HOME/kb/errds). Counts are printed at the end and written to data/errors/COUNTS.md.
M=${M:-/mnt/c/ParanoidBSD/mined-data}; REPO=${REPO:-/mnt/c/ParanoidBSD/OS-Proving}; T=${T:-$HOME/kb/errds}; O=$REPO/data/errors
mkdir -p "$T" "$O"; say() { echo "$(date '+%F %T') $*"; }
ST=$REPO/data/status/state.tsv.gz
SH=$REPO/docs/plan/lib/code-mined/shards

say "state table -> name lookup (key|name -> i) and per-function info"
zcat "$ST" | awk -F'\t' '{ tree = ($1 ~ /pbsd-ref\/linux/) ? "linux" : ($1 ~ /\/kde\//) ? "kde" : "freebsd"; print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" tree }' > "$T/info.tsv"
awk -F'\t' '!seen[$1 "|" $3]++ { print $1 "|" $3 "\t" $2 }' "$T/info.tsv" > "$T/nameidx.tsv"

# ---- stage events: each source prints "key<TAB>i<TAB>json" ----
say "mechanical + grammar failures (round 0 and after each repair round)"
{
  jq -r 'select(.s1=="fail") | [.key,(.i|tostring),({round:0,stage:"verify",check:"mechanical",detail:.s1_why}|tojson)]|join("	")' "$M/verify/step12.jsonl"
  jq -r 'select(.s2=="fail") | [.key,(.i|tostring),({round:0,stage:"verify",check:"contract-grammar",detail:.s2_why}|tojson)]|join("	")' "$M/verify/step12.jsonl"
  for d in "$REPO"/data/rounds/verify-repair[0-9]*; do r=${d##*verify-repair}; f=$d/step12.jsonl.gz; [ -f "$f" ] || continue
    zcat "$f" | jq -r --argjson r "$r" 'select(.s1=="fail") | [.key,(.i|tostring),({round:$r,stage:"post-repair",check:"mechanical",detail:.s1_why}|tojson)]|join("	")'
    zcat "$f" | jq -r --argjson r "$r" 'select(.s2=="fail") | [.key,(.i|tostring),({round:$r,stage:"post-repair",check:"contract-grammar",detail:.s2_why}|tojson)]|join("	")'
  done
} > "$T/ev_mech.tsv"
say "Frama-C failures"
jq -r 'select(.frama!="pass" and .frama!="skip") | [.key,(.i|tostring),({round:0,stage:"verify",check:"frama-c-acsl",result:.frama,detail:.msg}|tojson)]|join("	")' "$M/verify/frama12.jsonl" > "$T/ev_frama.tsv"
say "random-test counterexamples"
jq -r 'select((.s3 // "")|test("counterexample|crash|timeout")) | [.key,(.i|tostring),({round:0,stage:"verify",check:"random-test",result:.s3,detail:.detail}|tojson)]|join("	")' "$M/verify/s3/s3.jsonl" > "$T/ev_fuzz.tsv"
say "cross-check disagreements (reviewer reasons)"
{
  zcat "$REPO/data/rounds/verify/xcheck/xcheck.jsonl.gz" | jq -r 'select(.verdicts!=null) | .key as $k | .verdicts[] | select(.verdict=="disagree") | [($k+"|"+.name),({round:0,stage:"verify",check:"model-cross-check",result:"disagree",detail:.reason}|tojson)]|join("	")'
  for d in "$REPO"/data/rounds/verify-repair[0-9]*; do r=${d##*verify-repair}; f=$d/xcheck/xcheck.jsonl.gz; [ -f "$f" ] || continue
    zcat "$f" | jq -r --argjson r "$r" 'select(.verdicts!=null) | .key as $k | .verdicts[] | select(.verdict=="disagree") | [($k+"|"+.name),({round:$r,stage:"post-repair",check:"model-cross-check",result:"disagree",detail:.reason}|tojson)]|join("	")'
  done
} > "$T/ev_x_byname.tsv"
awk -F'\t' 'NR==FNR { idx[$1] = $2; next } ($1 in idx) { split($1, a, "|"); print a[1] "\t" idx[$1] "\t" $2 }' "$T/nameidx.tsv" "$T/ev_x_byname.tsv" > "$T/ev_x.tsv"
say "hand-fix results (notes carry the reviewer verdicts and what was wrong)"
cat "$M"/manual/results/r17-P*.jsonl 2>/dev/null | jq -r 'select(.key!=null and .i!=null) | [.key,(.i|tostring),({round:"hand",stage:"hand-fix",check:"reader-finding",result:.action,detail:((.note // "")[0:1800]),flags:{renamed:((.note // "")|test("real name|really |is actually|under the real|packet name")),partly_read:((.note // "")|test("partly read")),reviewer_wrong:((.note // "")|test("reviewer[^.]{0,40}(wrong|incorrect)|round [0-9]+ (is )?wrong")),dropped:(.action=="drop")}}|tojson)]|join("	")' > "$T/ev_hand.tsv"
say "prover labels (FALSE, FAILED, WPERROR, UNBUILT, CONTRACT-ONLY, VACUOUS)"
awk -F'\t' 'NR==FNR { key[FNR] = $1; idx[FNR] = $5; next } ($1 in key) && $6 != "PROVED" && $6 != "PROVED-ASSUMING" { printf "%s\t%s\t%s\t%s\t%s\t%s\n", key[$1], idx[$1], $6, $7, $8, $9 }' "$M/prove-core/sample.tsv" <(zcat "$REPO/data/proving/core/labels.tsv.gz") | \
  jq -R -r 'split("\t") | select(length>=3) | [.[0],.[1],({round:"prove",stage:"prover",check:"prover",result:.[2],detail:(((.[3]//"")+" | "+(.[4]//"")+" | "+(.[5]//""))[0:1500])}|tojson)]|join("	")' > "$T/ev_prove.tsv"
say "final status of functions that never got a good fix"
awk -F'\t' '$5=="still-rejected"||$5=="rejected-unrepaired"||$5=="dropped"||$5=="fixed-disagree" { printf "%s\t%s\t{\"round\":%s,\"stage\":\"final\",\"check\":\"status\",\"result\":\"%s\",\"detail\":\"\"}\n", $1, $2, $6, $5 }' "$T/info.tsv" > "$T/ev_final.tsv"

say "merge events with function info"
cat "$T"/ev_mech.tsv "$T"/ev_frama.tsv "$T"/ev_fuzz.tsv "$T"/ev_x.tsv "$T"/ev_hand.tsv "$T"/ev_prove.tsv "$T"/ev_final.tsv | sort -t$'\t' -k1,1 -k2,2n -s > "$T/ev_all.tsv"
say "write events.jsonl.gz"
awk -F'\t' 'NR==FNR { inf[$1 "\001" $2] = $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7; next } { k = $1 "\001" $2; if (k in inf) printf "%s\t%s\t%s\t%s\n", $1, $2, $3, inf[k] }' "$T/info.tsv" "$T/ev_all.tsv" | \
  jq -R -c 'split("\t") | (.[2]|fromjson) as $e | {key:.[0], i:(.[1]|tonumber), name:.[3], kind:.[4], tree:.[7], final_status:.[5], final_round:(.[6]|tonumber? // .[6])} + $e' | gzip -9 > "$O/events.jsonl.gz"
say "events: $(zcat "$O/events.jsonl.gz" | wc -l)"

say "original annotations of the functions that had events"
cut -f1,2 "$T/ev_all.tsv" | sort -u > "$T/evkeys.tsv"
: > "$T/orig.tsv"
for f in "$SH"/*.jsonl.gz; do
  zcat "$f" | jq -r '.key as $k | (.result.functions // []) | to_entries[] | [$k,(.key|tostring),({summary:.value.summary,kind:.value.kind,contract:.value.contract,prose_contract:.value.prose_contract,error_convention:.value.error_convention}|tojson)]|join("	")' >> "$T/orig.tsv"
done
sort -t$'\t' -k1,1 -k2,2n -s "$T/orig.tsv" > "$T/orig.sorted.tsv"
awk -F'\t' 'NR==FNR { want[$1 "\x01" $2] = 1; next } (($1 "\x01" $2) in want) { print $1 "\t" $2 "\t" $3 }' "$T/evkeys.tsv" "$T/orig.sorted.tsv" | \
  jq -R -c 'split("\t") | {key:.[0], i:(.[1]|tonumber)} + (.[2]|fromjson)' | gzip -9 > "$O/annotations-original.jsonl.gz"
say "original annotations: $(zcat "$O/annotations-original.jsonl.gz" | wc -l)"

say "repair attempts (machine rounds 1-16 and hand-fix results): old error -> new annotation"
if [ -f "$M/verify/repair/repair.jsonl" ]; then jq -c --argjson r 1 '.key as $k | (.result.functions // [])[]? | {key:$k, i:(.idx), name:.name, round:$r, by:"model-repair", action:.action, prose:(.prose_contract // .prose // ""), contract:(.contract // "")}' "$M/verify/repair/repair.jsonl" 2>/dev/null | gzip -9 > "$O/repairs-r01.jsonl.gz"; fi
for d in "$M"/repair[0-9]*; do r=${d##*repair}; f=$d/repair.jsonl; [ -f "$f" ] || continue
  case "$r" in *[!0-9]*) continue ;; esac
  jq -c --argjson r "$r" '.key as $k | (.result.functions // [])[]? | {key:$k, i:(.idx), name:.name, round:$r, by:"model-repair", action:.action, prose:(.prose_contract // .prose // ""), contract:(.contract // "")}' "$f" 2>/dev/null | gzip -9 > "$O/repairs-r$(printf %02d "$r").jsonl.gz"
done
cat "$M"/manual/results/r17-P*.jsonl 2>/dev/null | jq -c '{key:.key, i:.i, name:.name, round:"hand", by:"hand-fix agent", action:.action, prose:(.prose // ""), contract:(.contract // ""), note:(.note // "")}' | gzip -9 > "$O/repairs-hand.jsonl.gz"
ls -la "$O" | awk '{print $5, $9}' | tail -n +4

say "index"
zcat "$O/events.jsonl.gz" | jq -r '[.key,(.i|tostring),.name,.tree,.final_status,.check,.result // ""]|join("	")' | sort | uniq -c | sort -rn | gzip -9 > "$O/index-by-check.tsv.gz"
zcat "$O/events.jsonl.gz" | jq -r '[.stage,.check,(.result // "-")]|join("	")' | sort | uniq -c | sort -rn > "$T/counts.txt"
{
  echo "# Error dataset counts (generated by tools/build_error_dataset.sh on $(date '+%F'))"; echo
  echo "| Events | Stage | Check | Result |"; echo "|---|---|---|---|"
  awk '{ printf "| %s | %s | %s | %s |\n", $1, $2, $3, $4 }' "$T/counts.txt"
  echo; echo "Total events: $(zcat "$O/events.jsonl.gz" | wc -l)"
  echo "Distinct functions with at least one event: $(zcat "$O/events.jsonl.gz" | jq -r '.key + "|" + (.i|tostring)' | sort -u | wc -l)"
  echo "Original annotations included: $(zcat "$O/annotations-original.jsonl.gz" | wc -l)"
  for f in "$O"/repairs-*.jsonl.gz; do echo "Repair attempts in $(basename "$f"): $(zcat "$f" | wc -l)"; done
} > "$O/COUNTS.md"
rm -rf "$T"
say "done"; cat "$O/COUNTS.md" | head -60
