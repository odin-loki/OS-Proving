#!/bin/bash
# memtop.sh   Memory by command name (sum of RSS), top 8. Never prints command arguments (they can contain API keys).
ps -eo rss,comm | awk 'NR>1 {a[$2]+=$1; n[$2]++} END {for (k in a) printf "%d MB %s x%d\n", a[k]/1024, k, n[k]}' | sort -rn | head -8
free -m | sed -n 2p
