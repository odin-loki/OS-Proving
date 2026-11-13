#!/bin/bash
# halt_post.sh   Emergency stop of the post-processing phase (rebv/replay/...): STOP file, then end the post_core/rebv shells, their xargs and the tool processes they spawned (cbmc, frama-c, solvers).
touch "$HOME/kb/rCore/STOP"
for pat in 'pilot/post_core.sh' 'pilot/watch_core.sh' 'pilot/rebv.sh' 'pilot/replay2.sh'; do pkill -f "[${pat:0:1}]${pat:1}"; done
sleep 1
for round in 1 2 3; do
  for p in xargs cbmc frama-c why3 alt-ergo z3 cvc5 cc1 goto-cc; do pkill -x "$p"; done
  sleep 2
done
echo "left: $(pgrep -c -x 'cbmc|frama-c|xargs|goto-cc|z3')"
df -h / | tail -1
