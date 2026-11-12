# Hand-fix method for the manual queue (stage S2/S3, used from round 18)

Applies to every function in a manual packet: the ones the automated rounds could not settle (reviewer disagrees, review failed, still rejected, or dropped as "not a function").
The buyer checks claims, so the prose must be TRUE to the code. A wrong prose that sounds right is worse than no prose.

## Why this method
A hand pass on 93 functions found real prose errors in 43 of 64 reviewer-disagreed ones and in 8 of 29 unreviewed ones. The mechanical and Frama-C checks caught none of them. The errors were:
overstated claims ("always", "every path", "nothing else changes"), missed return or error paths, wrong assumptions about what a callee does (locks, references, who frees),
incomplete state enumeration or unstated side effects, and the wrong function described because the slice cut off the head.

## Rules
1. **Read the real source.** Linux: `/home/odin/pbsd-ref/linux` (WSL path). FreeBSD / HardenedBSD: the file path in the packet, under `/mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src`. Read the whole function and the callees that decide its return value, locks, references or memory. The packet slice may cut the head or the tail: use the full function.
2. **List every `return` and every `goto` label first**, each with its cleanup and its lock / reference / memory effect. Write the prose from that list.
3. **Ban unqualified "always", "never", "every path", "nothing else changes", "returns 0"** unless every exception is enumerated. Say what the code does, not what it intends.
4. **Contract field**: only for a function whose parameters and return value are all integers, booleans or enums and which touches no global state. One line `/*@ requires ...; ensures ...; */`, use `result`, parenthesise bit operations, exclude overflow inputs. If unsure, leave it `""`.
5. **Name field**: the real name of the function that is defined in the code. For a macro-generated function use the exact macro invocation or definition head as it appears in the file, and name the real function in the prose ("Generated function X ...").
6. **Drop** only a listed item that is not a function (a macro that only forwards, a declaration, a type). If the slice has no head but the function exists, FIX it under its real name (`note`: "slice cut the head").
7. **Reviewer claims are leads, not facts.** Where the packet shows a reviewer reason, check it against the code line by line. If the reviewer is wrong, keep the prose and put the file:line evidence in `note`. If the reviewer is right, rewrite.
8. **Second pass on yourself.** After writing a packet, re-read each prose sentence against the source once more and remove or qualify any claim you cannot point to a line for.
9. Do not call any model API for the fixing; the reading and writing is yours.

## Output
One result line per function: `{"key":..., "i":..., "name":..., "action":"fix"|"drop", "prose":..., "contract":"" or "/*@ ... */", "note":...}`, in `/mnt/c/ParanoidBSD/mined-data/manual/results/r17-<packet>.jsonl` (for example `r17-P0042.jsonl`).
Do not commit, do not push, do not run any ingest, state, export or tag script: the coordinator ingests whole waves of result files serially.
