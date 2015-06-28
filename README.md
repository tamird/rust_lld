Rust with LLD
=============

Currently tested only on OS X. LLD HEAD refers to [this commit](https://github.com/llvm-mirror/lld/commit/ad256ceb1f5979a07d178db4c569056b526c1850).

Requirements:
- Rust (tested with rustc 1.3.0-nightly (cb7d06215 2015-06-26))
- LLVM with LLD (3.6 or HEAD).
  - OSX: [homebrew](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/llvm.rb)
  - everything else: [HEAD](http://lld.llvm.org/getting_started.html#building-lld)

A note on rustc
---------------
`rustc` doesn't call `ld` or `lld` directly - instead, it calls `cc` and passes linker-specific flags using `-Wl`. On OS X, `cc` is a symlink to `clang`, which is hard-coded to look for `ld`. Fortunately, `clang` takes an undocumented flag, `-B`, to indicate the directory in which to look for `ld`; the `rustc_{dynamic,static}.sh` scripts in this repository use `-B` to redirect `ld` calls to the `lld` under test.

A note on segfaults
-------------------
LLD 3.6 sometimes segfaults when lots of unused symbols are linked. By default, `rustc` always passes `-lpthread -lc -lm`, which triggers this bug. This seems to be fixed in LLD HEAD.

Results
-------
LLD 3.6 is busted as described above. LLD HEAD totally works!
```
$ ./build.sh
Dynamic linking: hacking `clang` to make rustc use lld...
hello world!
Static linking: hacking `clang` to make rustc use lld...
hello world!
Dynamic linking: running `rustc` and then `lld`...
hello world!
Static linking: running `rustc` and then `lld`...
hello world!
```
