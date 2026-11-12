## core run

Functions: 19000

### Label by kind

| **all** | 19000 | 1823 | 2613 | 2313 | 1670 | 1498 | 8975 | 0 | **4436 (23.3%)** |
| allocator | 558 | 12 | 38 | 137 | 41 | 82 | 241 | 0 | 50 (9%) |
| arith-helper | 8097 | 1121 | 1289 | 589 | 818 | 346 | 3899 | 0 | 2410 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 539 | 48 | 105 | 47 | 46 | 24 | 269 | 0 | 153 (28%) |
| bitmask | 50 | 13 | 25 | 0 | 4 | 3 | 5 | 0 | 38 (76%) |
| error-path | 2633 | 235 | 375 | 366 | 96 | 163 | 1379 | 0 | 610 (23%) |
| init-teardown | 4221 | 304 | 571 | 658 | 549 | 438 | 1680 | 0 | 875 (21%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 253 | 1 | 5 | 70 | 3 | 52 | 120 | 0 | 6 (2%) |
| lock-or-sync | 583 | 14 | 56 | 85 | 32 | 88 | 308 | 0 | 70 (12%) |
| parser | 1280 | 50 | 95 | 210 | 38 | 167 | 703 | 0 | 145 (11%) |
| refcount | 285 | 2 | 25 | 44 | 15 | 31 | 165 | 0 | 27 (9%) |
| ring-buffer | 500 | 23 | 29 | 107 | 28 | 104 | 205 | 0 | 52 (10%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 62 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 62
- linux: 12042 functions, PROVED 1644, PROVED-ASSUMING 2227, CONTRACT-ONLY 1978, FALSE 1453, FAILED 1232, UNBUILT 3413
- bsd-kernel: 2300 functions, PROVED 11, PROVED-ASSUMING 294, CONTRACT-ONLY 231, FALSE 110, FAILED 137, UNBUILT 1511
- linux-tools: 694 functions, PROVED 68, PROVED-ASSUMING 36, CONTRACT-ONLY 24, FALSE 34, FAILED 44, UNBUILT 486
- bsd-user: 3902 functions, PROVED 100, PROVED-ASSUMING 56, CONTRACT-ONLY 80, FALSE 73, FAILED 85, UNBUILT 3503

### Why not built (UNBUILT causes, normalised)

-     650 C++ source
-     352 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     281 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     225 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     205 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-     139 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-     118 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-     106 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      79  syntax error: before or at token: ;
-      63 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      52 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      47 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      47 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/krb5/src/lib/
-      46 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 703
- callees-without-spec: 784
- config: 441
- header-function-in-probe-unit: 735
- pointer-or-memory-precondition: 489
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 59
- probe-adds-module.h-kernel.h-slab.h-device.h: 735
- stub-headers-EMPTY(option-headers-assumed-off): 287
- unwind=10: 92
- unwind=130: 4
- unwind=34: 34
- unwind=66: 2
