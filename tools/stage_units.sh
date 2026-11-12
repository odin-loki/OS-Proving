#!/bin/bash
# stage_units.sh <rCore run dir> <out dir>   Archive ONLY the small per-unit result files (1000 units per .tar.gz). Not archived: defs.txt.gz, unit.c, unit.final.c, bv.h.c, prover caches (.frama-c), logs.
RC=${1:-$HOME/kb/rCore}; OUT=${2:-/mnt/c/ParanoidBSD/OS-Proving/data/proving/core/units}
rm -rf "$OUT"; mkdir -p "$OUT"; cd "$RC" || exit 1
ls -d u* | sort > /tmp/ospr_units.txt; rm -f /tmp/ospr_chunk_*; split -l 1000 -d -a 3 /tmp/ospr_units.txt /tmp/ospr_chunk_
for c in /tmp/ospr_chunk_*; do
  n=${c##*_}
  : > /tmp/ospr_files.txt
  while read -r u; do
    for f in meta.tsv contract.acsl contract.exp result.tsv result.bv.tsv result.bv2.tsv replay.tsv mutation.tsv tu.how machdep unit.c.sig unit.c.callees bv.cex; do [ -f "$u/$f" ] && echo "$u/$f" >> /tmp/ospr_files.txt; done
  done < "$c"
  tar czf "$OUT/units-$n.tar.gz" -T /tmp/ospr_files.txt 2>/dev/null
  echo "$(date +%T) units-$n: $(stat -c %s "$OUT/units-$n.tar.gz") bytes"
done
rm -f /tmp/ospr_chunk_* /tmp/ospr_units.txt /tmp/ospr_files.txt
echo "total: $(du -sk "$OUT" | cut -f1) KB"
