#!/bin/bash
# audit_sample.sh <population> <n> <seed> <out.tsv> [repo dir]
# Draw a seeded, stratified random sample from the status table (data/status/state.tsv.gz) for an independent audit.
#   population: verified   (status kept-verified or fixed-agree: everything labelled "verified")
#               unchecked  (status kept-unchecked)
#               handfixed  (status fixed-agree/fixed-disagree/fixed-unreviewed/still-rejected from the hand-fix rounds 17-20)
# Strata: code base (linux, freebsd, kde) x status. Allocation proportional to stratum size (at least 30 per stratum when it has that many).
# The seed and the full sample list are committed so the draw can be repeated: same seed, same status table, same sample.
# Output columns: key, i, name, kind, status, round, tree
POP=${1:?population}; N=${2:?sample size}; SEED=${3:?seed}; OUT=${4:?out file}; REPO=${5:-/mnt/c/ParanoidBSD/OS-Proving}
ST=$REPO/data/status/state.tsv.gz
case "$POP" in
  verified)  PAT='^(kept-verified|fixed-agree)$' ;;
  unchecked) PAT='^kept-unchecked$' ;;
  handfixed) PAT='^(fixed-agree|fixed-disagree|fixed-unreviewed|still-rejected)$' ;;
  *) echo "unknown population $POP" >&2; exit 2 ;;
esac
TMP=$(mktemp)
zcat "$ST" | awk -F'\t' -v pat="$PAT" -v seed="$SEED" -v pop="$POP" '
  BEGIN { srand(seed) }
  { st = $5; rd = $6
    if (st !~ pat) next
    if (pop == "handfixed" && rd < 17) next
    tree = ($1 ~ /pbsd-ref\/linux/) ? "linux" : ($1 ~ /\/kde\//) ? "kde" : "freebsd"
    printf "%s\t%.12f\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", tree "/" st, rand(), $1, $2, $3, $4, st, rd, tree
  }' | sort -t$'\t' -k1,1 -k2,2n > "$TMP"
TOTAL=$(wc -l < "$TMP")
[ "$TOTAL" -gt 0 ] || { echo "empty population" >&2; rm -f "$TMP"; exit 1; }
awk -F'\t' -v n="$N" -v total="$TOTAL" '
  { size[$1]++; line[NR] = $0; strat[NR] = $1 }
  END {
    for (s in size) { q[s] = int(n * size[s] / total + 0.5); if (q[s] < 30) q[s] = (size[s] < 30 ? size[s] : 30) }
    for (r = 1; r <= NR; r++) { s = strat[r]; if (taken[s] < q[s]) { taken[s]++; split(line[r], f, "\t"); print f[3] "\t" f[4] "\t" f[5] "\t" f[6] "\t" f[7] "\t" f[8] "\t" f[9] } }
  }' "$TMP" > "$OUT"
rm -f "$TMP"
echo "population $POP: $TOTAL functions; sample $(wc -l < "$OUT") (seed $SEED) -> $OUT"
awk -F'\t' '{c[$7 "/" $5]++} END {for (k in c) print "  " k, c[k]}' "$OUT" | sort
