## core run

Functions: 17967

### Label by kind

| **all** | 17967 | 1725 | 2475 | 2194 | 1576 | 1411 | 8491 | 0 | **4200 (23.4%)** |
| allocator | 527 | 12 | 36 | 126 | 39 | 79 | 228 | 0 | 48 (9%) |
| arith-helper | 7679 | 1059 | 1217 | 565 | 773 | 330 | 3706 | 0 | 2276 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 513 | 47 | 103 | 46 | 43 | 22 | 252 | 0 | 150 (29%) |
| bitmask | 47 | 11 | 24 | 0 | 4 | 3 | 5 | 0 | 35 (74%) |
| error-path | 2467 | 225 | 354 | 342 | 88 | 151 | 1291 | 0 | 579 (23%) |
| init-teardown | 3981 | 288 | 540 | 625 | 519 | 412 | 1579 | 0 | 828 (21%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 238 | 1 | 5 | 64 | 2 | 49 | 115 | 0 | 6 (3%) |
| lock-or-sync | 552 | 13 | 55 | 82 | 31 | 81 | 290 | 0 | 68 (12%) |
| parser | 1211 | 45 | 91 | 197 | 36 | 160 | 665 | 0 | 136 (11%) |
| refcount | 272 | 2 | 23 | 42 | 14 | 27 | 161 | 0 | 25 (9%) |
| ring-buffer | 479 | 22 | 27 | 105 | 27 | 97 | 198 | 0 | 49 (10%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 57 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 57
- linux: 11405 functions, PROVED 1558, PROVED-ASSUMING 2111, CONTRACT-ONLY 1878, FALSE 1374, FAILED 1162, UNBUILT 3238
- bsd-kernel: 2176 functions, PROVED 11, PROVED-ASSUMING 277, CONTRACT-ONLY 218, FALSE 101, FAILED 128, UNBUILT 1435
- linux-tools: 654 functions, PROVED 64, PROVED-ASSUMING 34, CONTRACT-ONLY 23, FALSE 33, FAILED 41, UNBUILT 458
- bsd-user: 3675 functions, PROVED 92, PROVED-ASSUMING 53, CONTRACT-ONLY 75, FALSE 68, FAILED 80, UNBUILT 3303

### Why not built (UNBUILT causes, normalised)

-     612 C++ source
-     334 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     264 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     210 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     185 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-     136 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-     116 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      99 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      74  syntax error: before or at token: ;
-      58 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      51 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      47 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      46 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/krb5/src/lib/
-      44 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 665
- callees-without-spec: 741
- config: 417
- header-function-in-probe-unit: 691
- pointer-or-memory-precondition: 464
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 58
- probe-adds-module.h-kernel.h-slab.h-device.h: 691
- stub-headers-EMPTY(option-headers-assumed-off): 270
- unwind=10: 85
- unwind=130: 4
- unwind=34: 31
- unwind=66: 2
