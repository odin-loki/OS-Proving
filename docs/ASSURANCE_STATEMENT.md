# What this project proves, how it compares with seL4, and what comes next

Counts in this document are copied from the generated tables (`docs/ERRORS_FOUND.md`, `data/status/`, `data/proving/core/summary.md`); if they disagree with a generated table, the table is right.

## 1. In one paragraph

We took 1,135,593 functions of Linux, FreeBSD/HardenedBSD and KDE, wrote a formal annotation for each, and ran every annotation through an independent pipeline: mechanical checks, the Frama-C parser, random testing, a second model that reads code and claim, hand-fixing by reading the real source, and, for a 24,806-function core of small functions, a machine prover (Frama-C WP with Alt-Ergo, Z3 and CVC5). Result: **5,855 functions carry a machine-checked proof** (2,388 proved outright, 3,467 proved under stated assumptions), **527,395 are verified** (passed every check and an independent reader, which is weaker than proved and always labelled that way), and **173,710 annotations that were wrong, or that no checker could accept, were found** (114,700 of them repaired or dropped; 59,010 driver-glue functions not yet attempted). Nothing in the corpus is labelled "proved" unless a prover closed it.

This is a corpus of checked evidence at a scale that nobody has attempted with a formal tool, not a verified operating system.

## 2. Comparison with seL4

seL4 is the benchmark for "an operating-system kernel that is proved correct". Its figures (from the project's own papers and statistics page, [Klein et al., CACM 2010](https://cacmb4.acm.org/magazines/2010/6/92498-sel4-formal-verification-of-an-operating-system-kernel) and [trustworthy.systems](https://trustworthy.systems/projects/OLD/l4.verified/numbers)): about 8,700 lines of C and 600 of assembler, a functional-correctness proof in Isabelle/HOL of about 200,000 lines of hand-written proof script, about 25 person-years for the whole project of which about 12 were the kernel proof itself. The proof shows that the C implementation refines a complete abstract specification of the whole kernel; it assumes the compiler, the assembler, the boot code and the hardware are correct.

| | seL4 | This project |
|---|---|---|
| Code covered | one small kernel, about 8,700 lines of C | 1,135,593 functions across three code bases |
| Claim per function | refinement of the whole kernel against one abstract specification | each function meets its own written contract (what it returns, what it may touch) |
| Specification | one complete, hand-written, reviewed spec | one contract per function, machine-written, then checked, repaired and audited |
| Proof engine | Isabelle/HOL, interactive, hand-written proof | Frama-C WP with Alt-Ergo, Z3 and CVC5, automatic |
| Proof effort | about 12 person-years for the kernel proof | machine time plus agent reading; no per-function human proof |
| Whole-system properties | yes (isolation, information flow, later work) | no |
| Honest limits | trusted compiler, assembler, hardware | the same, plus: contracts are local, no system-level specification, many functions only reviewed |
| Proved functions | the whole kernel | 5,855 of 24,806 attempted (23.6%); 2,388 outright, 3,467 under assumptions |

The two are different products. seL4 gives the strongest possible statement about a very small piece of code. This gives a measured, labelled statement about a very large amount of code that is far too big and too awkward to prove the seL4 way.

## 3. Why we did not prove more of it to that level

1. **A proof needs a specification, and writing it is the expensive part.** seL4's abstract specification and its refinement proof were written by experts over years. We generated one contract per function by machine. When we checked them, 15.3% of the first-round annotations failed a check or drew a reviewer objection. A wrong contract cannot be proved, so the checking had to come before the proving.
2. **The code is not designed for proof.** seL4 was written in a restricted C subset, for verification, with a Haskell prototype as a bridge. Linux and FreeBSD are millions of lines of pointer-heavy, lock-heavy, global-state-heavy C with inline assembler and macros. A function that takes a lock, walks a list through a pointer and calls a callback needs a model of memory and of its callees before any contract about it can be closed. Our automatic provers close the contracts of small pure-style functions (arithmetic, bit masks, parsers, small state machines); that is where almost all of the 23.6% sits.
3. **Nearly half the core did not build.** 11,730 of the 24,806 core functions are UNBUILT: the translation unit did not build under our reconstructed kernel configuration. That is a toolchain problem, not a mathematical limit, and it is the cheapest thing to fix.
4. **2,148 contracts were refuted** (FALSE) by the prover. That is a result, not a failure: those annotations looked right in prose and survived review, and a prover showed they were wrong.
5. **Scale rules out hand proofs.** At seL4's rate, roughly 1.4 person-years per thousand lines, a hand proof of even a few per cent of this corpus is out of reach. Automatic proof of small functions, plus checking everything else, is the only route that scales.

## 4. What can be done next

Each of these is measured against the numbers above, not promised:

1. **Fix the build and re-run the 11,730 unbuilt functions.** Cheapest, largest expected gain in proved count.
2. **Prove absence of runtime errors, with no contract needed.** Frama-C's runtime-error analysis and CBMC need no written contract and run on any function that builds. They turn "reviewed" into "proved free of out-of-bounds access, overflow and null dereference" for a large share of the corpus. This is the realistic route to a machine-checked claim on most functions.
3. **Grow the contract proofs to every pure and arithmetic-style function**, about tens of thousands more.
4. **Take a security-critical slice (a few hundred functions: crypto glue, allocators, parsers, packet handlers) the seL4 way**: hand-written complete specifications, interactive proof where the automatic provers stop. This is the step that produces seL4-grade statements, on the code that matters most.
5. **Independent large-sample audits** of everything that is not proved, so that every "verified" claim carries a measured error rate (see section 5).
6. **Report the flagged source defects** (about 60 leads, `docs/ERRORS_FOUND.md` section 6) to maintainers after each is reproduced.

## 5. How reliable the claims are: random-sample audits

Counts of "verified" tell you how many functions passed the checks, not how many are right. To measure the second number we draw random samples, check them independently, and report an error rate with a confidence interval. Sample sizes are chosen so the interval is tight enough to quote: a sample of 20,000 gives about plus or minus 0.3 percentage points at 95% confidence at an error rate near 5%. Samples are stratified by code base and function kind, drawn by seeded script (seed recorded, sample list committed). Results are in `data/proving/core/audit.md` and the audit tables next to it, and flow into `docs/ERRORS_FOUND.md`.

## 6. What we claim, and what we do not

We claim: every function in the corpus carries a label that says exactly which checks it passed; every "proved" is a machine-checked proof; every count is produced by script from committed data; errors we found are listed with counts.

We do not claim: that the 527,395 "verified" functions are correct (they are reviewed, with a measured error rate once the audit finishes); that any function is secure or free of bugs because it is labelled; or that this replaces a whole-system proof like seL4's.

## 7. Why it is still worth having

- It is the only formal-tool corpus of this size over real operating-system code, with a label per function and a reproducible pipeline.
- It found and quantified problems at scale: 173,710 annotations that were wrong or unacceptable, 2,148 refuted by a prover, about 60 possible source defects.
- It shows exactly where the next unit of proof effort pays most (the unbuilt functions, the runtime-error proofs, the security-critical slice), because every gap is a labelled row, not a guess.
- Re-running it on a new kernel release is machine time, not a new proof project.
