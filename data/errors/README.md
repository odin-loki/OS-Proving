# Error dataset

Every error event this project recorded about a function's annotation, plus the original annotations that had errors and every repair attempt, in a form meant for learning (training or evaluating annotation writers, reviewers, and repair models). Built by `tools/build_error_dataset.sh` from the project's data; counts are in `COUNTS.md` (generated). Nothing here contains third-party source code: the records hold our own annotations, the messages checkers produced, and prover output. A function is addressed by `(key, i)`: `key` = `tier:path:start-end` of the chunk, `i` = index of the function in that chunk. The source file at that path and line range is the code the record is about (not included; fetch it from the Linux, FreeBSD/HardenedBSD or KDE tree named by the path).

## Files

| File | Contents |
|---|---|
| `events.jsonl.gz` | One line per error event. Several events per function are normal. |
| `annotations-original.jsonl.gz` | The original machine-written annotation (summary, contract, prose contract, error convention) of every function that has at least one event. |
| `repairs-rNN.jsonl.gz` | Every repair attempt of machine round NN: old error classes are in `events`; this has the new prose and contract. |
| `repairs-hand.jsonl.gz` | Every hand-fix result (agent read the real source): action (fix or drop), new prose, new contract and the reader's note (which carries the reviewer verdicts and what was wrong). |
| `index-by-check.tsv.gz` | Counts of events per function and check, for quick filtering. |
| `COUNTS.md` | Event counts per stage, check and result, and the number of functions with at least one event. |

## Event fields (`events.jsonl.gz`)

| Field | Meaning |
|---|---|
| `key`, `i`, `name`, `kind` | the function; `kind` is the model's category (driver-glue, arith-helper, state-machine, ...) |
| `tree` | `linux`, `freebsd` or `kde` |
| `stage` | `verify` (first checks), `post-repair` (checks on a repaired annotation), `hand-fix`, `prover`, `final` |
| `round` | repair round the event belongs to (0 = original annotation), `hand` for hand-fix, `prove` for the prover |
| `check` | `mechanical`, `contract-grammar`, `frama-c-acsl`, `random-test`, `model-cross-check`, `reader-finding`, `prover`, `status` |
| `result` | outcome where the check has one: Frama-C `fail`/`type`/`unknown`; random-test class (`counterexample-logic`, `counterexample-limits`, `trap`, ...); `disagree`; hand-fix action; prover label (FALSE, FAILED, WPERROR, UNBUILT, CONTRACT-ONLY, VACUOUS) |
| `detail` | the message: what the mechanical check objected to, the Frama-C parse or type message, the random-test counterexample (input values and the contract's and the code's results), the reviewer's reason, the hand-fix reader's note, or the prover's reason and counterexample text |
| `flags` | hand-fix events only: `renamed` (packet name was wrong), `partly_read` (a large function was not fully read), `reviewer_wrong`, `dropped` |
| `final_status`, `final_round` | where the function ended up after all rounds (kept-verified, fixed-agree, fixed-disagree, fixed-unreviewed, still-rejected, rejected-unrepaired, dropped, kept-unchecked) and in which round it was last changed |

## Error classes (what each `check` finds)

- `mechanical`: the contract or summary names an identifier that does not exist in the file, the name is not in its slice, no `requires`, `ensures true`, a non-C name, a prose error code missing from the formal contract, `result` on a void function.
- `contract-grammar`: prose inside the ACSL block, unbalanced brackets, clauses that do not start with requires/ensures/assigns.
- `frama-c-acsl`: Frama-C's own parse or type error on the contract (for example calls to C functions inside ACSL, lowercase `null`, `old(x)` without a backslash, operator-precedence bugs such as `result == (x >> 18) & 0x3`).
- `random-test`: the contract, run on 200,000 random and edge-value inputs, disagrees with the code (`counterexample-logic` = wrong for ordinary inputs; `counterexample-limits` = only at integer limits).
- `model-cross-check`: a second model that read the code disagreed with the annotation and gave a reason (missed error return, wrong constant, overstated "always", wrong callee assumption, wrong precondition).
- `reader-finding`: a human-style read of the real source by an agent; the note records the real function name when the packet name was wrong, the correction to the old prose, and whether the reviewer was right.
- `prover`: the prover's verdict on the contract of a core-tier function (FALSE means refuted, with a counterexample in `detail`).

## Using it

Typical learning tasks: (1) error classification: `detail` and the original annotation -> `check`/class; (2) repair: original annotation plus error events -> the repaired annotation in `repairs-*`; (3) reviewer training: model-cross-check events with the reader's verdict in the hand-fix notes (the notes say whether the reviewer's claim was right, wrong or mixed); (4) counterexample reading: `prover` and `random-test` events with concrete input values.

## Caveats

- Events from the same function can overlap (a function that fails the mechanical check often also fails the Frama-C parse).
- Hand-fix notes are the agents' own words and were not independently audited; the reviewer verdicts in them are approximate.
- A repaired annotation is "fixed" in the sense that it passed the checks and, where reviewed, an independent reviewer agreed. It is not proved.
- `final_status` reflects the state table on the build date in `COUNTS.md`.
