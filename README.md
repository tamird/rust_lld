Rust with LLD
=============

Currently tested only on OS X. LLD HEAD refers to [this commit](https://github.com/llvm-mirror/lld/commit/2b6e20be5943c4d72d3c515215c99934221ecf95).

Requirements:
- Rust (tested with 2015-04-30 nightly)
- LLVM with LLD (3.6 or HEAD).
  - 3.6 on OS X: [homebrew-versions](https://github.com/Homebrew/homebrew-versions/blob/master/llvm36.rb), [homebrew](https://github.com/Homebrew/homebrew/pull/37260)
  - [HEAD](http://lld.llvm.org/getting_started.html#building-lld)

A note on rustc
---------------
`rustc` doesn't call `ld` or `lld` directly - instead, it calls `cc` and passes linker-specific flags using `-Wl`. On OS X, `cc` is a symlink to `clang`, which is hard-coded to look for `ld`. Fortunately, `clang` takes an undocumented flag, `-B`, to indicate the directory in which to look for `ld`; the `rustc_{dynamic,static}.sh` scripts in this repository use `-B` to redirect `ld` calls to the `lld` under test.

A note on segfaults
-------------------
LLD 3.6 sometimes segfaults when lots of unused symbols are linked. By default, `rustc` always passes `-lpthread -lc -lm`, which triggers this bug. This seems to be fixed in LLD HEAD.

Results
-------
- Dynamic linking works without caveats. This is good!
- Static linking is a somewhat more troublesome:
  - LLD 3.6: linking appears to work, but the generated binary immediately dies:

    ```
    $ target/hello_world
    Bus error: 10
    ```
  - LLD HEAD: linking fails:

    ```
    Undefined symbol: target/hello_world.o: rt::lang_start::h5ce5aec5764596439Pv
    Undefined symbol: /Users/tamird/.multirust/toolchains/nightly/lib/rustlib/x86_64-apple-darwin/lib/libmorestack.a(morestack.o): _rust_stack_exhausted
    Undefined symbol: target/hello_world.o: io::stdio::_print::hb801fe988355e929YKg
    symbol(s) not found
    ```
