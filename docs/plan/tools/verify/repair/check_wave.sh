#!/bin/bash
# check_wave.sh <first-packet> <last-packet>   For each packet: expected number of functions (from the packet), number of valid result lines, and whether the (key,i) sets match. Prints OK / PARTIAL / MISSING per packet.
A=${1:?first}; Z=${2:?last}; P=/mnt/c/ParanoidBSD/mined-data/manual/packets; R=/mnt/c/ParanoidBSD/mined-data/manual/results
for n in $(seq "$A" "$Z"); do
  id=$(printf 'P%04d' "$n"); pf="$P/packet-$id.jsonl"; rf="$R/r17-$id.jsonl"
  [ -f "$pf" ] || { echo "$id no-packet"; continue; }
  jq -r '.key as $k | .functions[] | "\($k)\t\(.i)"' "$pf" | sort -u > /tmp/chk_exp.txt
  exp=$(wc -l < /tmp/chk_exp.txt)
  if [ ! -f "$rf" ]; then echo "$id MISSING expected=$exp"; continue; fi
  jq -r 'select(.key != null and .i != null and .name != null and (.action=="fix" or .action=="drop")) | "\(.key)\t\(.i)"' "$rf" 2>/dev/null | sort -u > /tmp/chk_got.txt
  got=$(wc -l < /tmp/chk_got.txt); miss=$(comm -23 /tmp/chk_exp.txt /tmp/chk_got.txt | wc -l); extra=$(comm -13 /tmp/chk_exp.txt /tmp/chk_got.txt | wc -l)
  if [ "$miss" -eq 0 ] && [ "$extra" -eq 0 ]; then echo "$id OK $got/$exp"; else echo "$id PARTIAL got=$got expected=$exp missing=$miss extra=$extra"; fi
done
rm -f /tmp/chk_exp.txt /tmp/chk_got.txt
