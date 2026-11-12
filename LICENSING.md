# OS-Proving licensing

**Author and copyright holder:** Odin Loch (Imortek), <odin.loch@outlook.com.au>
**Default licence:** [GNU Affero General Public License v3.0 or later](LICENSE) (`AGPL-3.0-or-later`), the same licence as ParanoidBSD and the other Imortek repositories.
**Commercial alternative:** [COMMERCIAL-LICENCE.md](COMMERCIAL-LICENCE.md)

This file is the authoritative statement of what licence applies to what in this
repository. Where any other document in the tree disagrees with this one, this
one wins.

## 1. What is licensed

| Path | Licence | Origin |
|---|---|---|
| `README.md`, `LICENSE`, `LICENSING.md`, `NOTICES.md`, root files | `AGPL-3.0-or-later` | Original |
| `docs/` | `AGPL-3.0-or-later` | Original: plans, reports, method notes |
| `tools/` | `AGPL-3.0-or-later` | Original: mining, verification, repair, proving and packaging scripts |
| `data/` | `AGPL-3.0-or-later` for the annotations, labels, contracts, prose and results that this project produced | Original, **derived from** the third-party code listed in section 2 (see section 3) |

## 2. Third-party code this work refers to

OS-Proving analyses the Linux kernel, FreeBSD / HardenedBSD and KDE sources. **None
of that source is relicensed here and none of it is redistributed in this
repository.** Records refer to it by repository path and line range only, so a
reader fetches the original source from its own upstream.

| Subject of the analysis | Upstream licence (predominantly) |
|---|---|
| Linux kernel | `GPL-2.0-only` with the syscall exception |
| FreeBSD / HardenedBSD | `BSD-2-Clause`, `BSD-3-Clause` and others, per file |
| KDE Plasma and Frameworks | `GPL-2.0-or-later` / `LGPL-2.1-or-later` |

Each upstream keeps its own terms. Nothing in this repository grants rights to it.

## 3. Derived annotations

The prose contracts, formal contracts, labels and proof outcomes under `data/` are
statements about third-party functions. They are original text written for this
project, but a statement about a function can quote or paraphrase its code. Before
any commercial or government use of the data, a human legal review of that
derivation is required (see `docs/plan/lib/code-mined/SELLABLE_PLAN.md`, section 3, S6). This
repository makes no claim that such a review has been done.

## 4. Running this as a service

If you run a service built from the code in `tools/` that users reach over a
network, AGPL section 13 applies: you must offer them the corresponding source.
