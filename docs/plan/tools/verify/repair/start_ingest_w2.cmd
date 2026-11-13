@echo off
title PBSD ingest wave 2 (P0073-P0144)
wsl -d Ubuntu -- bash -lc "bash /mnt/c/ParanoidBSD/OS-Proving/docs/plan/tools/verify/repair/ingest_wave.sh w2 73 144 8 100"
