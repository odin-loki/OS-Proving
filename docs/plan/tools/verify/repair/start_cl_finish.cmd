@echo off
title PBSD Claude-results ingest (cl_finish)
wsl -d Ubuntu -- bash -lc "bash /mnt/c/ParanoidBSD/OS-Proving/docs/plan/tools/verify/repair/cl_finish.sh 8 100"
