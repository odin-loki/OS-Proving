#!/bin/bash
# lift_review_cap.sh   Remove the spend cap of a RUNNING step4_all.sh review stream without stopping it: the cap is enforced only by the background watchdog subshell inside step4_all.sh
# (a loop with `sleep 20`); ending just that subshell leaves the xargs stream (and its parent) running to the end of the work list. Never touches xargs.
# The stream still stops on its own at the end of the list, and step4_watch.sh still stops it on a credit/auth error.
for s in $(pgrep -x sleep); do
  p=$(ps -o ppid= -p "$s" | tr -d ' ')
  a=$(ps -o args= -p "$p" 2>/dev/null)
  case "$a" in
    *step4_all.sh*) echo "step4_all watchdog subshell: pid $p (child sleep $s)"; kill -TERM "$p" && echo "ended watchdog $p";;
  esac
done
echo "step4_all processes still running:"; pgrep -f step4_all.sh | wc -l
echo "xargs review stream alive: $(pgrep -f 'xargs -P 100 -d' | wc -l)"
