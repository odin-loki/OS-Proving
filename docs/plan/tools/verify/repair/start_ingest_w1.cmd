@echo off
title PBSD ingest wave 1 (P0001-P0072)
wsl -d Ubuntu -- bash -lc "bash /mnt/c/ParanoidBSD/OS-Proving/docs/plan/tools/verify/repair/ingest_wave.sh w1 1 72 8 100"
