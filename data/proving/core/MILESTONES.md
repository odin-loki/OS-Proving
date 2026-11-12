## 28% (7000 of 24825) at 2026-11-13 00:15:10

## core run

Functions: 7000

### Label by kind

| **all** | 7000 | 690 | 960 | 865 | 595 | 562 | 3287 | 0 | **1650 (23.6%)** |
| allocator | 214 | 7 | 13 | 50 | 17 | 41 | 84 | 0 | 20 (9%) |
| arith-helper | 2966 | 427 | 463 | 211 | 295 | 133 | 1426 | 0 | 890 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 201 | 22 | 38 | 20 | 20 | 8 | 93 | 0 | 60 (30%) |
| bitmask | 21 | 7 | 6 | 0 | 3 | 1 | 4 | 0 | 13 (62%) |
| error-path | 958 | 93 | 142 | 132 | 32 | 63 | 489 | 0 | 235 (25%) |
| init-teardown | 1556 | 100 | 216 | 263 | 194 | 152 | 621 | 0 | 316 (20%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 79 | 0 | 0 | 19 | 0 | 21 | 38 | 0 | 0 (0%) |
| lock-or-sync | 205 | 5 | 22 | 30 | 7 | 35 | 106 | 0 | 27 (13%) |
| parser | 481 | 16 | 36 | 73 | 10 | 68 | 271 | 0 | 52 (11%) |
| refcount | 113 | 1 | 12 | 16 | 6 | 10 | 67 | 0 | 13 (12%) |
| ring-buffer | 205 | 12 | 12 | 51 | 11 | 30 | 87 | 0 | 24 (12%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 20 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 20
- linux: 4432 functions, PROVED 615, PROVED-ASSUMING 828, CONTRACT-ONLY 742, FALSE 514, FAILED 456, UNBUILT 1241
- bsd-kernel: 826 functions, PROVED 2, PROVED-ASSUMING 99, CONTRACT-ONLY 89, FALSE 40, FAILED 54, UNBUILT 538
- linux-tools: 277 functions, PROVED 32, PROVED-ASSUMING 16, CONTRACT-ONLY 7, FALSE 12, FAILED 19, UNBUILT 190
- bsd-user: 1445 functions, PROVED 41, PROVED-ASSUMING 17, CONTRACT-ONLY 27, FALSE 29, FAILED 33, UNBUILT 1298

### Why not built (UNBUILT causes, normalised)

-     252 C++ source
-     118 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     109 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-      83 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-      77 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-      54 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      48 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      41 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      33  syntax error: before or at token: ;
-      28 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      25 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      20 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/athk
-      19 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      18 [kernel:annot-error] unit.c: Warning: unexpected token '{'

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 243
- callees-without-spec: 303
- config: 164
- header-function-in-probe-unit: 250
- pointer-or-memory-precondition: 195
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 23
- probe-adds-module.h-kernel.h-slab.h-device.h: 250
- stub-headers-EMPTY(option-headers-assumed-off): 97
- unwind=10: 32
- unwind=34: 15
- unwind=66: 1

## 28% (7000 of 24825) at 2026-11-13 01:25:06

## core run

Functions: 7377

### Label by kind

| **all** | 7377 | 736 | 1011 | 913 | 627 | 588 | 3461 | 0 | **1747 (23.7%)** |
| allocator | 221 | 8 | 13 | 51 | 17 | 42 | 88 | 0 | 21 (10%) |
| arith-helper | 3129 | 454 | 491 | 224 | 313 | 135 | 1501 | 0 | 945 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 212 | 22 | 40 | 20 | 23 | 9 | 98 | 0 | 62 (29%) |
| bitmask | 22 | 7 | 7 | 0 | 3 | 1 | 4 | 0 | 14 (64%) |
| error-path | 1011 | 99 | 148 | 141 | 34 | 66 | 516 | 0 | 247 (24%) |
| init-teardown | 1634 | 112 | 226 | 275 | 202 | 160 | 649 | 0 | 338 (21%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 87 | 0 | 0 | 21 | 0 | 24 | 41 | 0 | 0 (0%) |
| lock-or-sync | 216 | 5 | 22 | 32 | 7 | 39 | 111 | 0 | 27 (12%) |
| parser | 513 | 16 | 40 | 79 | 10 | 72 | 289 | 0 | 56 (11%) |
| refcount | 118 | 1 | 12 | 17 | 7 | 10 | 70 | 0 | 13 (11%) |
| ring-buffer | 213 | 12 | 12 | 53 | 11 | 30 | 93 | 0 | 24 (11%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 20 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 20
- linux: 4686 functions, PROVED 657, PROVED-ASSUMING 874, CONTRACT-ONLY 785, FALSE 543, FAILED 477, UNBUILT 1314
- bsd-kernel: 866 functions, PROVED 2, PROVED-ASSUMING 103, CONTRACT-ONLY 90, FALSE 40, FAILED 56, UNBUILT 571
- linux-tools: 292 functions, PROVED 34, PROVED-ASSUMING 17, CONTRACT-ONLY 7, FALSE 12, FAILED 20, UNBUILT 201
- bsd-user: 1513 functions, PROVED 43, PROVED-ASSUMING 17, CONTRACT-ONLY 31, FALSE 32, FAILED 35, UNBUILT 1355

### Why not built (UNBUILT causes, normalised)

-     259 C++ source
-     124 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     117 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-      87 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-      80 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-      58 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      50 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      43 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      33  syntax error: before or at token: ;
-      28 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      26 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      20 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      20 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/athk
-      19 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/acpi

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 257
- callees-without-spec: 319
- config: 170
- header-function-in-probe-unit: 268
- pointer-or-memory-precondition: 206
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 24
- probe-adds-module.h-kernel.h-slab.h-device.h: 268
- stub-headers-EMPTY(option-headers-assumed-off): 101
- unwind=10: 33
- unwind=130: 1
- unwind=34: 16
- unwind=66: 1

## 28% (7000 of 24825) at 2026-11-13 03:35:51

## core run

Functions: 9186

### Label by kind

| **all** | 9186 | 890 | 1237 | 1131 | 786 | 730 | 4362 | 0 | **2127 (23.2%)** |
| allocator | 280 | 8 | 15 | 70 | 19 | 51 | 114 | 0 | 23 (8%) |
| arith-helper | 3928 | 565 | 613 | 277 | 391 | 172 | 1898 | 0 | 1178 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 260 | 24 | 48 | 24 | 28 | 14 | 122 | 0 | 72 (28%) |
| bitmask | 26 | 8 | 10 | 0 | 3 | 1 | 4 | 0 | 18 (69%) |
| error-path | 1246 | 113 | 180 | 178 | 44 | 75 | 648 | 0 | 293 (24%) |
| init-teardown | 2015 | 134 | 266 | 333 | 253 | 202 | 815 | 0 | 400 (20%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 117 | 0 | 1 | 31 | 0 | 27 | 56 | 0 | 1 (1%) |
| lock-or-sync | 279 | 6 | 27 | 39 | 10 | 46 | 151 | 0 | 33 (12%) |
| parser | 631 | 18 | 49 | 94 | 17 | 85 | 359 | 0 | 67 (11%) |
| refcount | 138 | 1 | 14 | 20 | 7 | 13 | 81 | 0 | 15 (11%) |
| ring-buffer | 265 | 13 | 14 | 65 | 14 | 44 | 113 | 0 | 27 (10%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 25 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 25
- linux: 5771 functions, PROVED 797, PROVED-ASSUMING 1059, CONTRACT-ONLY 964, FALSE 681, FAILED 594, UNBUILT 1632
- bsd-kernel: 1132 functions, PROVED 4, PROVED-ASSUMING 135, CONTRACT-ONLY 117, FALSE 50, FAILED 70, UNBUILT 752
- linux-tools: 350 functions, PROVED 36, PROVED-ASSUMING 18, CONTRACT-ONLY 11, FALSE 16, FAILED 23, UNBUILT 245
- bsd-user: 1908 functions, PROVED 53, PROVED-ASSUMING 25, CONTRACT-ONLY 39, FALSE 39, FAILED 43, UNBUILT 1708

### Why not built (UNBUILT causes, normalised)

-     318 C++ source
-     171 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     139 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     109 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     103 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-      80 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      64 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      52 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      42  syntax error: before or at token: ;
-      31 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      29 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      28 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      27 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      25 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/athk

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 315
- callees-without-spec: 379
- config: 207
- header-function-in-probe-unit: 336
- pointer-or-memory-precondition: 246
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 28
- probe-adds-module.h-kernel.h-slab.h-device.h: 336
- stub-headers-EMPTY(option-headers-assumed-off): 131
- unwind=10: 41
- unwind=130: 1
- unwind=34: 19
- unwind=66: 1

## 28% (7000 of 24825) at 2026-11-13 04:25:49

## core run

Functions: 9195

### Label by kind

| **all** | 9195 | 890 | 1238 | 1131 | 786 | 731 | 4369 | 0 | **2128 (23.1%)** |
| allocator | 281 | 8 | 15 | 70 | 19 | 51 | 115 | 0 | 23 (8%) |
| arith-helper | 3933 | 565 | 614 | 277 | 391 | 172 | 1902 | 0 | 1179 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 260 | 24 | 48 | 24 | 28 | 14 | 122 | 0 | 72 (28%) |
| bitmask | 26 | 8 | 10 | 0 | 3 | 1 | 4 | 0 | 18 (69%) |
| error-path | 1246 | 113 | 180 | 178 | 44 | 75 | 648 | 0 | 293 (24%) |
| init-teardown | 2017 | 134 | 266 | 333 | 253 | 203 | 816 | 0 | 400 (20%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 117 | 0 | 1 | 31 | 0 | 27 | 56 | 0 | 1 (1%) |
| lock-or-sync | 279 | 6 | 27 | 39 | 10 | 46 | 151 | 0 | 33 (12%) |
| parser | 631 | 18 | 49 | 94 | 17 | 85 | 359 | 0 | 67 (11%) |
| refcount | 138 | 1 | 14 | 20 | 7 | 13 | 81 | 0 | 15 (11%) |
| ring-buffer | 266 | 13 | 14 | 65 | 14 | 44 | 114 | 0 | 27 (10%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 25 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 25
- linux: 5779 functions, PROVED 797, PROVED-ASSUMING 1060, CONTRACT-ONLY 964, FALSE 681, FAILED 594, UNBUILT 1639
- bsd-kernel: 1133 functions, PROVED 4, PROVED-ASSUMING 135, CONTRACT-ONLY 117, FALSE 50, FAILED 71, UNBUILT 752
- linux-tools: 350 functions, PROVED 36, PROVED-ASSUMING 18, CONTRACT-ONLY 11, FALSE 16, FAILED 23, UNBUILT 245
- bsd-user: 1908 functions, PROVED 53, PROVED-ASSUMING 25, CONTRACT-ONLY 39, FALSE 39, FAILED 43, UNBUILT 1708

### Why not built (UNBUILT causes, normalised)

-     318 C++ source
-     171 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     139 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     109 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     103 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-      80 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      64 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      52 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      42  syntax error: before or at token: ;
-      31 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      29 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      28 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      27 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      25 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/athk

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 315
- callees-without-spec: 380
- config: 207
- header-function-in-probe-unit: 336
- pointer-or-memory-precondition: 246
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 28
- probe-adds-module.h-kernel.h-slab.h-device.h: 336
- stub-headers-EMPTY(option-headers-assumed-off): 131
- unwind=10: 41
- unwind=130: 1
- unwind=34: 19
- unwind=66: 1

## 28% (7000 of 24825) at 2026-11-13 04:52:32

## core run

Functions: 9389

### Label by kind

| **all** | 9389 | 914 | 1258 | 1157 | 806 | 748 | 4455 | 0 | **2172 (23.1%)** |
| allocator | 286 | 8 | 17 | 71 | 19 | 51 | 117 | 0 | 25 (9%) |
| arith-helper | 4028 | 578 | 626 | 287 | 403 | 178 | 1943 | 0 | 1204 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 266 | 24 | 49 | 25 | 28 | 14 | 126 | 0 | 73 (27%) |
| bitmask | 26 | 8 | 10 | 0 | 3 | 1 | 4 | 0 | 18 (69%) |
| error-path | 1264 | 115 | 182 | 180 | 44 | 76 | 659 | 0 | 297 (23%) |
| init-teardown | 2061 | 139 | 269 | 338 | 261 | 209 | 833 | 0 | 408 (20%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 121 | 0 | 1 | 33 | 0 | 27 | 58 | 0 | 1 (1%) |
| lock-or-sync | 284 | 7 | 27 | 41 | 10 | 46 | 153 | 0 | 34 (12%) |
| parser | 642 | 21 | 49 | 96 | 17 | 88 | 362 | 0 | 70 (11%) |
| refcount | 144 | 1 | 14 | 21 | 7 | 14 | 85 | 0 | 15 (10%) |
| ring-buffer | 266 | 13 | 14 | 65 | 14 | 44 | 114 | 0 | 27 (10%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 26 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 26
- linux: 5912 functions, PROVED 818, PROVED-ASSUMING 1075, CONTRACT-ONLY 985, FALSE 700, FAILED 610, UNBUILT 1679
- bsd-kernel: 1153 functions, PROVED 4, PROVED-ASSUMING 140, CONTRACT-ONLY 119, FALSE 51, FAILED 71, UNBUILT 764
- linux-tools: 358 functions, PROVED 37, PROVED-ASSUMING 18, CONTRACT-ONLY 12, FALSE 16, FAILED 24, UNBUILT 250
- bsd-user: 1940 functions, PROVED 55, PROVED-ASSUMING 25, CONTRACT-ONLY 41, FALSE 39, FAILED 43, UNBUILT 1736

### Why not built (UNBUILT causes, normalised)

-     326 C++ source
-     172 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     143 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     111 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     103 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-      80 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      65 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      53 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      42  syntax error: before or at token: ;
-      32 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      30 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      29 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      27 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      26 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/krb5/src/lib/

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 321
- callees-without-spec: 389
- config: 211
- header-function-in-probe-unit: 337
- pointer-or-memory-precondition: 248
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 29
- probe-adds-module.h-kernel.h-slab.h-device.h: 337
- stub-headers-EMPTY(option-headers-assumed-off): 136
- unwind=10: 42
- unwind=130: 1
- unwind=34: 19
- unwind=66: 1

## 52% (13000 of 24825) at 2026-11-13 06:35:49

## core run

Functions: 13000

### Label by kind

| **all** | 13000 | 1256 | 1773 | 1577 | 1151 | 1043 | 6132 | 0 | **3029 (23.3%)** |
| allocator | 384 | 8 | 24 | 96 | 25 | 66 | 160 | 0 | 32 (8%) |
| arith-helper | 5612 | 783 | 902 | 386 | 575 | 250 | 2697 | 0 | 1685 (30%) |
| bit-op | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 (0%) |
| bitmap | 378 | 36 | 73 | 33 | 36 | 17 | 183 | 0 | 109 (29%) |
| bitmask | 36 | 10 | 16 | 0 | 3 | 2 | 5 | 0 | 26 (72%) |
| error-path | 1768 | 164 | 239 | 251 | 67 | 109 | 926 | 0 | 403 (23%) |
| init-teardown | 2830 | 201 | 368 | 457 | 367 | 289 | 1133 | 0 | 569 (20%) |
| kind | n | PROVED | PROVED-ASSUMING | CONTRACT-ONLY | FALSE | FAILED | UNBUILT | BOUNDED | proved (P+PA) |
| list-op | 168 | 0 | 2 | 45 | 0 | 38 | 81 | 0 | 2 (1%) |
| lock-or-sync | 401 | 9 | 40 | 58 | 22 | 64 | 208 | 0 | 49 (12%) |
| parser | 864 | 27 | 71 | 138 | 27 | 118 | 472 | 0 | 98 (11%) |
| refcount | 202 | 2 | 21 | 30 | 8 | 20 | 119 | 0 | 23 (11%) |
| ring-buffer | 356 | 16 | 17 | 83 | 21 | 70 | 147 | 0 | 33 (9%) |
|---|---|---|---|---|---|---|---|---|---|

### Label by tree

- other: 38 functions, PROVED 0, PROVED-ASSUMING 0, CONTRACT-ONLY 0, FALSE 0, FAILED 0, UNBUILT 38
- linux: 8230 functions, PROVED 1133, PROVED-ASSUMING 1517, CONTRACT-ONLY 1347, FALSE 999, FAILED 854, UNBUILT 2320
- bsd-kernel: 1603 functions, PROVED 7, PROVED-ASSUMING 194, CONTRACT-ONLY 165, FALSE 73, FAILED 99, UNBUILT 1060
- linux-tools: 493 functions, PROVED 51, PROVED-ASSUMING 28, CONTRACT-ONLY 14, FALSE 27, FAILED 32, UNBUILT 340
- bsd-user: 2636 functions, PROVED 65, PROVED-ASSUMING 34, CONTRACT-ONLY 51, FALSE 52, FAILED 58, UNBUILT 2374

### Why not built (UNBUILT causes, normalised)

-     461 C++ source
-     231 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/llvm-project
-     194 [kernel:annot-error] unit.c: Warning: unbound logic variable true. Ignoring logic specific
-     153 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/sys/vnode.h:629:
-     134 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/test/
-     106 [kernel] unit.c: User Error: bitfield width is not a valid integer constant [kernel] Frama
-      91 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssl/crypt
-      73 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/openssh/inclu
-      54  syntax error: before or at token: ;
-      40 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/openzfs/
-      38 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/sys/contrib/dev/rtw8
-      38 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/processor-tr
-      36 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/contrib/libarchive/l
-      35 preprocess failed: /mnt/c/ParanoidBSD/dreamy-mahavira-7e0e79/hbsd/src/crypto/krb5/src/lib/

### Per-unit assumptions on proved functions (count)

- bv-sat-uncertified: 476
- callees-without-spec: 526
- config: 289
- header-function-in-probe-unit: 499
- pointer-or-memory-precondition: 333
- pointers-modelled-as-disjoint-malloc-objects(no-aliasing,sizes-from-valid): 41
- probe-adds-module.h-kernel.h-slab.h-device.h: 499
- stub-headers-EMPTY(option-headers-assumed-off): 190
- unwind=10: 62
- unwind=130: 1
- unwind=34: 23
- unwind=66: 2

## 76% (19000 of 24825) at 2026-11-13 10:03:21

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

