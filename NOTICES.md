# Notices

OS-Proving refers to and builds on the work of others. This file credits it. None of the third-party source code named here is included in this repository.

## Code that is analysed

| Project | Licence (predominantly) | Notes |
|---|---|---|
| Linux kernel and tools | GPL-2.0-only with the Linux syscall note | Functions are annotated and, where possible, proved. Referenced by path and line range only. |
| FreeBSD and HardenedBSD | BSD-2-Clause, BSD-3-Clause and others, per file | As above. |
| KDE Plasma and Frameworks | GPL-2.0-or-later, LGPL-2.1-or-later | As above. |

## Tools used by the scripts

Frama-C and its WP plugin, Why3, Alt-Ergo, Z3, CVC5 and CBMC, each under the licence its own project publishes. They are installed separately and are not redistributed here.

## Models

Annotations, repairs and reviews were produced with language models served through Morph (GLM-5.3 Flash, DeepSeek V4.1 Flash) and with Claude models (Anthropic). Model output is checked by script and review as described in the README, and is never presented as proved unless a prover accepted it.
