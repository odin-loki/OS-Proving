@echo off
title PBSD core proving (resumes)
wsl -d Ubuntu -- bash -lc "CORE_START=22000 bash /mnt/c/ParanoidBSD/OS-Proving/docs/plan/lib/code-mined/pilot/watch_core.sh 80"
