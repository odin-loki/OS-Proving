## core run

Functions: 24806

### Label by kind

| **all** | 24806 | 2388 | 3467 | 2982 | 2148 | 1957 | 11730 | 0 | **5855 (23.6%)** |
| allocator | 741 | 20 | 59 | 173 | 50 | 110 | 321 | 0 | 79 (11%) |
| arith-helper | 10505 | 1434 | 1689 | 753 | 1044 | 448 | 5088 | 0 | 3123 (30%) |
| bit-op | 2 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 676 | 62 | 130 | 62 | 58 | 31 | 332 | 0 | 192 (28%) |
| bitmask | 62 | 15 | 29 | 1 | 7 | 3 | 7 | 0 | 44 (71%) |
| error-path | 3464 | 317 | 509 | 468 | 126 | 210 | 1814 | 0 | 826 (24%) |
| init-teardown | 5567 | 407 | 770 | 862 | 710 | 594 | 2197 | 0 | 1177 (21%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 315 | 2 | 11 | 90 | 3 | 59 | 148 | 0 | 13 (4%) |
| lock-or-sync | 762 | 24 | 68 | 102 | 44 | 112 | 412 | 0 | 92 (12%) |
| parser | 1679 | 71 | 129 | 268 | 51 | 209 | 931 | 0 | 200 (12%) |
| refcount | 383 | 4 | 34 | 58 | 18 | 45 | 221 | 0 | 38 (10%) |
| ring-buffer | 650 | 32 | 39 | 145 | 36 | 136 | 258 | 0 | 71 (11%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 81 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 81
- linux: 15661 functions, PROVED 2144, PROVED-ASSUMING 2960, CONTRACT-ONLY 2530, FALSE 1862, FAILED 1607, UNBUILT 4441
- bsd-kernel: 3005 functions, PROVED 15, PROVED-ASSUMING 378, CONTRACT-ONLY 307, FALSE 147, FAILED 180, UNBUILT 1969
- linux-tools: 908 functions, PROVED 91, PROVED-ASSUMING 48, CONTRACT-ONLY 34, FALSE 42, FAILED 56, UNBUILT 635
- bsd-user: 5151 functions, PROVED 138, PROVED-ASSUMING 81, CONTRACT-ONLY 111, FALSE 97, FAILED 114, UNBUILT 4604

### Why not built (UNBUILT causes, normalised)

-     846 C++ source
-     442 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     378 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     278 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     267 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-     175 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-     171 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-     133 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-     106  syntax error: before or at token: ;
-      85 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      70 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      64 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      59 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      57 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/krb5/src/lib/

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 911
- callees-without-spec: 1066
- config: 599
- header-function-in-probe-unit: 965
- pointer-or-memory-precondition: 642
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 75
- probe-adds-module.h-kernel.h-slab.h-device.h: 965
- stub-headers-EMPTY(option-headers-assumed-off): 369
- unwind=10: 126
- unwind=130: 6
- unwind=34: 40
- unwind=66: 2
