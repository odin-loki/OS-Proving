@echo off
title PBSD ingest wave 3 (P0145-P0212)
wsl -d Ubuntu -- bash -lc "bash /mnt/c/ParanoidBSD/OS-Proving/docs/plan/tools/verify/repair/ingest_wave.sh w3 145 212 8 100"
