Rust with LLD
=============

Currently tested only on OS X. LLD HEAD refers to [this commit](https://github.com/llvm-mirror/lld/commit/a19814a4cf206cde9631fa988745a5b278f88186).

Requirements:
- rustc (tested with: rustc 1.3.0-nightly (d33cab1b1 2015-07-22))
- LLD HEAD:
  - OSX: [`brew install llvm --HEAD --with-lld`](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/llvm.rb)
  - everything else: [HEAD](http://lld.llvm.org/getting_started.html#building-lld)

A note on rustc
---------------
`rustc` doesn't call `ld` or `lld` directly - instead, it calls `cc` and passes linker-specific flags using `-Wl`. On OS X, `cc` is a symlink to `clang`, which is hard-coded to look for `ld`. Fortunately, `clang` takes an undocumented flag, `-B`, to indicate the directory in which to look for `ld`; the `rustc_{dynamic,static}.sh` scripts in this repository use `-B` to redirect `ld` calls to the `lld` under test.

Results
-------
Unwinding fails. I was able to run the `rustc` tests in stage1 with `lld` and the only failures were unwinding related.
```console
$ ./build.sh
Dynamic linking: vanilla `rustc`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2

Static linking: vanilla `rustc`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2

Dynamic linking: running `rustc` and then `ld`...
ld: warning: -macosx_version_min not specified, assuming 10.10
thread '<main>' panicked at 'hello world!', hello_world.rs:2

Static linking: running `rustc` and then `ld`...
ld: warning: -macosx_version_min not specified, assuming 10.10
thread '<main>' panicked at 'hello world!', hello_world.rs:2

Dynamic linking: hacking `clang` to make rustc use `lld`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2
fatal runtime error: Could not unwind stack, error = 5
./rustc_dynamic.sh: line 9: 34283 Illegal instruction: 4  DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE

Static linking: hacking `clang` to make rustc use `lld`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2
fatal runtime error: Could not unwind stack, error = 5
./rustc_static.sh: line 9: 34320 Illegal instruction: 4  target/$FILE

Dynamic linking: running `rustc` and then `lld`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2
fatal runtime error: Could not unwind stack, error = 5
./manual_dynamic.sh: line 13: 34360 Illegal instruction: 4  DYLD_LIBRARY_PATH=$RUSTLIB target/$FILE

Static linking: running `rustc` and then `lld`...
thread '<main>' panicked at 'hello world!', hello_world.rs:2
fatal runtime error: Could not unwind stack, error = 5
./manual_static.sh: line 11: 34393 Illegal instruction: 4  target/$FILE
```
