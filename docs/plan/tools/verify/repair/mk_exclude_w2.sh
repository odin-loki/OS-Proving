#!/bin/bash
# mk_exclude_w2.sh   Wave 2 exclusions: every "drop" line of P0123 (dt_node_op2 = the middle of the 850-line dt_cook_op2) and of P0126 (huge T0 interpreters and client/server mains the agent did not read)
# stays out of the ingest, because those functions exist and still need hand work. Writes mined-data/manual/results/exclude-w2.txt ("<key><TAB><i>" per line).
R=/mnt/c/ParanoidBSD/mined-data/manual/results
: > "$R/exclude-w2.txt"
for n in 123 126; do
  jq -r 'select(.action == "drop") | [.key, (.i | tostring)] | join("\t")' "$(printf '%s/r17-P%04d.jsonl' "$R" "$n")" >> "$R/exclude-w2.txt"
done
echo "exclusions: $(wc -l < "$R/exclude-w2.txt")"
